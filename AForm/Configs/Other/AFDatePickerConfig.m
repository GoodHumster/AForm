//
//  AFDatePickerConfig.m
//  AForm
//
//  Created by Administrator on 15/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import "AFDatePickerConfig.h"

@implementation AFDatePickerConfig

#pragma mark - NSCopying protocol methods

- (id)copyWithZone:(NSZone *)zone
{
    AFDatePickerConfig *config = [AFDatePickerConfig new];
    config.maxDate = [self.maxDate copy];
    config.minDate = [self.minDate copy];
    config.dateFormmat = self.dateFormmat;
    
    return config;
}

@end
