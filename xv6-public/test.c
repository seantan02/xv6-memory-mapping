#include "types.h"
#include "stat.h"
#include "user.h"
#include "fs.h"

int main() {
	 char *str = "You can't change a character!";
    str[1] = 'O';
    printf(1, "%s\n", str);
    return 0;
}

