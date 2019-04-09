//
//  AFInputRow.h
//  AForm
//
//  Created by Administrator on 28/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFValue.h"
#import "AFCellConfig.h"
#import "AFLayoutConfig.h"
#import "AFRow.h"
#import "AFInputRowAttributes.h"

@protocol AFInputRow <NSObject>

@property (nonatomic, strong, readonly) NSString *key;
@property (nonatomic, strong) id<AFValue> value;
@property (nonatomic, strong) id<AFCellConfig> viewConfig;
@property (nonatomic, strong) AFLayoutConfig *layoutConfig;
@property (nonatomic, strong) AFInputRowAttributes *attributes;

- (AFRow *) getRowAtIndex:(NSInteger)index;

@end

@interface AFInputRow : NSObject<AFInputRow>

+ (id<AFInputRow>)singleRowWithKey:(NSString *)key inputViewConfig:(id<AFCellConfig>)ivConfig layoutConfig:(AFLayoutConfig *)layoutConfig;
+ (id<AFInputRow>)compositeRowWithKey:(NSString *)key withRows:(NSArray<AFRow *> *)rows;
+ (id<AFInputRow>)multiplieRowWithKey:(NSString *)key withRows:(NSArray<AFRow *> *)rows;


@end
