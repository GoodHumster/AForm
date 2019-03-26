//
//  UIScreen+AFScreenMetrics.h
//  AForm
//
//  Created by Administrator on 26/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, AFScreenMetrics)
{
    AFScreenMetrics_Undefinde = 0,
    AFScreenMetrics_inch3_5,
    AFScreenMetrics_inch4,
    AFScreenMetrics_inch4_7,
    AFScreenMetrics_inch5_5,
    AFScreenMetrics_inch5_8,
    AFScreenMetrics_inch6_1,
    AFScreenMetrics_inch6_5,
    AFScreenMetrics_iPad,
    AFScreenMetrics_iPad_12_9
};


@interface UIScreen (AFScreenMetrics)

@property (nonatomic, assign, readonly) AFScreenMetrics screenMetrics;

- (CGFloat) defaultPortraitKeyboardHeight;
- (CGFloat) defaultLandscapeKeyboardHeight;
- (CGFloat) defaultKeyboardHeightForCurrentOrientation;

@end

