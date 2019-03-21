//
//  AFRow.m
//  AForm
//
//  Created by Administrator on 12/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import "AFRow_Private.h"

#import "AFRowConfig.h"
#import "AFInputViewConfig.h"
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

+ (id) rowWithConfig:(AFRowConfig *)rowConfig inputViewConfig:(id<AFInputViewConfig>)ivConfig layoutConfig:(AFLayoutConfig *)layoutConfig
{
    AFRow *row = [AFRow new];
    row->identifier = @"AFRow";
    row.key = rowConfig.key;
    row.value = rowConfig.value;
    row.inputViewConfig = [(id)ivConfig copy];
    row.layoutConfig = [(id)layoutConfig copy];
    
    return row;
}

+ (id) rowWithKey:(NSString *)key value:(id)value andIdentifier:(NSString *)identifier
{
    AFRow *row = [AFRow new];
    row.key = key;
    row.value = value;
    row->identifier = identifier;
    
    return row;
}

+ (id) rowWithKey:(NSString *)key andIdentifier:(NSString *)identifier
{
    AFRow *row = [AFRow new];
    row.key = key;
    row->identifier = identifier;
    
    return row;
}

@end
