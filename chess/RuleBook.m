//
//  RuleBook.m
//  chess
//
//  Created by Andrew Wang on 7/15/13.
//  Copyright (c) 2013 Andrew Wang. All rights reserved.
//

#import "RuleBook.h"
#import "Piece.h"
#import "ChessBoard.h"
#import "util.h"

@implementation RuleBook

+(NSSet *)coverageForPiece:(Piece *)piece inBoard:(ChessBoard *)board
{
    NSMutableSet *coverage = [[NSMutableSet alloc] init];
    
    return coverage;
}

@end
