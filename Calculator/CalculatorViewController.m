//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Luca Finzi Contini on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic) BOOL userHasAlreadyEnteredADot;
@property (nonatomic, strong) CalculatorBrain *brain;
@end

@implementation CalculatorViewController
@synthesize display = _display;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize userHasAlreadyEnteredADot = _userHasAlreadyEnteredADot;
@synthesize brain = _brain;
@synthesize stackStrip = _stackStrip;
@synthesize stackContent = _stackContent;

- (CalculatorBrain *)brain{
    if (!_brain){
        _brain = [[CalculatorBrain alloc] init];
    }
    return _brain;
}

- (IBAction)dotPressed:(UIButton *)sender {
// if user is in the middle of entering a number and has not yet inserted a dot then we insert one    
    NSString *dot = [sender currentTitle];
    if(!self.userHasAlreadyEnteredADot && self.userIsInTheMiddleOfEnteringANumber){
        self.display.text = [self.display.text stringByAppendingString:dot];
        self.userHasAlreadyEnteredADot = YES;
    } else if (!self.userHasAlreadyEnteredADot && !self.userIsInTheMiddleOfEnteringANumber){
        self.display.text = @"0.";
        self.userIsInTheMiddleOfEnteringANumber = YES;
        self.userHasAlreadyEnteredADot = YES;
    }
}


- (IBAction)digitPressed:(UIButton *)sender 
{
    NSString *digit = [sender currentTitle]; 
    if (self.userIsInTheMiddleOfEnteringANumber) {
        self.display.text = [self.display.text stringByAppendingString:digit];
    } else {
        self.display.text = digit; 
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}


- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    // append current number on display to stackView
    self.stackStrip.text = [[self.stackStrip.text stringByAppendingString:@" "] stringByAppendingString:self.display.text];
    self.userIsInTheMiddleOfEnteringANumber = NO;
    // we must reset also the 'dot' flag.
    self.userHasAlreadyEnteredADot = NO;
    self.stackContent.text = self.brain.listOperandStack;
}
- (IBAction)cancelPressed {
    // User pressed cancel -> need to clear the stack and clear the stackStrip.
    self.stackStrip.text = @" ";
    self.stackContent.text = @" ";
    self.display.text = @"0";
    self.userIsInTheMiddleOfEnteringANumber = NO;
    [self.brain  clear];
    
}

- (IBAction)operationPressed:(id)sender {
    if(self.userIsInTheMiddleOfEnteringANumber){
        [self enterPressed];
    }
    NSString *operation = [sender currentTitle];
    double result = [self.brain performOperation:operation];
    self.display.text = [NSString stringWithFormat:@"%g", result];
    self.stackStrip.text = [[self.stackStrip.text stringByAppendingString:@" "] stringByAppendingString:operation];
    self.stackContent.text = self.brain.listOperandStack;
}
- (IBAction)backspacePressed:(id)sender {
    // remove last digit in display if user is in the middle of entering a number
    if(self.userIsInTheMiddleOfEnteringANumber){
        NSString *currentDisplay=self.display.text; 
        NSString *newDisplay=[currentDisplay substringToIndex:[currentDisplay length] -1];
        //if userHasAlreadyEnteredADot and we deleted it we need to reset the flag
        NSRange r = [newDisplay rangeOfString:@"."];
        if(self.userHasAlreadyEnteredADot && r.location==NSNotFound){
            // we deleted the dot
            self.userHasAlreadyEnteredADot = NO;
        }
        self.display.text=newDisplay;
    }
}

- (IBAction)heyAction:(id)sender {
                               UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Ciao Emiliano"
                                                                                 message:@"Higgs boson to come"
                                                                                delegate:nil
                                                                       cancelButtonTitle:@"OK"
                                                                       otherButtonTitles:nil];
                               
                               [message show];
}


- (void)viewDidUnload {
    [self setStackStrip:nil];
    [self setStackContent:nil];
    [super viewDidUnload];
}
@end
