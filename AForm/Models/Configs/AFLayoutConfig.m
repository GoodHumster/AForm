//
//  AFLayoutConfig.m
//  AForm
//
//  Created by Administrator on 12/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import "AFLayoutConfig.h"

@implementation AFLayoutConstraint


+ (id) constrainWithMultiplie:(CGFloat)multiplie andConstant:(CGFloat)constant andEstimate:(CGFloat)estimate
{
    AFLayoutConstraint *constraint = [AFLayoutConstraint new];
    constraint.multiplie = multiplie;
    constraint.constant = constant;
    constraint.estimate = estimate;
    
    return constraint;
}

-(id)copyWithZone:(NSZone *)zone
{
    AFLayoutConstraint *copy = [AFLayoutConstraint new];
    copy.multiplie = self.multiplie;
    copy.constant = self.constant;
    copy.estimate = self.estimate;
    
    return copy;
}

@end

@implementation AFLayoutConfig

#pragma mark - init methods

- (instancetype) init
{
    if ( ( self = [super init]) == nil )
    {
        return nil;
    }
    self.minimumLineSpacing = 10;
    self.minimumInteritemSpacing = 10;
    return self;
}

#pragma mark - Public API methods

+ (id)layoutConfigWithHeightConstrain:(AFLayoutConstraint *)heightConstraint andWidthConstrain:(AFLayoutConstraint *)widthConstraint
{
    AFLayoutConfig *layoutConfig = [AFLayoutConfig new];
    layoutConfig.height = heightConstraint;
    layoutConfig.width = widthConstraint;
    
    return layoutConfig;
}

#pragma mark - NSCopying protocol methods

-(id)copyWithZone:(NSZone *)zone
{
    AFLayoutConfig *config = [AFLayoutConfig new];
    config.width = [self.width copy];
    config.height = [self.height copy];
    
    return config;
}


@end
