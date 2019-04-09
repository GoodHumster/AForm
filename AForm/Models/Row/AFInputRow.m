//
//  AFInputRow.m
//  AForm
//
//  Created by Administrator on 09/04/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFInputRow.h"

#import "AFSingleRow.h"
#import "AFMultiplieRow.h"
#import "AFCompositeRow.h"

@implementation AFInputRow

@synthesize key = _key;
@synthesize value = _value;
@synthesize layoutConfig = _layoutConfig;
@synthesize viewConfig = _viewConfig;
@synthesize attributes = _attributes;

#pragma mark - Public API methods

+ (id<AFInputRow>)singleRowWithKey:(NSString *)key inputViewConfig:(id<AFCellConfig>)ivConfig layoutConfig:(AFLayoutConfig *)layoutConfig
{
    return [AFSingleRow rowWithKey:key value:nil viewConfig:ivConfig layoutConfig:layoutConfig];
}

+ (id<AFInputRow>)compositeRowWithKey:(NSString *)key withRows:(NSArray<AFRow *> *)rows
{
    AFCompositeRow *row = [AFCompositeRow rowCompositeWithRows:rows andKey:key];
    
    return row;
}

+ (id<AFInputRow>)multiplieRowWithKey:(NSString *)key withRows:(NSArray<AFRow *> *)rows
{
    AFMultiplieRow *row = [AFMultiplieRow multiplieRowWithRows:rows andKey:key];
    
    return row;
}

- (AFRow *)getRowAtIndex:(NSInteger)index
{
    return nil;
}

@end
