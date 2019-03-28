//
//  AFBaseCellConfig.m
//  AForm
//
//  Created by Administrator on 21/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import "AFBaseCellConfig_Private.h"

#import "AFLayoutConfig.h"

@interface AFBaseCellDependency : NSObject

@property (nonatomic, strong) AFBaseCellConfig *config;
@property (nonatomic, strong) NSPredicate *predicate;

@end

@implementation AFBaseCellDependency
@end

@interface AFBaseCellConfig()
@end

@implementation AFBaseCellConfig

@synthesize identifier = _identifier;

- (instancetype) init
{
    if ( ( self = [super init]) == nil )
    {
        return nil;
    }
    return self;
}

#pragma mark - NSCoping protocol methods

- (id) copyWithZone:(NSZone *)zone
{
    AFBaseCellConfig *copy = [self.class new];
    return copy;
}


@end
