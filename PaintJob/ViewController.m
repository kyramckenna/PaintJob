//
//  ViewController.m
//  PaintJob
//
//  Created by Kyra McKenna on 15/03/2017.
//  Copyright © 2017 Kyra McKenna. All rights reserved.
//

#import "ViewController.h"
#import "PaintOrder.h"

@interface ViewController ()

@property (nonatomic, readwrite) PaintOrder *paintOrder;
@property (nonatomic, readwrite) NSString *path;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.path = [[NSBundle mainBundle] pathForResource: @"Job" ofType: @"txt"];
    self.paintOrder = [[PaintOrder alloc]init];
    
    [self.paintOrder readInFile:self.path
                completion:^(NSString *fileData) {
                    if ([fileData length] > 0) {
                        NSLog(@"Read file");
                        
                        self.textView.text = fileData;  
                    }
                    else{
                        self.resultLabel.text = @"Couldnt read file";
                    }
                }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)runButtonPressed:(id)sender {
    
    // Read in any changes from textview the user has made
    NSArray *lines = [self.textView.text componentsSeparatedByString:@"\n"];
    
    bool success = [self.paintOrder parseContents:lines];
    if(!success){
        self.resultLabel.text = @"Couldnt read file";
    }else{
        NSString* output = [self.paintOrder batchOutput];
        self.resultLabel.text = output;
    }
}

- (IBAction)resetButtonPressed:(id)sender {
    
    self.resultLabel.text = @"Result will display here";
    
    [self.paintOrder readInFile:self.path
                     completion:^(NSString *fileData) {
                         if ([fileData length] > 0) {
                             self.textView.text = fileData;
                         }
                         else{
                             self.resultLabel.text = @"Couldnt read file";
                         }
                     }];
}
@end
