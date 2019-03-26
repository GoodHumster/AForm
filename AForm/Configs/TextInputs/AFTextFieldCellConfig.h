//
//  AFTextFieldCellConfig.h
//  AForm
//
//  Created by Administrator on 14/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AFBaseTextContainerCellConfig.h"
#import "AFAutocompleteView.h"
#import "AFTextField.h"
#import "AFDatePickerConfig.h"
#import "AFTextFieldCellInputView.h"
#import "AFTextFieldCellInputViewConfig.h"

@interface AFTextFieldCellConfig : AFBaseTextContainerCellConfig

@property (nonatomic, assign) Class<AFTextField> textFieldClass;

@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) NSString *leftViewImageName;
@property (nonatomic, strong) NSString *rightViewImageName;

+ (id) defaultTextFieldConfig;
+ (id) emailTextFieldConfig;
+ (id) numberTextFieldConfig;
+ (id) phoneNumberTextFieldConfigWithLocale:(NSLocale *)locale;
+ (id) dateTextFieldConfigWithDatePickerConfig:(AFDatePickerConfig *)config;

@end
