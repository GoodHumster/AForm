//
//  NSObject+AFUtils.m
//  AForm
//
//  Created by Administrator on 09/04/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import "NSObject+AFUtils.h"

@implementation NSObject (AFUtils)

- (id)af_objectAsClass:(Class)cls
{
    return [self isKindOfClass:cls] ? self : nil;
}

- (id)af_objectAsProto:(Protocol *)proto
{
    return [self conformsToProtocol:proto] ? self : nil;
}

@end
