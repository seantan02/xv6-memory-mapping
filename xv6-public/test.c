#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"
#include "wmap.h"

#define PGSIZE 4096  // Assuming page size is 4096 bytes
#define FILENAME "testfile.txt"

int
main(void)
{
    char *addr;
    char *file_addr;
    int pid;
    int fd;

    // Step 1: Create a writable memory region in the parent
    addr = (char*)wmap(0x60000000, PGSIZE, MAP_FIXED | MAP_SHARED | MAP_ANONYMOUS, -1);  // -1 for no file (regular mapping)
    if (addr == (char*)-1) {
        printf(1, "wmap failed for regular memory\n");
        exit();
    }
    strcpy(addr, "111");  // Write "111" into the allocated memory

    // Verify the content in parent for regular memory mapping
    printf(1, "Parent content (regular mapping): %s\n", addr);

    // Step 2: Create a file-backed memory region
    fd = open(FILENAME, O_CREATE | O_RDWR);
    if (fd < 0) {
        printf(1, "Failed to create file\n");
        exit();
    }

    // Write initial content "file_data" to the file
    if (write(fd, "file_data", 9) != 9) {
        printf(1, "Failed to write to file\n");
        close(fd);
        exit();
    }
    close(fd);

    // Open the file again to map it
    fd = open(FILENAME, O_RDWR);
    if (fd < 0) {
        printf(1, "Failed to open file\n");
        exit();
    }

    // Map the file into memory with wmap
    file_addr = (char*)wmap(0x60002000, PGSIZE, MAP_FIXED | MAP_SHARED, fd);
    if (file_addr == (char*)-1) {
        printf(1, "File-backed wmap failed\n");
        close(fd);
        exit();
    }

    // Verify the content in parent for file-backed mapping
    printf(1, "Parent content (file-backed mapping): %s\n", file_addr);

    // Step 3: Fork to create a child process
    pid = fork();
    if (pid < 0) {
        printf(1, "Fork failed\n");
        exit();
    } else if (pid == 0) {
        // This is the child process

        // Check if the child sees "111" in the regular memory region
        if (strcmp(addr, "111") == 0) {
            printf(1, "Child sees the correct content in regular mapping: %s\n", addr);
        } else {
            printf(1, "Child content mismatch in regular mapping: expected '111', got '%s'\n", addr);
        }

        // Check if the child sees "file_data" in the file-backed memory region
        if (strcmp(file_addr, "file_data") == 0) {
            printf(1, "Child sees the correct content in file-backed mapping: %s\n", file_addr);
        } else {
            printf(1, "Child content mismatch in file-backed mapping: expected 'file_data', got '%s'\n", file_addr);
        }

        // Unmap the file-backed memory region and close the file in the child
        wunmap((uint)file_addr);
        close(fd);

        exit();
    } else {
        // This is the parent process, waiting for the child to finish
        wait();

        // Cleanup: Unmap and delete the file-backed memory region
        wunmap((uint)file_addr);
        close(fd);
        unlink(FILENAME);  // Clean up the test file
    }

    exit();
}

