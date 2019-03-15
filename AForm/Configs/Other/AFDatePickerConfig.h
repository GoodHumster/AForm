//
//  AFDatePickerConfig.h
//  AForm
//
//  Created by Administrator on 15/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFDatePickerConfig : NSObject<NSCopying>

@property (nonatomic, strong) NSDate *minDate;

@property (nonatomic, strong) NSDate *maxDate;

@property (nonatomic, strong) NSString *dateFormmat;

@end

