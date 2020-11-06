//
//  Pos.m
//  chess
//
//  Created by Andrew Wang on 15/07/2013.
//  Copyright (c) 2013 Andrew Wang. All rights reserved.
//

#import "Pos.h"

@implementation Pos

    -(id)initWithX:(int)x // méthode à 2 paramètres x et y
                 y:(int)y // correspondant à la position de la pièce sur l'échiquier
    {
        if (self = [super init]) {
            _x = x;
            _y = y;
        }
        return self;
    }

    +(Pos *)posWithX:(int)x // même construction que la méthode
                   y:(int)y // initWithX:y:
    {
        return [[self alloc] initWithX:x y:y];
    }

    -(BOOL)isEqual:(id)object
    {
        if ([object class] != [self class]) return NO;
        if (self.x == ((Pos *)object).x && self.y == ((Pos *)object).y) return YES;
        return NO;
    }

    -(NSUInteger)hash
    {
        return self.y * 8 + self.x;
    }

    -(id)copyWithZone:(NSZone *)zone
    {
        Pos *pos = [[Pos allocWithZone:zone] initWithX:self.x y:self.y];
        return pos;
    }

    -(NSString *)description
    {
        return [NSString stringWithFormat:@"(%d, %d)",self.x,self.y];
    }

@end
