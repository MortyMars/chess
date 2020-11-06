//
//  Pos.h
//  chess
//
//  Created by Andrew Wang on 15/07/2013.
//  Copyright (c) 2013 Andrew Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Pos : NSObject <NSCopying>

    @property (nonatomic, readonly) int x;
    @property (nonatomic, readonly) int y;

    +(Pos *)posWithX:(int)x
                   y:(int)y;

@end
