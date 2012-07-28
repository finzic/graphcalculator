//
//  StringBool.m
//  Calculator
//
//  Created by Luca Finzi Contini on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "StringBool.h"

@implementation StringBool
@synthesize desc = _desc;
@synthesize needParen = _needParen;

- (id) initWithDesc:(NSString *)d 
       andNeedParen:(NSNumber *)n {
    id result; 
    if( self = [super init] ){
        self.desc = d;
        self.needParen = n;
        result = self;
    }
    else result = nil;
    return result;
}

@end



