//
//  ChessBoard.m
//  chess
//
//  Created by Andrew Wang on 7/15/13.
//  Copyright (c) 2013 Andrew Wang. All rights reserved.
//

#import "ChessBoard.h"
#import "util.h"
#import "Piece.h"

@implementation ChessBoard

-(id)init
{
    if (self=[super init]) {
        // init chess pieces
        board[0][0] = [[Piece alloc] initWithType:PieceTypeRook side:SideWhite];
        board[1][0] = [[Piece alloc] initWithType:PieceTypeKnight side:SideWhite];
        board[2][0] = [[Piece alloc] initWithType:PieceTypeBishop side:SideWhite];
        board[3][0] = [[Piece alloc] initWithType:PieceTypeQueen side:SideWhite];
        board[4][0] = [[Piece alloc] initWithType:PieceTypeKing side:SideWhite];
        board[5][0] = [[Piece alloc] initWithType:PieceTypeBishop side:SideWhite];
        board[6][0] = [[Piece alloc] initWithType:PieceTypeKnight side:SideWhite];
        board[7][0] = [[Piece alloc] initWithType:PieceTypeRook side:SideWhite];
        
        for (int x = 0; x < 8; x++) {
            board[x][1] = [[Piece alloc] initWithType:PieceTypePawn side:SideWhite];
            board[x][6] = [[Piece alloc] initWithType:PieceTypePawn side:SideBlack];
            board[x][7] = [[Piece alloc] initWithType:board[x][0].type side:SideBlack];
        }
    }
    return self;
}

-(Piece *)pieceAtPos:(Pos)pos
{
    int x = pos.x, y = pos.y;
    if (x < 0 || y < 0 || x > 7 || y > 7) return nil;
    return board[x][y];
}

@end
