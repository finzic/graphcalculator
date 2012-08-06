//
//  CalculatorViewController.h
//  Calculator
//
//  Created by Luca Finzi Contini on 6/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalculatorViewController : UIViewController <UISplitViewControllerDelegate>
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *display;

@property (weak, nonatomic) IBOutlet UILabel *stackStrip;

@property (weak, nonatomic) IBOutlet UILabel *stackContent;

@end
