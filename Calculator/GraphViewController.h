//
//  GraphViewController.h
//  GraphCalculator
//
//  Created by Luca Finzi Contini on 02/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphView.h"
#import "SplitViewBarButtonItemPresenter.h"

@interface GraphViewController : UIViewController <SplitViewBarButtonItemPresenter, UISplitViewControllerDelegate> 
@property (weak, nonatomic) IBOutlet GraphView *graphView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@property (nonatomic) CGFloat scale; 
@property (nonatomic) CGPoint origin;
@property (nonatomic) id program;

@end
