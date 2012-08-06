//
//  GraphViewController.m
//  GraphCalculator
//
//  Created by Luca Finzi Contini on 02/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GraphViewController.h"
#import "CalculatorBrain.h"
#import "GraphView.h"


@interface GraphViewController () <GraphDataSource>

@end

@implementation GraphViewController

@synthesize graphView = _graphView;
@synthesize scale = _scale;    // scale will be set by pinch gesture
@synthesize origin = _origin;  // origin will be set by triple tap gesture. 
@synthesize program = _program;
@synthesize splitViewBarButtonItem = _splitViewBarButtonItem;
@synthesize toolbar = _toolbar;

#define DEFAULT_SCALE 25
- (CGFloat)scale
{
    if (!_scale){
        return DEFAULT_SCALE; 
    }
    else return _scale; 
}

- (CGPoint)origin
{
    if( (!_origin.x) && (!_origin.y)){
        _origin.x = self.graphView.bounds.origin.x + self.graphView.bounds.size.width / 2;
        _origin.y = self.graphView.bounds.origin.y + self.graphView.bounds.size.height/ 2;
    }
    return _origin;
}

-(void)setProgram:(id)program
{
    _program = program;
    [self.graphView setNeedsDisplay];
}

-(void)setScale:(CGFloat)scale
{
    if(scale != _scale){
        _scale = scale; 
        [self.graphView setNeedsDisplay];
    }
}

-(void)setOrigin:(CGPoint)origin
{
    if ( (origin.x != _origin.x) || (origin.y != _origin.y) ) {
        NSLog(@"setOrigin: new Origin= (%f, %f)",origin.x, origin.y );
        _origin = origin;
        [self.graphView setNeedsDisplay];
    }
}

-(void)handlePinch:(UIPinchGestureRecognizer *) gesture
{
    if((gesture.state == UIGestureRecognizerStateChanged) ||
       (gesture.state == UIGestureRecognizerStateEnded)) {
        [self setScale:self.scale * gesture.scale]; 
        gesture.scale = 1;
    }
}

-(void)handlePan:(UIPanGestureRecognizer *)gesture
{
    if((gesture.state == UIGestureRecognizerStateChanged) ||
       (gesture.state == UIGestureRecognizerStateEnded)) {
        CGPoint translation = [gesture translationInView:self.graphView];
        [self setOrigin:CGPointMake(self.origin.x + translation.x , self.origin.y + translation.y )];
        [gesture setTranslation:CGPointZero inView:self.graphView];
    }
}

-(void)handleTripleTap:(UITapGestureRecognizer *)utgr
{
    CGPoint tapPoint = [utgr locationInView:utgr.view.superview];
    [self setOrigin:tapPoint];
}



-(void)setGraphView:(GraphView *)graphView{
    _graphView = graphView;
    self.graphView.dataSource = self;
    self.title = [CalculatorBrain descriptionOfProgram:self.program];
    // inserire gesture recognizer
    [self.graphView addGestureRecognizer:[[ UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)]];
    [self.graphView addGestureRecognizer:[[ UIPanGestureRecognizer alloc] initWithTarget:self  action:@selector(handlePan:)]];
    UITapGestureRecognizer *utgr = [[ UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTripleTap:)];
    utgr.numberOfTapsRequired=3;
    [self.graphView addGestureRecognizer:utgr];
}

-(NSDictionary *)getDataForGraphView:(GraphView *)gv
{
    NSNumber *ox, *oy, *scale;
    ox = [NSNumber numberWithFloat:self.origin.x];
    oy = [NSNumber numberWithFloat:self.origin.y];
    scale = [NSNumber numberWithFloat:self.scale];
    
    NSMutableArray *Yvalues = [[NSMutableArray alloc] init];
    /* for x = min to max 
     creare un dictionary con <valore x>, "x"
     lanciare calculatorBrain runProgram withVariables: ]
     ottengo il calcolo della funzione. 
     */
    
    for( float X = 0; X<self.graphView.bounds.size.width; X+=1.0 ){
        CGFloat x = (X - self.origin.x) / self.scale * 1 / self.graphView.contentScaleFactor;
        NSDictionary *var =[[NSDictionary alloc] initWithObjectsAndKeys:[NSNumber numberWithFloat:x], @"x", nil];
        CGFloat y = [CalculatorBrain runProgram:self.program usingVariables:var];
        //[xvalues addObject:[NSNumber numberWithFloat:x]];
        
        // now need to find the value of 'Y' in screen 'pixel'.
        CGFloat Y = self.origin.y - y * self.scale; //* self.graphView.contentScaleFactor;
        [Yvalues addObject:[NSNumber numberWithFloat:Y]];
        
    }
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc]initWithObjectsAndKeys: 
                                ox, @"ox", 
                                oy, @"oy",
                                scale, @"scale",
                                [[NSArray alloc] initWithArray:Yvalues], @"Yvalues", nil];
    return data;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
return YES; 
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    CGPoint o;
    o.x = self.graphView.bounds.origin.x + self.graphView.bounds.size.width / 2;
    o.y = self.graphView.bounds.origin.y + self.graphView.bounds.size.height/ 2;
    [self setOrigin:o];
}

- (void)viewDidUnload {
    [self setGraphView:nil];
    [super viewDidUnload];
}

-(BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation
{
    return [self splitViewBarButtonItemPresenter] ? UIInterfaceOrientationIsPortrait(orientation) : NO;
}

-(void)splitViewController:(UISplitViewController *)svc 
    willHideViewController:(UIViewController *)aViewController
         withBarButtonItem:(UIBarButtonItem *)barButtonItem 
      forPopoverController:(UIPopoverController *)pc
{
    barButtonItem.title = self.title;
    // tell the detailview to put the button up there.
    [self splitViewBarButtonItemPresenter].splitViewBarButtonItem = barButtonItem;
    
}

-(void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController 
 invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    //tell the detail view to take the button away.
    [self splitViewBarButtonItemPresenter].splitViewBarButtonItem = nil;
}

- (id <SplitViewBarButtonItemPresenter>) splitViewBarButtonItemPresenter
{
    id detailVC  = [self.splitViewController.viewControllers lastObject];
    if(![detailVC conformsToProtocol:@protocol(SplitViewBarButtonItemPresenter)])
    {
        detailVC = nil;
    }
    return detailVC;
    
}

-(void)setSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem{
    if(_splitViewBarButtonItem != splitViewBarButtonItem){
        NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];
        if(_splitViewBarButtonItem) [toolbarItems removeObject:_splitViewBarButtonItem];
        if(splitViewBarButtonItem) [toolbarItems insertObject:splitViewBarButtonItem atIndex:0];
        self.toolbar.items =toolbarItems;
        _splitViewBarButtonItem = splitViewBarButtonItem;
    }
}
@end
