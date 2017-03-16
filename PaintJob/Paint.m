//
//  Paint.m
//  PaintJob
//
//  Created by Kyra McKenna on 15/03/2017.
//  Copyright © 2017 Kyra McKenna. All rights reserved.
//

#import "Paint.h"

@implementation Paint

-(id)init:(int)colour finish:(NSString*)finish
{
    self = [super init];
    
    if(self)
    {
        self.colour = colour;
        self.finish = finish;
    }
    return self;
}

@end
