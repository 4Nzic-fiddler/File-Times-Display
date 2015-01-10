//
//  NilDateTransformer.m
//  File Times Display
//
//  Created by Randy Pargman on 1/5/15.
//  Copyright (c) 2015 Randy Pargman. All rights reserved.
//

#import "NilDateTransformer.h"

@implementation NilDateTransformer
+ (Class) transformedValueClass
{
    return [NSString class];
}

- (id) transformedValue: (id) inValue
{
	if (inValue == nil)
		inValue = @"caught nil";
	
	return inValue;
}
@end
