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
        int score = [self minimaxForMove:move side:side board:board depth:3 alpha: -INFINITY beta:INFINITY];
        NSLog(@"move %@ gets score %d",move,score);
        if (score > bestScore || !bestMove) {
            NSLog(@"a good move is %@ for score %d",move,score);
            bestScore = score;
            bestMove = move;
        }
    }
    NSLog(@"best score is %d by going %@",bestScore,bestMove);
    
    return bestMove;
}

+(int)minimaxForMove:(Move *)move side:(Side)side board:(ChessBoard *)board depth:(int)depth alpha:(int)alpha beta:(int)beta
{
    //NSLog(@"depth %d\n%@\n--------",depth,newBoard);
    ChessBoard *newBoard = board.copy;
    [newBoard performMove:move];
    //NSLog(@"trying \n%@ (last move:%@) at depth %d",newBoard,move,depth);
    
    if (depth <= 0) {
        //NSLog(@"board \n%@ gets score %d for side %@",newBoard,[self scoreForSide:side board:newBoard originalSide:originalSide],(side == SideWhite)?@"white":@"black");
        return [self scoreForSide:side board:newBoard];
    } else {
        int bestScore = -INFINITY;
        Side otherSide = (side == SideWhite) ? SideBlack : SideWhite;
        for (Move *newMove in [self possibleMovesForSide:otherSide board:newBoard]) {
            //ChessBoard *testBoard = newBoard.copy;
            int score = -[self minimaxForMove:newMove side:otherSide board:newBoard depth:depth - 1 alpha:-beta beta:-alpha];
            if (score > bestScore) bestScore = score;
            if (score > alpha) alpha = score;
            if (score >= beta) return score;
        }
        return bestScore;
    }
}

+(int)scoreForSide:(Side)side board:(ChessBoard *)board
{
    int score = 0;
    
    for (int x = 0; x < 8; x++) {
        for (int y = 0; y < 8; y++) {
            Piece *piece = [board pieceAtX:x y:y];
            if (piece) {
                int value = 0;
                switch (piece.type) {
                    case PieceTypeInvalid: break;
                    case PieceTypeBishop: case PieceTypeKnight: value = 300; break;
                    case PieceTypeRook: value = 500; break;
                    case PieceTypeQueen: value = 900; break;
                    case PieceTypePawn: value = 100; break;
                    case PieceTypeKing: value = 100000; break;
                }
                score += value * ((piece.side == side) ? 1 : -1);
            }
        }
    }
    //if (score) NSLog(@"Score is %d for board\n%@ and side %d",score,board,side);
    
    return score;
}

+(NSSet *)possibleMovesForSide:(Side)side board:(ChessBoard *)board
{
    NSMutableSet *moves = [[NSMutableSet alloc] init];
    for (int x = 0; x < 8; x++) {
        for (int y = 0; y < 8; y++) {
            Pos *pos = [Pos posWithX:x y:y];
            Piece *piece = [board pieceAtX:x y:y];
            if (piece) {
                if (piece.side == side) {
                    NSSet *coverage = [RuleBook coverageForPiece:piece atPos:pos inBoard:board];
                    for (Pos *possibleDest in coverage) {
                        Move *move = [[Move alloc] initWithStart:pos dest:possibleDest];
                        [moves addObject:move];
                    }
                }
            }
        }
    }
    return moves;
}
@end
