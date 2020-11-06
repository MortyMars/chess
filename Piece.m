//
//  Piece.m
//  chess
//
//  Created by Andrew Wang on 15/07/2013.
//  Copyright (c) 2013 Andrew Wang. All rights reserved.
//

#import "Piece.h"     // déclaration de la classe (interface) Pièce

@implementation Piece // définition (implémentation) de cette classe

    -(id)initWithType:(PieceType)type
                 side:(Side)side
    {
        if (self = [super init]) {
            _type = type;
            _side = side;
        }
        return self;
    }

    -(id)copyWithZone:(NSZone *)zone
    {
        Piece *newPiece = [[Piece allocWithZone:zone] initWithType:self.type
                                                              side:self.side];
        newPiece.numMoves = self.numMoves;
        return newPiece;
    }

@end
