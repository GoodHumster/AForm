//
//  AFMultiplieRow.m
//  AForm
//
//  Created by Administrator on 28/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import "AFMultiplieRow.h"
#import "AFRow_Private.h"

@interface AFMultiplieRow()

@property (nonatomic, strong) NSMutableArray *rows;
@property (nonatomic, strong) NSString *key;

@end

@implementation AFMultiplieRow

@synthesize key = _key;
@synthesize value = _value;
@synthesize viewConfig = _viewConfig;
@synthesize layoutConfig = _layoutConfig;
@synthesize attributes = _attributes;

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
    self.attributes = [AFRowAttributes new];
    self.attributes.multiplie = YES;

    return self;
}

#pragma mark - Public API methods

+ (id)multiplieRowWithRows:(NSArray<AFRow *> *)rows andKey:(NSString *)key
{
    AFMultiplieRow *mRow = [[AFMultiplieRow alloc] initWithKey:key];
    mRow.rows = [rows mutableCopy];
    
    [rows enumerateObjectsUsingBlock:^(AFRow * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        mRow.attributes.numberOfRows += obj.inputRow.attributes.numberOfRows;
    }];
    
    return mRow;
}

- (AFRow *)getRowAtIndex:(NSInteger)index
{
    NSUInteger count = self.rows.count;
    AFRow *row = count <= index ? [self.rows objectAtIndex:count-1] : [self.rows objectAtIndex:index];
    
    if (row.inputRow.attributes.multiplie)
    {
        NSUInteger rlIdx = index - (count - 1);
        return [row.inputRow getRowAtIndex:rlIdx];
    }
    
    return row;
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
