//
//  NSString+AFValue.m
//  AForm
//
//  Created by Administrator on 22/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import "NSString+AFValue.h"

@implementation NSString (AFValue)

- (NSString *) getStringValue
{
    return self;
}

- (id)objectByAppendValue:(id)value
{
    return [self stringByAppendingFormat:@"%@",value];
}

@end
