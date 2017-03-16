//
//  Customer.h
//  PaintJob
//
//  Created by Kyra McKenna on 15/03/2017.
//  Copyright © 2017 Kyra McKenna. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Paint.h"

@interface Customer : NSObject

@property (nonatomic, readwrite) NSMutableArray<Paint*> *paintChoice;
@property (nonatomic, readwrite) int choiceCount;

-(void)addPaintChoice:(Paint *)paint;

@end
