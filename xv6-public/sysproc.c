#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return myproc()->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

// task 1 implementation
extern int DEBUG;

int
sys_wmap(void)
{
  uint addr;
  int length;
  int flags;
  int fd;

  if(argint(0, (int *) &addr) < 0) return FAILED;
  if(argint(1, &length) < 0) return FAILED;
  if(argint(2, &flags) < 0) return FAILED;
  if(argint(3, &fd) < 0) return FAILED;

  if(DEBUG) cprintf("Made it before first checks\n");

  // checks
  if(addr < 0x60000000 || addr+length > 0x80000000) return FAILED;
  if((flags & MAP_FIXED) == 0) return FAILED; // MAP_FIXED not set, error
  if((flags & MAP_SHARED) == 0) return FAILED; // MAP_SHARE not set, error
  // if addr is not multiple of page size
  if(addr % PGSIZE != 0){
	return FAILED;
  }

  // if length is not greater than 0
  if (length <= 0) {
	return FAILED;
  }

  if(DEBUG) cprintf("Made it after first checks\n");
  return wmap(addr, length, flags, fd);
}

int
sys_wunmap(void)
{
  uint addr;

  if(argint(0, (int *) &addr) < 0) return FAILED;

  // checks
  if(addr < 0x60000000 || addr > 0x80000000) return FAILED;
  if(DEBUG) cprintf("SYS_WUNMAP: Got pass all the checks!\n");

  return wunmap(addr);
}

int
sys_va2pa(void)
{
  uint va;

  if(argint(0, (int *) &va) < 0) return -1;
  if(DEBUG) cprintf("SYS_VA2PA: Made it after argint and proceed va2pa call.\n");

  return va2pa(va);
}

int
sys_getwmapinfo(void)
{
  struct wmapinfo *wminfo;

  if(argptr(0, (void *)&wminfo, sizeof(struct wmapinfo)) < 0) return FAILED;
  if(wminfo == 0) return FAILED;

  return getwmapinfo(wminfo);
}
