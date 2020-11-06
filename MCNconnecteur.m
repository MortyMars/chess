//
//  MCNconnecteur.m
//  Chess
//
//  Created by Martial on 01/11/2020.
//  Copyright © 2020 Andrew Wang. All rights reserved.
//

#import "MCNconnecteur.h"
#import "util.h"


@implementation MCNconnecteur

    // MCN
    // Pour que "sortieTexte" soit accessible par d'autres objets que ceux de la classe
    // MCNconnecteur, il faut normalement créer des accesseurs (fonctions/méthodes d'accès)
    // car les propriétés sont privées par défaut.
    // Le mote clé synthesize, précédant la propriété, demande au compilateur de construire
    // ces accesseurs pour nous, ce qui nous évite de le faire manuellement...
    @synthesize SortieTexte;


    - (void)editeSortieTexte:(NSString *)texteSortie
    {
        // Sortie simple
        //SortieTexte.cell.title = texteSortie;
        
        // Sortie concaténée
        SortieTexte.cell.title = [SortieTexte.cell.title stringByAppendingString:texteSortie];
    }

    - (IBAction)refreshSortieTexte:(NSButton *)sender
    {
        // Affectation de la valeur de la var global stringCoupsPartie
        SortieTexte.cell.title = stringCoupsPartie;
    }

@end



