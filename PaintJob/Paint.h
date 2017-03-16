//
//  Paint.h
//  PaintJob
//
//  Created by Kyra McKenna on 15/03/2017.
//  Copyright © 2017 Kyra McKenna. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Paint : NSObject

-(id)init:(int)colour finish:(NSString*)finish;

@property (nonatomic, readwrite) int colour;
@property (nonatomic, readwrite) NSString *finish;

@end
