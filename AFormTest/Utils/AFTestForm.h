//
//  AFTestForm.h
//  AFormTest
//
//  Created by Administrator on 28/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFForming.h"

NS_ASSUME_NONNULL_BEGIN

@interface AFTestForm : NSObject<AFForming>

+ (id<AFForming>) singleRowOnlyForm;
+ (id<AFForming>) compositeRowForm;

+ (AFRow *) createCompositeRowWithDifferentRows;
+ (AFRow *) createCompositeRowWithCountSingleRows:(NSInteger)numberOfRows;
+ (AFRow *) createSingleRow;
+ (AFRow *) createMultiplieRowWithDifferentRows;
+ (AFRow *) createMultiplieRowWithCountSingleRows:(NSInteger)numberOfRows;

@end

NS_ASSUME_NONNULL_END
