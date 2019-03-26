//
//  AFRow.m
//  AForm
//
//  Created by Administrator on 12/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import "AFRow_Private.h"

#import "AFRowConfig.h"
#import "AFBaseCellConfig.h"
#import "AFLayoutConfig.h"

@interface AFRow()

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

- (instancetype)initWithKey:(NSString *)key value:(id)value andIdentifier:(NSString *)identifier
{
    if ( ( self = [super init]) == nil )
    {
        return nil;
    }
    
    self.key = key;
    self.value = value;
    self->identifier = identifier;

    return self;
}

- (instancetype)initWithKey:(NSString *)key andIdentifier:(NSString *)identifier
{
    if ( ( self = [super init]) == nil )
    {
        return nil;
    }
    
    self.key = key;
    self->identifier = identifier;
    
    return self;
}

#pragma mark - AFCellRow protocol methods

- (AFBaseCellConfig *)config
{
    return self.cellConfig;
}

- (id<AFValue>) cellValue
{
    return self.value;
}

#pragma mark - Public API methods

+ (id) rowWithConfig:(AFRowConfig *)rowConfig inputViewConfig:(AFBaseCellConfig *)ivConfig layoutConfig:(AFLayoutConfig *)layoutConfig
{
    AFRow *row = [AFRow new];
    row->identifier = @"AFRow";
    row.key = rowConfig.key;
    row.value = rowConfig.value;
    row.cellConfig = [(id)ivConfig copy];
    row.cellConfig.layoutConfig = [(id)layoutConfig copy];
    
    return row;
}
#pragma mark - Get/Set

- (void) setValue:(id<AFValue>)value
{
    _value = value;
    
    if ( ![self.output respondsToSelector:@selector(didChangeRowValue)] )
    {
        return;
    }
    
    [self.output didChangeRowValue];
}


@end
