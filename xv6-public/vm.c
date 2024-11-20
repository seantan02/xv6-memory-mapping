#include "param.h"
#include "types.h"
#include "defs.h"
#include "x86.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "elf.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "fs.h"
#include "file.h"

extern char data[];  // defined by kernel.ld
pde_t *kpgdir;  // for use in scheduler()

// fileseek and fileread
extern int fileread(struct file *f, char *addr, int n);
extern unsigned char cow_ref_counts[];
struct spinlock cow_lock;

void
init_cow()
{
  initlock(&cow_lock, "cow_lock");
  memset(cow_ref_counts, 0, 1*1024*1024);
}

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
  struct cpu *c;

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
  lgdt(c->gdt, sizeof(c->gdt));
}

// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}

// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}

// There is one page table per process, plus one that's used when
// a CPU is not running any process (kpgdir). The kernel uses the
// current process's page table during system calls and interrupts;
// page protection bits prevent user code from using the kernel's
// mappings.
//
// setupkvm() and exec() set up every page table like this:
//
//   0..KERNBASE: user memory (text+data+stack+heap), mapped to
//                phys memory allocated by the kernel
//   KERNBASE..KERNBASE+EXTMEM: mapped to 0..EXTMEM (for I/O space)
//   KERNBASE+EXTMEM..data: mapped to EXTMEM..V2P(data)
//                for the kernel's instructions and r/o data
//   data..KERNBASE+PHYSTOP: mapped to V2P(data)..PHYSTOP,
//                                  rw data + free physical memory
//   0xfe000000..0: mapped direct (devices such as ioapic)
//
// The kernel allocates physical memory for its heap and for user memory
// between V2P(end) and the end of physical memory (PHYSTOP)
// (directly addressable from end..P2V(PHYSTOP)).

// This table defines the kernel's mappings, which are present in
// every process's page table.
static struct kmap {
  void *virt;
  uint phys_start;
  uint phys_end;
  int perm;
} kmap[] = {
 { (void*)KERNBASE, 0,             EXTMEM,    PTE_W}, // I/O space
 { (void*)KERNLINK, V2P(KERNLINK), V2P(data), 0},     // kern text+rodata
 { (void*)data,     V2P(data),     PHYSTOP,   PTE_W}, // kern data+memory
 { (void*)DEVSPACE, DEVSPACE,      0,         PTE_W}, // more devices
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
    }
  return pgdir;
}

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
  kpgdir = setupkvm();
  switchkvm();
}

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
}

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");

  pushcli();
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
}

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
  set_count(V2P(mem), 1);
}

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz, uint flags)
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");

  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;

    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;

	*pte &= ~PTE_W;
	if(flags & PTE_W)
	  *pte |= PTE_W;  
  }
  return 0;
}

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
    }
	set_count(V2P(mem), 1);
  }
  return newsz;
}

// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
	  if(get_count(pa) > 0) continue;
      char *v = P2V(pa);
	  kfree(v);
	  *pte = 0;
    }
  }
  return newsz;
}

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");

  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
    if(pgdir[i] & PTE_P){
	  if(get_count(PTE_ADDR(pgdir[i])) > 0) continue;
      char * v = P2V(PTE_ADDR(pgdir[i]));
	  kfree(v);
    }
  }
  kfree((char*)pgdir);
}

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
  *pte &= ~PTE_U;
}

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
	// if writable
	if(flags & PTE_W){
	  flags &= ~PTE_W;
	  flags |= PTE_COW;
	  flags |= PTE_P | PTE_U;
	  *pte &= ~PTE_W;
	  *pte |= PTE_COW;
	  *pte |= PTE_P | PTE_U;
	}
	if(mappages(d, (void*)i, PGSIZE, pa, flags) < 0) {
      goto bad;
    }
	inc_count(pa);
	lcr3(V2P(pgdir));
	lcr3(V2P(d));
  }
  return d;

bad:
  freevm(d);
  return 0;
}

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}

// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}

//PAGEBREAK!
// Blank page.
//PAGEBREAK!
// Blank page.
//PAGEBREAK!
// Blank page.

// helper function to check if 2 virtual address each with a length intersect
// return 0 if no intersection, 1 if they intersect;
/*int vasIntersect(uint addr1, int length1, uint addr2, int length2){
  if(addr1 == addr2 && length1 > 0 && length2 > 0) return 1;
  if(addr1 < addr2 && (addr1 + length1) > addr2) return 1;
  if(addr1 > addr2 && addr1 < (addr2 + length2)) return 1;
  return 0;
}*/
int vasIntersect(uint addr1, int length1, uint addr2, int length2) {
    // Early return if either length is non-positive
    if (length1 <= 0 || length2 <= 0) return 0;
    // No intersection if addr1's end is before addr2's start, or addr2's end is before addr1's start
    if (addr1 + length1 <= addr2 || addr2 + length2 <= addr1) {
        return 0;
    }
    // Otherwise, ranges intersect
    return 1;
}

extern int DEBUG;

int updateWmap(struct proc *p, uint addr, int length, int n_loaded_page,
			   int file_backed, int fd, int total_mmaps, int index){
  if(index < 0) return -1;
  if(index >= MAX_WMMAP_INFO) return -1;

  ((p->wmapInfo).addr)[index] = addr;
  ((p->wmapInfo).length)[index] = length;
  ((p->wmapInfo).n_loaded_pages)[index] = n_loaded_page;
  (p->wmapInfo).total_mmaps = total_mmaps;
  ((p->wmapInfoExtra).file_backed)[index] = file_backed;
  ((p->wmapInfoExtra).fd)[index] = fd;

  return 0;
}

void printWmap(struct proc *p){
  for(int i=0; i<MAX_WMMAP_INFO; i++){
	cprintf("For index %d\n", i);
	cprintf("Addr is %d, length is %d, n_loaded_pages is %d, total mmap is %d, file_backed: %d, fd: %d\n", ((p->wmapInfo).addr)[i],
	((p->wmapInfo).length)[i], ((p->wmapInfo).n_loaded_pages)[i], (p->wmapInfo).total_mmaps, ((p->wmapInfoExtra).file_backed)[i],
	((p->wmapInfoExtra).fd)[i]);
  }
}

// duplicate file descriptor
// Duplicate the file descriptor
int
duplicateFd(int fd)
{
  struct proc *curproc = myproc();
  struct file *f;
  int newfd;
  
  // Validate the original fd
  if(fd < 0 || fd >= NOFILE || (f = curproc->ofile[fd]) == 0)
    return -1;
    
  // Find the lowest-numbered free fd
  for(newfd = 0; newfd < NOFILE; newfd++){
    if(curproc->ofile[newfd] == 0){
      // Found free fd slot - use filedup to increment ref count
      curproc->ofile[newfd] = f;
      filedup(f);
      return newfd;
    }
  }
  
  return -1;  // No free fd found
}

/**
This function allocate and map a physical page to the given addr with length, if valid.
If it's file backed, it read from the file into the memory with offset calculated from addr
*/
int allocateAndMap(struct proc *p, uint addr, int length, int i){
  // we assume length is PGSIZE and so PGROUNDUP should not do anything
  struct file *f;
  char *mem;
  uint a = PGROUNDDOWN(addr);
  uint endAddr = a + PGROUNDUP(length); 

  if(endAddr >= KERNBASE)  // over the range
	return -1;
 
  if(DEBUG) cprintf("AllocateAndMap: Start addr: %d, end addr :%d\n", addr, endAddr);
  for(; a < endAddr; a += PGSIZE){
    mem = kalloc();
    // we might want to free mem but let's leave this for now
	if(mem == 0){
      cprintf("MMAP out of memory\n");
	  dellocateAndUnmap(p, endAddr, a, i); // deallocate
      return FAILED;
	}

	// set memory allocated to all 0s
    memset(mem, 0, PGSIZE);
	if(DEBUG) cprintf("Mapping memory for addrss :%d \n", a);
	// now we check if this mapping is file_backed
	if(((p->wmapInfoExtra).file_backed)[i]){
	  int offset = (a - ((p->wmapInfo).addr)[i]);
	  f = myproc()->ofile[((p->wmapInfoExtra).fd)[i]];
	  if(f == 0){
		if(DEBUG) cprintf("AllocateAndMap: File from descriptor is null\n");
		return FAILED;
	  }
	  // Obtain inode and use offset
	  ilock(f->ip);
	  if(readi(f->ip, mem, offset, PGSIZE) == 0) return FAILED;
	  iunlock(f->ip);
	}

    if(mappages(p->pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W | PTE_U | PTE_P) < 0){
	  cprintf("MMAP out of memory (2)\n");
      kfree(mem);
	  dellocateAndUnmap(p, endAddr, a, i); // deallocate
	  return FAILED;
    }

	if(updateWmap(p, ((p->wmapInfo).addr)[i], ((p->wmapInfo).length)[i], ((p->wmapInfo).n_loaded_pages)[i]+1,
				  ((p->wmapInfoExtra).file_backed)[i], ((p->wmapInfoExtra).fd)[i], (p->wmapInfo).total_mmaps, i) != 0)
	  return FAILED;
  }

  return SUCCESS;
}

/**
This function dellocate physical page for a process mapping and remove it. If MAP_SHARED is set, it writes the content back to file.
*/
 int dellocateAndUnmap(struct proc *p, uint addr, int length, int i){
   // if there's loaded page, else skip the actual freeing physical page
  if(((p->wmapInfo).n_loaded_pages)[i] > 0){
    pte_t *pte;
    uint a, pa;
	struct file *f;

    a = addr;  // No PGROUNDUP is used because we assume addr is page-aligned and at a starting address of a mapping
    for(; a < addr+length ; a += PGSIZE){
	  pte = walkpgdir(p->pgdir, (char*)a, 0);
      if(!pte)
		a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
      else if((*pte & PTE_P) != 0){
        pa = PTE_ADDR(*pte);
        if(pa == 0)
          panic("kfree");
        char *v = P2V(pa);

		// write to file if it's file_backed
		if(((p->wmapInfoExtra).file_backed)[i]){
		  f = p->ofile[((p->wmapInfoExtra).fd)[i]];	
		  if(f == 0) return FAILED;
		  int offset = (a - ((p->wmapInfo).addr)[i]);
		  // write a page
		  f->off = offset;
		  if(filewrite(f, v, PGSIZE) < 0) return FAILED;
		}

        kfree(v);
        *pte = 0;
      }
    }
  }
 
   // done removing pages and so we update the wmap
   if(updateWmap(p, 0, -1, 0, 0, -1, (p->wmapInfo).total_mmaps-1, i) != 0)
     return FAILED;
 
   // no error
   return SUCCESS;
 }


int
copyWmap(struct proc *parent, struct proc *child)
{ 
   // no parent or no child
   if(parent == 0 || child == 0) return 0;
   
   // all variables we need
   uint addr;
   int length;
   
   // go through the wmap mappings and copy over
   for(int i=0; i < MAX_WMMAP_INFO; i++){
     addr = ((parent->wmapInfo).addr)[i];
     length = ((parent->wmapInfo).length)[i];
     // skip if empty
     if(addr == 0 && length == -1) continue;
     // copy if it exists
     pte_t *pte; 
     uint a, pa, perm;
     a = addr;
     
	// loop through the address with the length and copy over the physical page
     for(; a < (addr+PGROUNDUP(length)); a += PGSIZE){
       pte = walkpgdir(parent->pgdir, (char*)a, 0);
       if(!pte) continue;
       else if((*pte & PTE_P) != 0){
         pa = PTE_ADDR(*pte);
         if(pa == 0) panic("copyWmap: kfree");
         perm = PTE_FLAGS(*pte);
         if(mappages(child->pgdir, (char*)a, PGSIZE, pa, perm) < 0){
           cprintf("COPYWMAP: Failed!\n");
           return FAILED;
         }
       }
     }
     // update child mapping details
     if(updateWmap(child, addr, ((parent->wmapInfo).length)[i], ((parent->wmapInfo).n_loaded_pages)[i], ((parent->wmapInfoExtra).file_backed)[i],
                     ((parent->wmapInfoExtra).fd)[i], (parent->wmapInfo).total_mmaps, i) != 0){
       return -1;
     }
   }
   return 0;
 }


// COPY ON WRITE
void
set_count(uint pa, unsigned char count)
{
  uint index = PPN(pa);
  acquire(&cow_lock);
  cow_ref_counts[index] = count;
  release(&cow_lock);
}

void
inc_count(uint pa)
{
  uint index = PPN(pa);
  acquire(&cow_lock);
  if(cow_ref_counts[index] < 255)
    cow_ref_counts[index]++;
  release(&cow_lock);
}

void
dec_count(uint pa)
{
  uint index = PPN(pa);
  acquire(&cow_lock);
  if(cow_ref_counts[index] > 0)
	cow_ref_counts[index]--;
  release(&cow_lock);
  return;
}

unsigned char
get_count(uint pa)
{
  acquire(&cow_lock);
  uint index = PPN(pa);
  release(&cow_lock);
  return cow_ref_counts[index];
}
   
int
handle_cow_fault(struct proc *p, uint fault_addr)
{
  pte_t *pte;
  uint va = PGROUNDDOWN(fault_addr);
  if(DEBUG) cprintf("[COW_DEBUG] Fault address: 0x%x, Page-aligned: 0x%x\n", fault_addr, va);
  if(DEBUG) cprintf("[COW_DEBUG] Process size: 0x%x\n", p->sz);

  if(fault_addr >= p->sz){
	if(DEBUG) cprintf("[COW_DEBUG] FAIL: Fault address beyond process size\n");
	return -1;
  }
 
  if((pte = walkpgdir(p->pgdir, (char*)va, 0)) == 0){
	if(DEBUG) cprintf("[COW_DEBUG] FAIL: Could not find PTE for address\n");
    return -1;
  }
  
  if(DEBUG) cprintf("[COW_DEBUG] PTE contents: 0x%x\n", *pte);
  if(DEBUG) cprintf("[COW_DEBUG] PTE flags: Present=%d, User=%d, Writable=%d, COW=%d\n", 
          (*pte & PTE_P) ? 1 : 0,
          (*pte & PTE_U) ? 1 : 0,
          (*pte & PTE_W) ? 1 : 0,
          (*pte & PTE_COW) ? 1 : 0);

  if((*pte & PTE_P) == 0 || (*pte & PTE_U) == 0){
	if(DEBUG) cprintf("[COW_DEBUG] FAIL: Page not present or not user-accessible\n");
    return -1;
  }
    
  // Check if this is actually a COW page
  if((*pte & PTE_COW) == 0){
	if(DEBUG) cprintf("[COW_DEBUG] FAIL: Not a COW page (PTE=0x%x)\n", *pte);
    return -1;
  }
    
  uint pa = PTE_ADDR(*pte);
  if(DEBUG) cprintf("[COW_DEBUG] Physical address: 0x%x\n", pa);
  unsigned char ref_count = get_count(pa);
  if(DEBUG) cprintf("[COW_DEBUG] Reference count for page: %d\n", ref_count);

  if(ref_count < 1){
	if(DEBUG) cprintf("[COW_DEBUG] FAIL: Invalid reference count of 0\n");
	return -1;
  } 
 
  // If reference count is 1, just make it writable
  if(ref_count == 1) {
	if(DEBUG) cprintf("[COW_DEBUG] Single reference, converting to writable\n");
    *pte |= PTE_W;
    *pte &= ~PTE_COW;
    lcr3(V2P(p->pgdir));  // Flush TLB
    return 0;
  }
  
  if(DEBUG) cprintf("[COW_DEBUG] Multiple references (%d), creating new page\n", ref_count);
  // Otherwise, need to allocate new page and copy
  char *mem = kalloc();
  if(mem == 0){
	if(DEBUG) cprintf("MEM IS ZERO!\n");
	return -1;
  }

  memmove(mem, (char*)P2V(pa), PGSIZE);
  dec_count(pa);
  // Map the new page with write permission
  uint flags = (PTE_FLAGS(*pte) | PTE_W) & ~PTE_COW;
  *pte = 0; // unmap

  if(mappages(p->pgdir, (char*)PGROUNDDOWN(va), PGSIZE, V2P(mem), flags) != 0) {
    kfree(mem);
    return -1;
  }
  
  // Set reference count of new page to 1
  set_count(V2P(mem), 1);
  // Flush TLB
  lcr3(V2P(p->pgdir));
  
  return 0;
}
 
/**
Actual syscall functions are below
*/

uint
wmap(uint addr, int length, int flags, int fd)
{
  /*
	This function has several assumptions:
	1. MAP_SHARED is always set to true, always write back
	2. MAP_FIXED is always set to true, always only find virtual address EXACTLY AT addr
  */

  int fileBacked = 1;
  if(flags & MAP_ANONYMOUS) fileBacked = 0; // ignore fd
  if(DEBUG) cprintf("WMAP: fbacked: %d\n", fileBacked);
  // now we retrive our process and check if the process have already used the virtual address range
  struct proc *p = myproc();
  int emptySpot = -1;

  // duplicate fd
  int fdToStore = -1;
  if(fd >= 0) fdToStore = duplicateFd(fd);
  // loop through the process wmap to check if the given addr and length are valid
  // loop through the process wmap to check if the given addr and length are valid
  for(int i = 0; i < MAX_WMMAP_INFO; i++){
	// check if it is full
    if((p->wmapInfo).total_mmaps == MAX_WMMAP_INFO) return FAILED; // null pointer

    // continue if not allocated
    if(((p->wmapInfo).addr)[i] == 0 && ((p->wmapInfo).length)[i] == -1){
	  if(emptySpot == -1) emptySpot = i;
	  continue;
    }

	// check if given address is free
    if(vasIntersect(addr, length, ((p->wmapInfo).addr)[i], ((p->wmapInfo).length)[i])){
	  return FAILED;
	}
  }

  if(emptySpot == -1) return FAILED; // no empty spot found
  // update the wmap information
  if(updateWmap(p, addr, length, 0, fileBacked, fdToStore, (p->wmapInfo).total_mmaps+1, emptySpot) != 0) return FAILED;

  return addr;
}

int
wunmap(uint addr)
{
/*
This function removes mapping from the process if it exists
*/

  struct proc *p = myproc();

  // if nothing is mapped then we are done
  if((p->wmapInfo).total_mmaps == 0) return SUCCESS;  

  for(int i = 0; i < MAX_WMMAP_INFO; i++){
    // continue if not allocated
    if(((p->wmapInfo).addr)[i] == 0 && ((p->wmapInfo).length)[i] == -1){
	  continue;
    }
 
    // check if given address is free
	if(((p->wmapInfo).addr)[i] == addr){
	  if(dellocateAndUnmap(p, addr, ((p->wmapInfo).length)[i], i) != 0){
		if(DEBUG) cprintf("Failed because dellocateAndUnmap failed!\n");
		return FAILED;
	  }
	  return SUCCESS;
	}
  }

  return FAILED;
}

uint
va2pa(uint va)
{
  pte_t *pte;
  uint pa;

  struct proc *p = myproc();

  pte = walkpgdir(p->pgdir, (char*)va, 0);
  if(!pte)  // no pte exist
    return FAILED;
  else if((*pte & PTE_P) != 0){
    pa = PTE_ADDR(*pte);
    if(pa == 0)
      panic("kfree");
	return (pa | (va & (PGSIZE-1)));  // concat PFN and Offset
  }
  
  return FAILED;
}

int
getwmapinfo(struct wmapinfo *wminfo)
{
  struct proc *p = myproc();

  (wminfo->total_mmaps) = ((p->wmapInfo).total_mmaps);

  for(int i=0; i<MAX_WMMAP_INFO; i++){
	(wminfo->addr)[i] = ((p->wmapInfo).addr)[i];
	(wminfo->length)[i] = ((p->wmapInfo).length)[i];
	(wminfo->n_loaded_pages)[i] = ((p->wmapInfo).n_loaded_pages)[i];
  }

  return SUCCESS;
}




