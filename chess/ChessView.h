//
//  ChessView.h
//  chess
//
//  Created by Andrew Wang on 7/15/13.
//  Copyright (c) 2013 Andrew Wang. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ChessBoard;
@interface ChessView : NSView
{
    ChessBoard *board;
}
@end
