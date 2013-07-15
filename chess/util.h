//
//  util.h
//  chess
//
//  Created by Andrew Wang on 7/15/13.
//  Copyright (c) 2013 Andrew Wang. All rights reserved.
//

#ifndef chess_util_h
#define chess_util_h

typedef enum {
    PieceTypeInvalid, PieceTypeNone, PieceTypePawn, PieceTypeKnight, PieceTypeBishop, PieceTypeRook, PieceTypeQueen, PieceTypeKing
} PieceType;

typedef enum {
    SideInvalid, SideBlack, SideWhite
} Side;

typedef struct {
    int x, y;
} Pos;

static inline Pos makePos (int x, int y) {
    Pos pos;
    pos.x = x;
    pos.y = y;
    return pos;
}

#endif
