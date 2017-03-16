//
//  ViewController.h
//  PaintJob
//
//  Created by Kyra McKenna on 15/03/2017.
//  Copyright © 2017 Kyra McKenna. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UIButton *runButton;
@property (weak, nonatomic) IBOutlet UITextView *textView;

- (IBAction)runButtonPressed:(id)sender;
- (IBAction)resetButtonPressed:(id)sender;

@end

