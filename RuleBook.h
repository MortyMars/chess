//
//  RuleBook.h
//  chess
//
//  Created by Andrew Wang on 15/07/2013.
//  Copyright (c) 2013 Andrew Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "util.h"

@class Piece,ChessBoard,Pos;
@interface RuleBook : NSObject
    +(NSSet *)PosAccepteesForPiece:(Piece *)piece
                             atPos:(Pos *)pos
                           inBoard:(ChessBoard *)board;
@end
