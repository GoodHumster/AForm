//
//  AFCompositeRow.m
//  AForm
//
//  Created by Administrator on 27/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import "AFCompositeRow.h"

@interface AFCompositeRow()

@property (nonatomic, strong) NSMutableArray *rows;
@property (nonatomic, strong) NSString *key;

@end

@implementation AFCompositeRow

@synthesize key = _key;
@synthesize numberOfRows = _numberOfRows;
@synthesize value = _value;
@synthesize viewConfig = _viewConfig;
@synthesize layoutConfig = _layoutConfig;

- (instancetype) initWithKey:(NSString *)key
{
    if ( ( self = [super init]) == nil )
    {
        return nil;
    }
    self.key = key;
    self.viewConfig = nil;
    self.layoutConfig = nil;
    
    return self;
}

#pragma mark - Public API methods

+ (id) rowCompositeWithRows:(NSArray<AFRow *> *)rows andKey:(NSString *)key
{
    AFCompositeRow *row = [[AFCompositeRow alloc] initWithKey:key];
    row.rows = [rows mutableCopy];
    row.numberOfRows = rows.count;
    
    return rows;
}

#pragma mark - AFInputRow protocol methods

- (AFRow *)getRowAtIndex:(NSInteger)index
{
    return [self.rows objectAtIndex:index];
}

- (id<AFValue>) value
{
    __block id<AFValue> value = nil;
    
    [self.rows enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        AFRow *row = obj;
        value = value ? [value objectByAppendValue:row.value] : row.value;
    }];
    
    return value;
}


@end
