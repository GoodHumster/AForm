//
//  AFPickerConfig.m
//  AForm
//
//  Created by Administrator on 26/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import "AFPickerConfig.h"
#import "AFPickerView.h"

@implementation AFPickerConfig

@synthesize inputViewClass = _inputViewClass;

- (instancetype) init
{
    if ( ( self = [super init]) == nil )
    {
        return nil;
    }
    self.inputViewClass = [AFPickerView class];
    return self;
}

#pragma mark - NSCopying protocol methods

- (id) copyWithZone:(NSZone *)zone
{
    AFPickerConfig *copy = [AFPickerConfig new];
    copy.inputViewClass = self.inputViewClass;
    copy.dataSource = self.dataSource;
    
    return copy;
}

@end
