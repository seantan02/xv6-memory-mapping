#include "types.h"
#include "user.h"
#include "wmap.h"

#define PAGE_SIZE 4096

int main() {
    int length = PAGE_SIZE;  // Map one page of memory for each wmap call
    uint addr;
    uint nextMapAddr = 0;
    int i;

    // 1. Attempt to create 16 mappings
    printf(1, "Testing limit of 16 mappings...\n");
    for (i = 0; i < 16; i++) {
		printf(1, "Before  %d\n", nextMapAddr);
        addr = wmap(nextMapAddr, length, (MAP_FIXED | MAP_SHARED | MAP_ANONYMOUS), -1);
		printf(1, "After %d\n", nextMapAddr);
        if (addr == (uint)-1) {
            printf(1, "wmap call %d failed unexpectedly\n", i + 1);
            exit();
        }
        printf(1, "wmap call %d succeeded, mapped at address: 0x%x\n", i + 1, addr);
		nextMapAddr += PAGE_SIZE;
	}

    // 2. Attempt the 17th mapping, which should fail
    uint failedAddr;
    failedAddr = wmap(0, length, (MAP_FIXED | MAP_SHARED | MAP_ANONYMOUS), -1);
    if (failedAddr == (uint)-1) {
        printf(1, "17th wmap call correctly failed as expected\n");
    } else {
        printf(1, "17th wmap call unexpectedly succeeded at address: 0x%x\n", addr);
		//wunmap(addr, length); // Clean up if this unexpectedly succeeds
    }

    char *mapped_memory = (char *)addr;
    strcpy(mapped_memory, "Hello, xv6!");
    printf(1, "Data written to mapped memory: %s\n", mapped_memory);

    // Verify the data was written correctly
    if (strcmp(mapped_memory, "Hello, xv6!") == 0) {
        printf(1, "Data verification succeeded!\n");
    } else {
        printf(1, "Data verification failed!\n");
    }

    /*// 4. Unmap all mappings (only necessary if tracking and unmapping each addr)
    for (i = 0; i < 16; i++) {
        wunmap(addr + i * PAGE_SIZE, length);
    }
    printf(1, "All mappings successfully unmapped\n");
	*/

    exit();
}
