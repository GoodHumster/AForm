//
//  AFTextFieldConfig.h
//  AForm
//
//  Created by Administrator on 14/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AFInputViewConfig.h"
#import "AFAutocompleteView.h"
#import "AFTextField.h"
#import "AFDatePickerConfig.h"
#import "AFTextFieldInputView.h"
#import "AFTextFieldInputViewConfig.h"

typedef NS_ENUM(NSInteger, AFTextFieldBorderStyle)
{
    AFTextFieldBorderNone,
    AFTextFieldBorderLine,
    AFTextFieldBorderBezel,
    AFTextFieldBorderRoundedRect,
    AFTextFieldBorderUnderline
};

@interface AFTextFieldConfig : NSObject<AFInputViewConfig>

@property (nonatomic, assign) Class<AFTextField> textFieldClass;

@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, assign) NSTextAlignment textAlignment;
@property (nonatomic, strong) NSString *leftViewImageName;
@property (nonatomic, strong) NSString *rightViewImageName;

@property (nonatomic, assign) BOOL haveAutocomplete;
@property (nonatomic, assign) Class<AFAutocompleteView> autocompleteViewClass;

@property (nonatomic, assign) AFTextFieldBorderStyle borderStyle;
@property (nonatomic, assign) UIKeyboardType keyboardKeyType;
@property (nonatomic, assign) UIReturnKeyType returnKeyType;

@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, assign) CGFloat borderWidth;

@property (nonatomic, strong) id<AFTextVerifier> verifier;
@property (nonatomic, strong) id<AFTextFieldInputViewConfig> inputViewConfig;

+ (id) defaultTextFieldConfig;
+ (id) emailTextFieldConfig;
+ (id) numberTextFiedlConfig;
+ (id) passportNumberTextFieldConfigWithLocale:(NSLocale *)locale;
+ (id) passportSeriesTextFieldConfigWithLocale:(NSLocale *)locale;
+ (id) passportNumberAndSeriesTextFieldConfigWithLocale:(NSLocale *)locale;
+ (id) phoneNumberTextFieldConfigWithLocale:(NSLocale *)locale;
+ (id) dateTextFieldConfigWithDatePickerConfig:(AFDatePickerConfig *)config;

@end
