//
//  AFCompositeRow.m
//  AForm
//
//  Created by Administrator on 27/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import "AFCompositeRow.h"
#import "AFRow_Private.h"

@interface AFCompositeRow()

@property (nonatomic, strong) NSMutableArray *rows;
@property (nonatomic, strong) NSString *key;

@end

@implementation AFCompositeRow

@synthesize key = _key;
@synthesize value = _value;
@synthesize viewConfig = _viewConfig;
@synthesize layoutConfig = _layoutConfig;
@synthesize attributes = _attributes;

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

+ (id) rowCompositeWithRows:(NSArray<AFRow *> *)rows andKey:(NSString *)key
{
    AFCompositeRow *row = [[AFCompositeRow alloc] initWithKey:key];
    row.rows = [rows mutableCopy];
    
    [rows enumerateObjectsUsingBlock:^(AFRow * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        row.attributes.numberOfRows += obj.inputRow.attributes.numberOfRows;
    }];
    
    return row;
}

#pragma mark - AFInputRow protocol methods

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
    __block id<AFValue> value = nil;
    
    [self.rows enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        AFRow *row = obj;
        value = value ? [value objectByAppendValue:row.value] : row.value;
    }];
    
    return value;
}


@end
