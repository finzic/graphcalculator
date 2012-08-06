//
//  GraphView.h
//  GraphCalculator
//
//  Created by Luca Finzi Contini on 02/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GraphView;

@protocol GraphDataSource
-(NSDictionary *)getDataForGraphView:(GraphView *)gv;
@end

@interface GraphView : UIView
	
@property (nonatomic, weak) IBOutlet id <GraphDataSource> dataSource; 

@end
