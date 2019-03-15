//
//  AFLayoutConfig.m
//  AForm
//
//  Created by Administrator on 12/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import "AFLayoutConfig.h"

@implementation AFLayoutConfig

+ (id)layoutConfigWithHeightConstrain:(AFLayoutConstraint *)heightConstraint andWidthConstrain:(AFLayoutConstraint *)widthConstraint
{
    AFLayoutConfig *layoutConfig = [AFLayoutConfig new];
    layoutConfig.height = heightConstraint;
    layoutConfig.width = widthConstraint;
    
    return layoutConfig;
}

@end
