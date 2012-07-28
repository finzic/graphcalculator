//
//  StringBool.h
//  Calculator
//
//  Created by Luca Finzi Contini on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringBool : NSObject
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSNumber *needParen; 
- (id) initWithDesc:(NSString *)d andNeedParen:(NSNumber *)n;
@end
