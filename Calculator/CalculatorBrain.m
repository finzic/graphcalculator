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


+ (NSArray *)descriptionOfTopOfStack:(NSMutableArray *)stk {
    // At the end of the method,  a NS Array will be created with NSString *desc and BOOL paren.
    // if there's a low prio op, paren is set to YES and the returning level will add a parenthesisation
    NSString *desc, *dividendFormat, *divisorFormat, *format;
    BOOL paren = NO;
    id top = [stk lastObject];
    if(top) [stk removeLastObject]; // pop
    
    if( ![CalculatorBrain isOperation:top] ){
        if ([top isKindOfClass:[NSNumber class]]) {
            desc = [top stringValue];
        } else { // this handles the case of variables.
            desc = top; 
        }
        paren = NO;
        //NSLog(@" Not an Operation :desc = %@, level = %d", desc, paren );
    } 
    else {
        NSString *op = top;
        if([CalculatorBrain isSingleOperandOperation:op]){
            desc = [[NSString alloc] initWithFormat:@"%@(%@)", op, [[CalculatorBrain descriptionOfTopOfStack:stk] objectAtIndex:0]];
            paren = NO;
            //NSLog(@"Single Operand Operation: desc = %@, level = %d", desc, paren);
        } else if ([CalculatorBrain isDoubleOperandLoPrioOperation:op]){
            NSString *subt= [[CalculatorBrain descriptionOfTopOfStack:stk] objectAtIndex:0];
            desc = [[NSString alloc] initWithFormat:@"%@%@%@", [[CalculatorBrain descriptionOfTopOfStack:stk] objectAtIndex:0], op, subt];
            paren = YES;
            //NSLog(@"DoubleOperand Lo Prio Operation: desc = %@, level = %d", desc, paren );
        } 
        else {
            
            NSArray *divisorArray = [CalculatorBrain descriptionOfTopOfStack:stk];
            NSString *divisor=[divisorArray objectAtIndex:0];
            // paren = [divisorArray objectAtIndex:1]
            if ( [[divisorArray objectAtIndex:1] boolValue] ){
                divisorFormat = @"(%@)";
            } else {
                divisorFormat = @"%@";
            }

            NSArray *dividendArray = [CalculatorBrain descriptionOfTopOfStack:stk] ;
            NSString *dividend=[dividendArray objectAtIndex:0 ];
            // paren = [dividendArray objectAtIndex:1] 
            if ([[dividendArray objectAtIndex:1] boolValue] ){
                dividendFormat = @"(%@)";
            } else {
                dividendFormat = @"%@";
            }
                        format = [[[NSArray alloc] initWithObjects:dividendFormat, divisorFormat, nil] componentsJoinedByString:@"%@"];
            desc = [[NSString alloc] initWithFormat:format, dividend, op, divisor];
            paren = NO;
            //NSLog(@"Double Operand Hi Prio Operation: desc = %@, level = %d", desc, paren );
        } 
    }
    
    return [[NSArray alloc] initWithObjects:desc, [NSNumber numberWithBool:paren] , nil];
}

+ (NSString *)descriptionOfProgram:(id)program{
    NSMutableArray *stack;
    NSMutableArray *results= [[NSMutableArray alloc] init];
    if([program isKindOfClass:[NSArray class]]){
        stack = [program mutableCopy];
    }
    
    while (stack.count > 0){
        //descriptionOfTopOfStack is going to return an array with 2 elements: 
        // 0: NSString;
        // 1: BOOL flag that says 'needParen'.
        
        //[results addObject:[CalculatorBrain descriptionOfTopOfStack:stack needParen:[NSNumber numberWithInt:0]]];
        NSArray *d = [CalculatorBrain descriptionOfTopOfStack:stack];
    
        [results addObject:[d objectAtIndex:0]];
        
        
    }
    NSString *s = [results componentsJoinedByString:@", "];
    return s;

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
        //NSLog(@"Stack before substitution:%@", [stack componentsJoinedByString:@","]);
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
        //NSLog(@"Stack after substitution:%@", [stack componentsJoinedByString:@","]);
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
