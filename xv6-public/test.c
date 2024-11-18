#include "types.h"
#include "stat.h"
#include "user.h"
#include "fs.h"

char *str = "You can't change a character!";
int main() {
    str[1] = 'O';
    printf(1, "%s\n", str);
    return 0;
}

