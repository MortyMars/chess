//
//  RuleBook.h
//  chess
//
//  Created by Andrew Wang on 7/15/13.
//  Copyright (c) 2013 Andrew Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Piece,ChessBoard;
@interface RuleBook : NSObject

+(NSSet *)coverageForPiece:(Piece *)piece inBoard:(ChessBoard *)board;
@end
