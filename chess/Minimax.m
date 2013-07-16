//
//  Minimax.m
//  chess
//
//  Created by Andrew Wang on 7/15/13.
//  Copyright (c) 2013 Andrew Wang. All rights reserved.
//

#import "Minimax.h"
#import "ChessBoard.h"
#import "Piece.h"
#import "Move.h"
#import "Pos.h"
#import "RuleBook.h"

@implementation Minimax

+(Move *)bestMoveForSide:(Side)side board:(ChessBoard *)board
{
    int bestScore = -INFINITY;
    Move *bestMove = nil;
    
    for (Move *move in [self possibleMovesForSide:side board:board]) {
        int score = [self minimaxForMove:move side:side board:board depth:3];
        if (score > bestScore) {
            bestScore = score;
            bestMove = move;
        }
    }
    
    return bestMove;
}

+(int)minimaxForMove:(Move *)move side:(Side)side board:(ChessBoard *)board depth:(int)depth
{
    if (depth <= 0) {
        return [self scoreForMove:move side:side board:board];
    } else {
        ChessBoard *newBoard = board.copy;
        [newBoard performMove:move];
        
        int bestScore = -INFINITY;
        Side otherSide = (side == SideWhite) ? SideBlack : SideWhite;
        for (Move *newMove in [self possibleMovesForSide:otherSide board:newBoard]) {
            bestScore = MAX(bestScore, -[self minimaxForMove:newMove side:otherSide board:newBoard depth:depth - 1]);
        }
        return bestScore;
    }
}

+(int)scoreForMove:(Move *)move side:(Side)side board:(ChessBoard *)board
{
    int score = 0;
    
    Piece *capturedPiece = [board pieceAtPos:move.dest];
    if (capturedPiece) {
        int value = 0;
        switch (capturedPiece.type) {
            case PieceTypeInvalid: break;
            case PieceTypeBishop: case PieceTypeKnight: value = 300; break;
            case PieceTypeRook: value = 500; break;
            case PieceTypeQueen: value = 900; break;
            case PieceTypePawn: value = 100; break;
            case PieceTypeKing: value = 100000; break;
        }
        score += value;
    }
    
    return score;
}

+(NSSet *)possibleMovesForSide:(Side)side board:(ChessBoard *)board
{
    NSMutableSet *moves = [[NSMutableSet alloc] init];
    for (int x = 0; x < 8; x++) {
        for (int y = 0; y < 8; y++) {
            Pos *pos = [Pos posWithX:x y:y];
            Piece *piece = [board pieceAtPos:pos];
            if (piece.side == side) {
                NSSet *coverage = [RuleBook coverageForPiece:piece atPos:pos inBoard:board];
                for (Pos *possibleDest in coverage) {
                    Move *move = [[Move alloc] initWithStart:pos dest:possibleDest];
                    [moves addObject:move];
                }
            }
        }
    }
    return moves;
}
@end
