struct proc;

enum map_flag { MAP_ANONYMOUS, MAP_SHARED, MAP_FIXED };

// Flags for wmap
#define MAP_SHARED 0x0002
#define MAP_ANONYMOUS 0x0004
#define MAP_FIXED 0x0008

// When any system call fails, returns -1
#define FAILED -1
#define SUCCESS 0

// for `getwmapinfo`
#define MAX_WMMAP_INFO 16
struct wmapinfo {
    int total_mmaps;                    // Total number of wmap regions
    int addr[MAX_WMMAP_INFO];           // Starting address of mapping
    int length[MAX_WMMAP_INFO];         // Size of mapping
    int n_loaded_pages[MAX_WMMAP_INFO]; // Number of pages physically loaded into memory
};

// custom struct to keep track of stuff
struct wmapinfoExtra{
	int file_backed[MAX_WMMAP_INFO];
	int fd[MAX_WMMAP_INFO];
};

// helper functions
int vasIntersect(uint addr1, int length1, uint addr2, int length2);
int updateWmap(struct proc *p, uint addr, int length, int n_loaded_page, int file_backed, int fd, int total_mmaps, int index);
int dellocateAndUnmap(struct proc *p, uint addr, int length, int i);
void printWmap(struct proc *p);
int duplicateFd(int fd);
int allocateAndMap(struct proc *p, uint addr, int length, int i);
int copyWmap(struct proc *parent, struct proc *child);
int duplicatePage(struct proc *p, uint addr, int length, int i); 
void init_cow();
void inc_count(uint pa);
void dec_count(uint pa);
void set_count(uint pa, unsigned char count);
unsigned char get_count(uint pa);
int handle_cow_fault(struct proc *p, uint fault_addr);
uint wmap(uint addr, int length, int flags, int fd);
int wunmap(uint addr);
uint va2pa(uint va);
int getwmapinfo(struct wmapinfo *wminfo);
