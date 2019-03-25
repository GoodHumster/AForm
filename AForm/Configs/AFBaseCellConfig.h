//
//  AFBaseCellConfig.h
//  AForm
//
//  Created by Administrator on 21/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "AFCellConfig.h"

@interface AFBaseCellConfig : NSObject<AFCellConfig>

@property (nonatomic, assign) UIEdgeInsets insets;

- (void) addDependencyConfig:(AFBaseCellConfig *)config withShowPredicate:(NSPredicate *)predicate;

- (void) addAlwaysShowDependencyConfig:(AFBaseCellConfig *)config;

@end

extern NSString *const AFBaseConfigPredicateRowValueKey;
