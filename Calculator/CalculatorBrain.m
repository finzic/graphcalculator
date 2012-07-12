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
@property (nonatomic, strong) NSSet *opSet;

@end

@implementation CalculatorBrain

@synthesize programStack = _programStack;
@synthesize opSet = _opSet;
static NSSet *_myOpSet = nil; 
static NSSet *_myDOset = nil;
static NSSet *_myFuncSet = nil;

+ (NSSet *)myOpSet{
    if(!_myOpSet){
        _myOpSet = [NSSet setWithObjects:@"+", @"-", @"*", @"/", @"√", @"sin", @"cos", nil];
    }
    return _myOpSet;
}

+ (NSSet *)myDOSet{
    if(!_myDOset){
        _myDOset = [NSSet setWithObjects:@"+", @"-", nil];
    }
    return _myDOset;
}

+ (NSSet *)myFuncSet{
    if(!_myFuncSet){
        _myFuncSet = [NSSet setWithObjects:@"sin", @"cos", @"√", nil];
    }
    return _myFuncSet;
}

- (NSSet *)opSet{
    if (!_opSet) {
        _opSet = [[NSSet alloc] initWithObjects:@"+", @"-", @"*", @"/", @"√", nil];
    }
    return _opSet;
}

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

- (id)program{
    return [self.programStack copy];
}

+ (BOOL) isOperation:(NSString *)op{
    return [CalculatorBrain.myOpSet containsObject:op];
}

+ (BOOL) isSingleOperandOperation:(NSString *)op{
    return [CalculatorBrain.myFuncSet containsObject:op];
}

+ (BOOL) isDoubleOperandLoPrioOperation:(NSString *)op{
    return [CalculatorBrain.myDOSet containsObject:op];
}


+ (NSString *)descriptionOfTopOfStack:(NSMutableArray *)stk atLevel:(int) i{
    id top = [stk lastObject];
    if(top) [stk removeLastObject]; // pop
    NSString *desc;
        if( ![CalculatorBrain isOperation:top] ){
        if ([top isKindOfClass:[NSNumber class]]) {
            desc = [top stringValue];
        } else { // this handles the case of variables.
            desc = top; 
        }
        NSLog(@" Not an Operation :desc = %@, level = %d", desc, i );
    } 
    else {
        NSString *op = top;
        if([CalculatorBrain isSingleOperandOperation:op]){
            desc = [[NSString alloc] initWithFormat:@"%@(%@)", op, [CalculatorBrain descriptionOfTopOfStack:stk atLevel:i]];
            NSLog(@"Single Operand Operation: desc = %@, level = %d", desc, i );
        } else if ([CalculatorBrain isDoubleOperandLoPrioOperation:op]){
            
            NSString *subt=[CalculatorBrain descriptionOfTopOfStack:stk atLevel: i + 1 ];
            if(i == 0){
                desc = [[NSString alloc] initWithFormat:@"%@%@%@ ", [CalculatorBrain descriptionOfTopOfStack:stk atLevel: i + 1], op, subt];
            } else {
                desc = [[NSString alloc] initWithFormat:@"(%@%@%@)", [CalculatorBrain descriptionOfTopOfStack:stk atLevel: i], op, subt];
                
            }
            NSLog(@"DoubleOperand Lo Prio Operation: desc = %@, level = %d", desc, i );
        } 
        else {
            NSString *dividend=[CalculatorBrain descriptionOfTopOfStack:stk atLevel: i + 1];
            desc = [[NSString alloc] initWithFormat:@"%@%@%@", [CalculatorBrain descriptionOfTopOfStack:stk atLevel: i + 1], op, dividend];
            NSLog(@"Double Operand Hi Prio Operation: desc = %@, level = %d", desc, i );
        } 
    }
    return desc;
}

+ (NSString *)descriptionOfProgram:(id)program{
    NSMutableArray *stack;
    NSMutableArray *results= [[NSMutableArray alloc] init];
    if([program isKindOfClass:[NSArray class]]){
        stack = [program mutableCopy];
    }
    
    while (stack.count > 0){
        [results addObject:[CalculatorBrain descriptionOfTopOfStack:stack atLevel:0]];
    }
    
    return [results componentsJoinedByString:@", "];

//    return @"Implement this in Assignment #2";
}


- (double)performOperation:(NSString *)operation{
    [self.programStack addObject:operation];
//    return [CalculatorBrain runProgram:self.program usingVariables:self.vars];
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
            result = 3.14159265;
        } else if ([operation isEqualToString:@"√"]){
            result = sqrt([self popOperandOffStack:stack]);
        } else if([operation isEqualToString:@"sin"]){
            result = sin([self popOperandOffStack:stack]);
        } else if([operation isEqualToString:@"cos"]){
            result = cos([self popOperandOffStack:stack]);
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


+ (double) runProgram:(id)program usingVariables:(NSDictionary *)usingVariableValues{
/*
 input: I have a program made with variables,
 first I substitute variables with values IN the program
 then I call the original runProgram and I'm done ;)
 keys=NSString
 values=NSNumber
*/
    double result=0;
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]){
        stack = [program mutableCopy];
        NSLog(@"Stack before substitution:%@", [stack componentsJoinedByString:@","]);
        // now we need to process the stack and substitute variables with values.
        for (NSUInteger i=0; i<stack.count; i++){
            id key = [stack objectAtIndex:i];
            double value = 0.0;
            if([key isKindOfClass:[NSString class]]){
                // look up obj in dictionary
                // if I get an operation and it's not in the dict it is not substituted
                // so it remains correct.
                NSNumber *obj=[usingVariableValues objectForKey:key];
                if(obj){
                    value = [obj doubleValue];
                    [stack replaceObjectAtIndex:i withObject:[NSNumber numberWithDouble:value]];
                }
                
            }

        }
        // now I have a NSMutableArray that has been replaced with values.
        NSLog(@"Stack after substitution:%@", [stack componentsJoinedByString:@","]);
        result = [self popOperandOffStack:stack];
    }

    return result; 
}

- (void)clear{
    while (self.programStack.count > 0) {
        [CalculatorBrain popOperandOffStack:self.programStack];
    }
}

+ (NSSet *)variablesUsedInProgram:(id)program{
    // returns NSSet of NSString's...
}

- (void)popElement{
    NSMutableArray *s = self.programStack;
    id topOfStack = [s lastObject];
    if(topOfStack) [s removeLastObject];
}


@end
