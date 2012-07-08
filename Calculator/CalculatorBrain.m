//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Luca Finzi Contini on 6/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *programStack;
@end

@implementation CalculatorBrain

@synthesize programStack = _programStack;

- (NSMutableArray *) programStack{
    if(!_programStack){
        _programStack = [[NSMutableArray alloc] init];
    }
    return _programStack;
}

- (void)pushOperand:(double)operand{
    NSNumber *operandObject = [NSNumber numberWithDouble:operand];
    [self.programStack addObject:operandObject];
}

/*-(double)popOperand{
    NSNumber *operandObject = self.programStack.lastObject;
    if(operandObject) [self.programStack removeLastObject];
    return [operandObject doubleValue ];
}
 
*/


- (id)program{
    return [self.programStack copy];
}

+ (NSString *)descriptionOfProgram:(id)program{
    return @"Implement this in Assignment #2";
}


- (double)performOperation:(NSString *)operation{
    [self.programStack addObject:operation];
    return [CalculatorBrain runProgram:self.program];
}

+ (double)popOperandOffStack:(NSMutableArray *)stack {
    double result=0; 
    
    id topOfStack = [stack lastObject];
    if(topOfStack) [stack removeLastObject];
    
    if([topOfStack isKindOfClass:[NSNumber class]]){
        result = [topOfStack doubleValue];
    }
    else if ([topOfStack isKindOfClass:[NSString class]]){
        NSString *operation = topOfStack;
        if ([operation isEqualToString:@"+"]) {
            result = [self popOperandOffStack:stack] + [self popOperandOffStack:stack];
        } else if ([@"*" isEqualToString:operation]){
            result = [self popOperandOffStack:stack] * [self popOperandOffStack:stack];
        } else if ([operation isEqualToString:@"-"]) {
            double subtrahend = [self popOperandOffStack:stack];
            result = [self popOperandOffStack:stack] - subtrahend;
        } else if ([operation isEqualToString:@"/"]){
            double divisor = [self popOperandOffStack:stack];
            if (divisor) result = [self popOperandOffStack:stack] / divisor;
        } else if ([operation isEqualToString:@"π"]) {
            result = 3.1416;
        } else if ([operation isEqualToString:@"√"]){
            result = sqrt([self popOperandOffStack:stack]);
        }
    }
    
    return result;
}

+ (double) runProgram:(id)program{
    NSMutableArray *stack;
    if([program isKindOfClass:[NSArray class]]){
        stack = [program mutableCopy];
    }
    return [self popOperandOffStack:stack];
}

- (void)clear{
    while (self.programStack.count > 0) {
        [CalculatorBrain popOperandOffStack:self.programStack];
    }
}

- (NSString *)listOperandStack{
    //NSNumber *obj;
    //NSString *result =@"";
    //NSEnumerator *stackEnumerator = [self.operandStack objectEnumerator];
    //while (obj = [stackEnumerator nextObject]){
    //    NSString *n = [NSString stringWithFormat:@"%g", obj.doubleValue];
    //    result = [[result stringByAppendingString:n] stringByAppendingString:@" "];
    //}
    NSString *otherResult=[self.programStack componentsJoinedByString:@","];
    return otherResult;
}

@end
