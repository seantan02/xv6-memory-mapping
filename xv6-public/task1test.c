#include "types.h"
#include "user.h"
#include "wmap.h"

int main() {
    int length = 4096; // Map one page of memory
    uint addr;
    
    // 1. Anonymous mapping test
    printf(1, "Testing anonymous mapping...\n");
    addr = wmap(0, length, (MAP_FIXED | MAP_SHARED | MAP_ANONYMOUS), -1);
    if (addr == (uint)-1) {
        printf(1, "wmap failed\n");
        exit();
    }
    printf(1, "wmap succeeded, mapped at address: 0x%x\n", addr);

    // 2. Write data to the mapped memory
    char *mapped_memory = (char *)addr;
    strcpy(mapped_memory, "Hello, xv6!");
    printf(1, "Data written to mapped memory: %s\n", mapped_memory);

    // 3. Verify the data was written correctly
    if (strcmp(mapped_memory, "Hello, xv6!") == 0) {
        printf(1, "Data verification succeeded!\n");
    } else {
        printf(1, "Data verification failed!\n");
    }

/*    // 4. Unmap the memory
    if (wunmap(addr, length) != 0) {
        printf(1, "wunmap failed\n");
    } else {
        printf(1, "wunmap succeeded\n");
    }
*/
    exit();
}

