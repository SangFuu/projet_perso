#include <ctype.h>
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "mycode.h"

/* 1 = choix valide, 0 = saisie invalide, -1 = fin de saisie. */
static int LireChoix(int *choix)
{
    char ligne[128];
    char *fin;
    long valeur;
    int caractere;

    if (fgets(ligne, sizeof ligne, stdin) == NULL) {
        return -1;
    }
    if (strchr(ligne, '\n') == NULL && !feof(stdin)) {
        while ((caractere = getchar()) != '\n' && caractere != EOF) {
            /* Consommer la fin d'une ligne trop longue. */
        }
        return 0;
    }

    errno = 0;
    valeur = strtol(ligne, &fin, 10);
    if (fin == ligne || errno == ERANGE || valeur < 0 || valeur > 100) {
        return 0;
    }
    while (isspace((unsigned char)*fin)) {
        fin++;
    }
    if (*fin != '\0') {
        return 0;
    }
    *choix = (int)valeur;
    return 1;
}

void Jeu_Pendu_Version_Simple(void)
{
    const int chiffreChoisis = rand() % 101;
    int vies = 5;
    int choix;
    int resultat;

    printf("Devinez le nombre entre 0 et 100. Vous avez 5 vies.\n");
    while (vies > 0) {
        printf("Quel est votre choix ? ");
        fflush(stdout);
        resultat = LireChoix(&choix);
        if (resultat == -1) {
            printf("\nPartie interrompue : fin de saisie.\n");
            return;
        }
        if (resultat == 0) {
            printf("Entrez un entier entre 0 et 100. Aucune vie perdue.\n");
            continue;
        }
        if (choix == chiffreChoisis) {
            printf("Vous avez gagne et il vous reste : %d vies\n", vies);
            printf("Le chiffre etait : %d\n", chiffreChoisis);
            return;
        }
        vies--;
        if (vies > 0) {
            printf("C'est %s !\n", choix < chiffreChoisis ? "+" : "-");
            printf("Il vous reste : %d vies\n", vies);
        }
    }
    printf("Vous avez perdu et il vous reste : 0 vie\n");
    printf("Le chiffre etait : %d\n", chiffreChoisis);
}
