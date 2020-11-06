//
//  Minimax.h
//  chess
//
//  Created by Andrew Wang on 15/07/2013.
//  Copyright (c) 2013 Andrew Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "util.h" // car appel à l'énum Side

@class Move, ChessBoard; // compte tenu de l'appel de ces 2 classes dans la classe Minimax

@interface Minimax : NSObject

    // Création d'un nouvel outlet pointant vers le Champ Texte de l'interface
    @property (weak) IBOutlet NSTextField *miniSortieTexte;
    -(IBAction)TestAction:(NSTextFieldCell *)sender;


    // Création d'une méthode d'instance pour éditer le Champ Texte de l'UI
    -(void)editeMiniSortieTexte:(NSString *)strMiniSortieTexte;

    // Méthode de classe à 2 paramètres du meilleur coup pour les blancs /les noirs
    +(Move *)bestMoveForSide:(Side)side             // côté blanc ou côté noir
                       board:(ChessBoard *)board;   // et selon la configuration de l'échiquier courant

@end
