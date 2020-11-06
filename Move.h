//
//  Move.h
//  chess
//
//  Created by Andrew Wang on 15/07/2013.
//  Copyright (c) 2013 Andrew Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Piece,Pos;   // @class sert uniquement à indiquer au compilateur que les classes "Piece" et "Pos"
                    // existent et sont déclarées par ailleurs, ce qui permet d'éviter des #import
                    // bouclant sur eux-mêmes, en particulier dans le cas d'une classe en appelant une autre,
                    // comme ici Move qui utilise Pos
                    // NB : le rappel que Piece existe ne parait d'ailleurs pas pertinent ici...

// Déclaration de la Classe Move avec l'opérateur dédié en objective-c : @interface...
@interface Move : NSObject <NSCopying>

    // ...comprenant 2 variables, start et dest...
    @property (nonatomic, strong) Pos *start;
    @property (nonatomic, strong) Pos *dest;


    // ...et une méthode initWithStart
    -(id)initWithStart:(Pos *)start dest:(Pos *)dest;

@end
