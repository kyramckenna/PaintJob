//
//  PaintOrder.m
//  PaintJob
//
//  Created by Kyra McKenna on 15/03/2017.
//  Copyright © 2017 Kyra McKenna. All rights reserved.
//

#import "PaintOrder.h"
#import "Customer.h"
#import "Paint.h"


@interface PaintOrder ()

@property (nonatomic, readwrite) NSMutableArray<Customer*> *customers;
@property (nonatomic, readwrite) NSMutableArray<Paint*> *paintOrder;
@property (nonatomic, readwrite) int numberOfColours;

@end


@implementation PaintOrder


-(id)init
{
    self = [super init];
    
    if(self)
    {}
    return self;
}


-(NSString*)batchOutput{
    
    // Sort your customers by their number of choices so we can catch any conflicts faster
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"choiceCount" ascending:YES];
    NSArray *sortedArray = [self.customers sortedArrayUsingDescriptors:@[sortDescriptor]];
  
    for(Customer *customer in sortedArray){
        
        if([customer choiceCount] == 1){

            // If a customer has only one choice make sure it doesnt clash with another customer
            NSArray<Paint*> *paintChoices = [customer paintChoice];
            Paint *customerPaint = [paintChoices objectAtIndex:0];
            int colour       = [customerPaint colour];
            NSString *finish = [customerPaint finish];
            NSString *orderFinish = [[_paintOrder objectAtIndex:(colour-1)] finish];
            
            if([orderFinish  isEqual: @""] || [orderFinish isEqualToString:finish]){
                
                // add paint if not already there
                [_paintOrder replaceObjectAtIndex:(colour-1) withObject:customerPaint];
            }
            else if(![orderFinish isEqualToString:finish]){
                return @"No Solution Exists";
            }
                
            // Add the paint preference to the order
            [_paintOrder replaceObjectAtIndex:(colour-1) withObject:customerPaint];
            
        }else{
            
            // check if any paint choice is already in the list
            NSMutableArray *choicePaints = [self getPossiblePaintChoices:customer];
            
            if([choicePaints count] == 0){
                return @"No Solution Exists";
            }
            
            Paint *paintToSelect = [choicePaints objectAtIndex:0];
            for (Paint *paint in choicePaints) {
                NSString *finish = [paint finish];
                if ([finish isEqualToString:@"G"]) {
                    paintToSelect = paint;
                }
            }
            
            int index = [paintToSelect colour] - 1;
            [_paintOrder replaceObjectAtIndex:index withObject:paintToSelect];
        }
    }
    
    return [self printOutOrder];
}


-(NSMutableArray*) getPossiblePaintChoices:(Customer *)customer {
    
    NSMutableArray *possiblePaintChoices = [[NSMutableArray alloc]init];
    
    for(Paint *paint in [customer paintChoice]){
        int colour = [paint colour];
        NSString* finish = [paint finish];
        NSString* orderFinish = [[_paintOrder objectAtIndex:(colour-1)] finish];
    
        if ([orderFinish  isEqual: @""]) {
            // colour not in order so we add it to our possible choices
            [possiblePaintChoices addObject:paint];
        }
        else if ([orderFinish isEqualToString:finish]){
            // we found an existing choice for this customer
            [possiblePaintChoices addObject:paint];
            return possiblePaintChoices;
        }
    }

    return possiblePaintChoices;
}


-(NSString*)printOutOrder{
    
    NSMutableString *order = [NSMutableString string];
    for(Paint *paint in self.paintOrder){
        
        NSString *finish = [paint finish];
        
        // if the paint order is empty we just choose the cheaper gloss
        if([finish isEqualToString:@""])
            finish = @"G";
        
        [order appendString:finish];
        [order appendString:@" "];
    }
    
    return order;
}


-(void) readInFile:(NSString*) fileName completion:(void (^)(NSString *fileData))completionBlock
{
    NSMutableString *contents = [[NSMutableString alloc]init];
    
    FILE *file = fopen([fileName cStringUsingEncoding:1],"r");
    if (file == NULL){
        
        [contents appendString: [fileName stringByAppendingString:@" not found"]];
        
    }else{
        
        // read in contents from file
        while(!feof(file))
        {
            NSString *line = readLineAsNSString(file);
            
            if([line length] == 0)
                continue;
            
            [contents appendString:line];
            [contents appendString:@"\n"];
        }
    }
    
    fclose(file);
    
    completionBlock(contents);
}


-(bool) parseContents:(NSArray*) contents
{
    // initialise customers
    self.customers = [[NSMutableArray alloc]init];
    
    if (contents == nil){
        return false;
    }else{
        bool firstLine = true;
        
        // create a new customer for each line in the file
        for(NSString *line in contents)
        {
            if([line length] == 0)
                continue;
            
            NSString *trimmedLine = [line stringByTrimmingCharactersInSet:
                                       [NSCharacterSet whitespaceCharacterSet]];
            
            if(firstLine){
                self.numberOfColours = [trimmedLine intValue];
                
                // Initialise the order with Paint objects
                self.paintOrder = [NSMutableArray array];
                for (int i = 0; i < self.numberOfColours; i++) {
                    [self.paintOrder addObject:[[Paint alloc] init:-1 finish:@""]];
                }
                
                firstLine = false;
                
            }else{
                
                NSArray *array = [trimmedLine componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                
                Customer *customer = [[Customer alloc] init];
                
                // Make sure we have even numbers of input values per line
                if([array count] %2 == 0){
                    for(int i=0;i<[array count];i+=2)
                    {
                        int colour = [[array objectAtIndex:i] intValue];
                        
                        // Check colour index isnt greater than the number of colours
                        if(colour > [self.paintOrder count]){
                            return false;
                        }
                        
                        NSString *finish = [array objectAtIndex:i+1];
                        Paint *p = [[Paint alloc] init:colour finish:finish];
                        [customer addPaintChoice:p];
                    }
                    
                    [self.customers addObject:customer];
                }else{
                    return false;
                }
            }
        }
    }
    
    return true;
}


NSString *readLineAsNSString(FILE *file)
{
    char buffer[4096];
    
    // tune this capacity to your liking -- larger buffer sizes will be faster, but
    // use more memory
    NSMutableString *result = [NSMutableString stringWithCapacity:256];
    
    // Read up to 4095 non-newline characters, then read and discard the newline
    int charsRead;
    do
    {
        if(fscanf(file, "%4095[^\n]%n%*c", buffer, &charsRead) == 1)
            [result appendFormat:@"%s", buffer];
        else
            break;
    } while(charsRead == 4095);
    
    return result;
}

@end
