//
//  GraphView.m
//  GraphCalculator
//
//  Created by Luca Finzi Contini on 02/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GraphView.h"
#import "AxesDrawer.h"

@implementation GraphView

@synthesize dataSource = _dataSource; // datasource is set by a class that implments the protocol.

- (void) setup
{
    self.contentMode = UIViewContentModeRedraw;    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code	
        [self setup];
    }
    NSLog(@"-- INIT WITH FRAME : new size = (%f, %f)", self.bounds.size.width, self.bounds.size.height);
    return self;
}

- (void) awakeFromNib
{
    NSLog(@"-- ENTER awakeFromNib : new size = (%f, %f)", self.bounds.size.width, self.bounds.size.height);
    [self setup];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
/*
 MVC.
 Graph model = scale, origin, vector of points. 
 */
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    // call the class that implements the dataSource
    NSDictionary *data=[self.dataSource getDataForGraphView:self];
    NSNumber *ox = (NSNumber *)[data objectForKey:@"ox"];
    NSNumber *oy = (NSNumber *)[data objectForKey:@"oy"];
    NSNumber *scale = (NSNumber *)[data objectForKey:@"scale"];
    NSArray *Yvalues = (NSArray *)[data objectForKey:@"Yvalues"];
    
    CGContextMoveToPoint(context, 0, [[Yvalues objectAtIndex:0] doubleValue]);
    for ( CGFloat X = 1; X < Yvalues.count; X ++ ){ 
        CGContextAddLineToPoint(context, X, [[Yvalues objectAtIndex:X] doubleValue]);
    }
    
    CGContextStrokePath(context);
    CGPoint o = CGPointMake(ox.doubleValue, oy.doubleValue);
    [AxesDrawer drawAxesInRect:rect originAtPoint:o scale:scale.doubleValue];
}

@end
