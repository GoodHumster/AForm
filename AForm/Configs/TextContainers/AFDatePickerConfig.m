//
//  AFDatePickerConfig.m
//  AForm
//
//  Created by Administrator on 15/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import "AFDatePickerConfig.h"
#import "AFDatePickerView.h"

@implementation AFDatePickerConfig

@synthesize inputViewClass = _inputViewClass;

- (instancetype) init
{
    if ( ( self = [super init]) == nil )
    {
        return nil;
    }
    self.inputViewClass = [AFDatePickerView class];
    return self;
}

#pragma mark - NSCopying protocol methods

- (id)copyWithZone:(NSZone *)zone
{
    AFDatePickerConfig *config = [AFDatePickerConfig new];
    config.maxDate = [self.maxDate copy];
    config.minDate = [self.minDate copy];
    config.dateFormmat = self.dateFormmat;
    config.pickerMode = self.pickerMode;
    config.inputViewClass = self.inputViewClass;
    
    return config;
}




@end
