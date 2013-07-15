//
//  ChessBoard.h
//  chess
//
//  Created by Andrew Wang on 7/15/13.
//  Copyright (c) 2013 Andrew Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "util.h"

@class Piece;
@interface ChessBoard : NSObject
{
    Piece *board[8][8];
}

-(Piece *)pieceAtPos:(Pos)pos;

@end
