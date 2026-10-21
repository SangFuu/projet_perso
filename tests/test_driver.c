#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "mycode.h"

int main(int argc, char **argv)
{
    srand(1);
    if (argc == 2 && strcmp(argv[1], "--secret") == 0) {
        printf("%d\n", rand() % 101);
        return 0;
    }
    Jeu_Pendu_Version_Simple();
    return 0;
}
