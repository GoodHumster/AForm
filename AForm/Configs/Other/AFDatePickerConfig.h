//
//  AFDatePickerConfig.h
//  AForm
//
//  Created by Administrator on 15/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "AFTextFieldInputViewConfig.h"

@interface AFDatePickerConfig : NSObject<AFTextFieldInputViewConfig>

@property (nonatomic, assign) UIDatePickerMode pickerMode;

@property (nonatomic, strong) NSDate *minDate;

@property (nonatomic, strong) NSDate *maxDate;

@property (nonatomic, strong) NSString *dateFormmat;

@end

