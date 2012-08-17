//
//  CalculatorTableViewController.h
//  GraphCalculator
//
//  Created by Luca Finzi Contini on 14/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CalculatorTableViewController;
@protocol CalculatorTableViewControllerDelegate
@optional
-(void)calculatorTableViewController:(CalculatorTableViewController *)sender
                        choseProgram:(id)program;
@end

@interface CalculatorTableViewController : UITableViewController
@property (nonatomic, strong) NSArray *programs; //of CalculatorBrain programs
// here we set the delegate as a local weak property of the TVC.
@property (nonatomic, weak) id <CalculatorTableViewControllerDelegate> delegate;

@end
