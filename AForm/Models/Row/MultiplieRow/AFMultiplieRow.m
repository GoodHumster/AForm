//
//  AFMultiplieRow.m
//  AForm
//
//  Created by Administrator on 28/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import "AFMultiplieRow.h"

@interface AFMultiplieRow()

@property (nonatomic, strong) NSMutableArray *rows;
@property (nonatomic, strong) NSString *key;

@end

@implementation AFMultiplieRow

@synthesize key = _key;
@synthesize numberOfRows = _numberOfRows;
@synthesize value = _value;
@synthesize viewConfig = _viewConfig;
@synthesize layoutConfig = _layoutConfig;

#pragma mark - init methods

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

+ (id)multiplieRowWithRows:(NSArray<AFRow *> *)rows andKey:(NSString *)key
{
    AFMultiplieRow *mRow = [[AFMultiplieRow alloc] initWithKey:key];
    mRow.rows = [rows mutableCopy];
    mRow.numberOfRows = rows.count;
    
    return mRow;
}

- (AFRow *)getRowAtIndex:(NSInteger)index
{
    return [self.rows objectAtIndex:index];
}

- (id<AFValue>) value
{
    NSMutableArray *mArray = [NSMutableArray new];
    
    [self.rows enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        AFRow *row = obj;
        if (row.value)
        {
            [mArray addObject:row.value];
        }
    }];
    
    return [mArray copy];
}

@end
