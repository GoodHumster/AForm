//
//  AFSection.h
//  AForm
//
//  Created by Administrator on 12/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class AFRow;
@class AFLayoutConfig;

@protocol AFHeaderViewConfig;

@interface AFSection : NSObject

@property (nonatomic, strong) id<NSCopying> value;

@property (nonatomic, strong, readonly) NSArray *rows;

@property (nonatomic, strong) AFLayoutConfig *layoutConfig;

@property (nonatomic, strong) id<AFHeaderViewConfig> headerConfig;

@property (nonatomic, assign) UIEdgeInsets insets;

+ (id) sectionWithTitle:(NSString *)title;

+ (id) sectionWithTitle:(NSString *)title andHeaderConfig:(id<AFHeaderViewConfig>)config layoutConfig:(AFLayoutConfig *)layoutConfig;

- (void) addRow:(AFRow *)row;

- (void) addRows:(NSArray *)rows;

@end
