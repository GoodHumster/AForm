//
//  AFSingleRow.m
//  AForm
//
//  Created by Administrator on 28/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import "AFSingleRow.h"

@interface AFSingleRow()

@property (nonatomic, strong) NSString *key;

@end

@implementation AFSingleRow

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
    self.attributes = [AFInputRowAttributes new];
    self.attributes.numberOfRows = 1;
    self.attributes.multiplie = NO;

    return self;
}

#pragma mark - AFInputRow protocol methods

+ (id)rowWithKey:(NSString *)key value:(id<AFValue>)value viewConfig:(id<AFCellConfig>)ivConfig layoutConfig:(AFLayoutConfig *)layoutConfig
{
    AFSingleRow *sRow = [[AFSingleRow alloc] initWithKey:key];
    sRow.value = sRow.value;
    sRow.layoutConfig = layoutConfig;
    sRow.viewConfig = ivConfig;
    
    return sRow;
}

@end
