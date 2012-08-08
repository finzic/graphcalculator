//
//  RotatableViewController.m
//  GraphCalculator
//
//  Created by Luca Finzi Contini on 06/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import "RotatableViewController.h"

@interface RotatableViewController ()

@end

@implementation RotatableViewController

-(void)awakeFromNib {
    [super awakeFromNib];
    
}

-(BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation
{
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
