//
//  ChessView.m
//  chess
//
//  Created by Andrew Wang on 7/15/13.
//  Copyright (c) 2013 Andrew Wang. All rights reserved.
//

#import "ChessView.h"
#import "ChessBoard.h"
#import "Piece.h"
#import "util.h"

@implementation ChessView

-(id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        board = [[ChessBoard alloc] init];
    }
    
    return self;
}

-(void)drawBoard
{
    float tileWidth = self.bounds.size.width / 8;
    float tileHeight = self.bounds.size.height / 8;
    
    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
    
    NSImage *piecesImage = [NSImage imageNamed:@"pieces.png"];
    for (int x = 0; x < 8; x++) {
        for (int y = 0; y < 8; y++) {
            CGRect destRect = CGRectMake(x * tileWidth, y * tileHeight, tileWidth, tileHeight);
            
            // color each tile as a checkerboard
            if ((x + y) % 2 == 1) {
                CGContextSetRGBFillColor(context, 255, 255, 255, 255);
            } else {
                CGContextSetRGBFillColor(context, 0, 0, 100, 255);
            }
            CGContextFillRect(context, destRect);
            
            Piece *piece = [board pieceAtPos:makePos(x, y)];
            Side side = piece.side;
            
            if (piece) {    // if piece exists at this point
                int index = 0;
                switch (piece.type) {
                    case PieceTypeInvalid:
                    case PieceTypeNone:
                        break;
                    case PieceTypeQueen: index = 0; break;
                    case PieceTypeKing: index = 1; break;
                    case PieceTypeRook: index = 2; break;
                    case PieceTypePawn: index = 3; break;
                    case PieceTypeBishop: index = 4; break;
                    case PieceTypeKnight: index = 5; break;
                    default: break;
                }
                CGRect sourceRect = CGRectMake(index * 60, (side == SideBlack) ? 0 : 60, 60, 60);
                [piecesImage drawInRect:destRect fromRect:sourceRect operation:NSCompositeSourceOver fraction:1];
            }
        }
    }
}

-(void)drawRect:(NSRect)dirtyRect
{
    [[NSGraphicsContext currentContext] setImageInterpolation:NSImageInterpolationNone];
    [self drawBoard];
}

@end
