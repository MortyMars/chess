//
//  ChessBoard.h
//  chess
//
//  Created by Andrew Wang on 15/07/2013.
//  Copyright (c) 2013 Andrew Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "util.h"

@class Piece,Pos,Move;

@interface ChessBoard : NSObject <NSCopying>
    {
        Piece *board[8][8];
    }

    @property (nonatomic, strong) Move *lastMove;


    -(void)setupPieces;

    -(Piece *)piece_colX:(int)x
                   rangY:(int)y;

    -(Piece *)pieceAtPos:(Pos *)pos;

    -(Piece *)MovePieceDela:(Pos *)start
                      Adela:(Pos *)dest;

    -(void)performMove:(Move *)move;

    // Ajout des Méthodes MCN
    -(void)defCouleurHumain;
    -(void)premCoupAIblancs;

@end
