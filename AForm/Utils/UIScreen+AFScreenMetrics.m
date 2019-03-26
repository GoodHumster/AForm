//
//  UIScreen+AFScreenMetrics.m
//  AForm
//
//  Created by Administrator on 26/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import "UIScreen+AFScreenMetrics.h"

@implementation UIScreen (AFScreenMetrics)

- (AFScreenMetrics)screenMetrics
{
    CGFloat height = CGRectGetHeight(self.fixedCoordinateSpace.bounds);
    NSArray *screenMetricsVector = @[@812,@480,@568,@667,@736,@812,@896,@896,@1024,@1366];
    AFScreenMetrics metric = [screenMetricsVector indexOfObject:@(height)];
    return metric;
}

- (CGFloat)defaultPortraitKeyboardHeight
{
    switch (self.screenMetrics) {
        case AFScreenMetrics_inch3_5:
        case AFScreenMetrics_inch4:
            return 253;
        case AFScreenMetrics_inch4_7:
            return 260;
        case AFScreenMetrics_inch5_5:
            return 271;
        case AFScreenMetrics_inch5_8:
            return 335;
        case AFScreenMetrics_inch6_1:
        case AFScreenMetrics_inch6_5:
            return 346;
        case AFScreenMetrics_iPad:
            return 313;
        case AFScreenMetrics_iPad_12_9:
            return 378;
        case AFScreenMetrics_Undefinde:
            return 335;
        default:
            break;
    }
    
    return 0;
}

- (CGFloat)defaultLandscapeKeyboardHeight
{
    switch (self.screenMetrics) {
        case AFScreenMetrics_inch3_5:
        case AFScreenMetrics_inch4:
            return 199;
        case AFScreenMetrics_inch4_7:
        case AFScreenMetrics_inch5_5:
            return 200;
        case AFScreenMetrics_inch5_8:
        case AFScreenMetrics_inch6_1:
        case AFScreenMetrics_inch6_5:
            return 209;
        case AFScreenMetrics_iPad:
            return 398;
        case AFScreenMetrics_iPad_12_9:
            return 471;
        case AFScreenMetrics_Undefinde:
            return 209;
        default:
            break;
    }
}

- (CGFloat)defaultKeyboardHeightForCurrentOrientation
{
    UIDevice *device = [UIDevice currentDevice];
    
    if (device.orientation == UIDeviceOrientationPortrait)
    {
        return self.defaultPortraitKeyboardHeight;
    } else {
        return self.defaultLandscapeKeyboardHeight;
    }
}

@end

