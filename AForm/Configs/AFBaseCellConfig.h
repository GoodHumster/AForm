//
//  AFBaseCellConfig.h
//  AForm
//
//  Created by Administrator on 21/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFCellConfig.h"

@interface AFBaseCellConfig : NSObject<AFCellConfig>

- (void) addDependencyConfig:(AFBaseCellConfig *)config withShowPredicate:(NSPredicate *)predicate;

- (void) addAlwaysShowDependencyConfig:(AFBaseCellConfig *)config;

@end

extern NSString *const AFBaseConfigPredicateRowValueKey;
