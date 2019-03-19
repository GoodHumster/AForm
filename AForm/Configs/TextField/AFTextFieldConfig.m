//
//  AFTextFieldConfig.m
//  AForm
//
//  Created by Administrator on 14/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import "AFTextFieldConfig.h"
#import "AFTextFieldCollectionViewCell.h"

#import "AFDefaultVerifier.h"
#import "AFEmailVerifier.h"
#import "AFPhoneNumberVerifier.h"
#import "AFRussianPassportVerifier.h"

@interface AFTextFieldConfig()

@property (nonatomic, strong) NSString *identifier;

@end

@implementation AFTextFieldConfig

- (instancetype) init
{
    if ( ( self = [super init]) == nil )
    {
        return nil;
    }
    self.inputViewConfig = nil;
    self.textFieldClass = nil;
    self.haveAutocomplete = NO;
    self.identifier = kAFTextFieldCollectionViewCellIdentifier;
    self.font = [UIFont systemFontOfSize:15];
    self.backgroundColor = [UIColor whiteColor];
    self.textColor = [UIColor blackColor];
    return self;
}

#pragma mark - Public API methods

+ (id) defaultTextFieldConfig
{
    AFTextFieldConfig *config = [AFTextFieldConfig new];
    config.verifier = [AFDefaultVerifier new];
    config.keyboardKeyType = UIKeyboardTypeDefault;
    config.borderStyle = AFTextFieldBorderLine;
    
    return config;
}

+ (id) dateTextFieldConfigWithDatePickerConfig:(AFDatePickerConfig *)datePickerConfig
{
    if (!datePickerConfig)
    {
        datePickerConfig = [AFDatePickerConfig new];
    }
    
    AFTextFieldConfig *config = [AFTextFieldConfig new];
    config.verifier = [AFDefaultVerifier new];
    config.keyboardKeyType = UIKeyboardTypeDefault;
    config.borderStyle = AFTextFieldBorderLine;
    config.inputViewConfig = datePickerConfig;
    
    return config;
}

+ (id) emailTextFieldConfig
{
    AFTextFieldConfig *config = [AFTextFieldConfig new];
    config.verifier = [AFEmailVerifier new];
    config.keyboardKeyType = UIKeyboardTypeDefault;
    config.borderStyle = AFTextFieldBorderLine;
    
    return config;
}

#pragma mark - NSCopying protocol methods

- (id)copyWithZone:(NSZone *)zone
{
    AFTextFieldConfig *config = [AFTextFieldConfig new];
    config.textFieldClass = self.textFieldClass;
    config.placeholder = self.placeholder;
    config.haveAutocomplete = self.haveAutocomplete;
    config.autocompleteViewClass = self.autocompleteViewClass;
    config.borderStyle = self.borderStyle;
    config.keyboardKeyType = self.keyboardKeyType;
    config.returnKeyType = self.returnKeyType;
    config.font = self.font;
    config.textColor = self.textColor;
    config.backgroundColor = self.backgroundColor;
    config.verifier = [(id)self.verifier copy];
    config.inputViewConfig = [(id)self.inputViewConfig copy];
    
    return config;
}


@end
