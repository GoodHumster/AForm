//
//  AFRow.m
//  AForm
//
//  Created by Administrator on 12/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import "AFRow_Private.h"
#import "AFBaseCellConfig.h"
#import "AFLayoutConfig.h"

#import "AFSingleRow.h"
#import "AFMultiplieRow.h"
#import "AFCompositeRow.h"

@interface AFRow()
{
    @private
    id<AFInputRow> inputRow;
}

@property (nonatomic, strong) NSString *key;

@end

@implementation AFRow

- (instancetype) init
{
    if ( ( self = [super init]) == nil )
    {
        return nil;
    }
    return self;
}

#pragma mark - Public API methods

+ (id) rowWithKey:(NSString *)key inputViewConfig:(id<AFCellConfig>)ivConfig layoutConfig:(AFLayoutConfig *)layoutConfig
{
    AFRow *row = [AFRow new];
    row->inputRow = [AFSingleRow rowWithKey:key value:nil viewConfig:ivConfig layoutConfig:layoutConfig];
    
    return row;
}

+ (id) compositeRowWithKey:(NSString *)key withRows:(NSArray<AFRow *> *)rows
{
    AFRow *row = [AFRow new];
    row->inputRow = [AFCompositeRow rowCompositeWithRows:rows andKey:key];
    
    return row;
}

+ (id) multiplieRowWithKey:(NSString *)key withRows:(NSArray<AFRow *> *)rows
{
    AFRow *row = [AFRow new];
    row->inputRow = [AFMultiplieRow multiplieRowWithRows:rows andKey:key];
    
    return row;
}

#pragma mark - Private API methods

- (id<AFInputRow>)inputRow
{
    return inputRow;
}

#pragma mark - Get methods

- (id<AFCellConfig>)cellConfig
{
    return inputRow.viewConfig;
}

- (AFLayoutConfig *)layoutConfig
{
    return inputRow.layoutConfig;
}

- (id<AFValue>)value
{
    return inputRow.value;
}

- (NSString *)key
{
    return inputRow.key;
}

#pragma mark - Set methods


- (void) setValue:(id<AFValue>)value
{
    inputRow.value = value;
}

- (void)setCellConfig:(id<AFCellConfig>)cellConfig
{
    inputRow.viewConfig = cellConfig;
}

- (void)setLayoutConfig:(AFLayoutConfig *)layoutConfig
{
    inputRow.layoutConfig = layoutConfig;
}


@end
