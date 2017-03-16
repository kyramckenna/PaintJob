//
//  PaintOrder.h
//  PaintJob
//
//  Created by Kyra McKenna on 15/03/2017.
//  Copyright © 2017 Kyra McKenna. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PaintOrder : NSObject

-(void)readInFile:(NSString*)fileName completion:(void (^)(NSString *fileData))completionBlock;
-(bool)parseContents:(NSArray*) contents;
-(NSString*)batchOutput;

@end
