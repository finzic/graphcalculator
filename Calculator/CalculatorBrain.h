//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Luca Finzi Contini on 6/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject
- (void)pushOperand:(double)operand;
- (double)performOperation:(NSString *)operation; 
- (void) clear;
- (NSString *)listOperandStack;


@end
