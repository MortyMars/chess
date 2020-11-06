//
//  MCNconnecteur.h
//  Chess
//
//  Created by Martial on 01/11/2020.
//  Copyright © 2020 Andrew Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MCNconnecteur : NSObject

    

    // MCN - Création de la liaison entre code et Champ Texte
    @property (weak) IBOutlet NSTextField *SortieTexte;

    // MCN - Création d'une action liée au bouton de l'interface
    -(IBAction)refreshSortieTexte:(NSButton *)sender;

    // MCN - Création d'une fonction d'édition de la zone de texte sortieTexte
    -(void)editeSortieTexte:(NSString *)textSortie;
    //- (void)editeSortieTexte:(NSString *)textSortie :(MCNconnecteur *)sender;

@end



NS_ASSUME_NONNULL_END
