//
//  Customer.m
//  PaintJob
//
//  Created by Kyra McKenna on 15/03/2017.
//  Copyright © 2017 Kyra McKenna. All rights reserved.
//

#import "Customer.h"

@implementation Customer

-(id)init
{
    self = [super init];
    
    if(self)
    {
        self.paintChoice = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void) addPaintChoice:(Paint *)paint{
    [self.paintChoice addObject:paint];
    self.choiceCount = (int)[self.paintChoice count];
}


@end
