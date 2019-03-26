//
//  AFTextFieldCellConfig.m
//  AForm
//
//  Created by Administrator on 14/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import "AFTextFieldCellConfig.h"
#import "AFTextFieldCollectionViewCell.h"

#import "AFDefaultVerifier.h"
#import "AFEmailVerifier.h"
#import "AFPhoneNumberVerifier.h"
#import "AFRussianPassportVerifier.h"

@interface AFTextFieldCellConfig()

@property (nonatomic, strong) NSString *identifier;

@end

@implementation AFTextFieldCellConfig

@synthesize identifier = _identifier;
@synthesize minimumDependeciesLineSpacing = _minimumDependeciesLineSpacing;
@synthesize minimumDependeciesInterItemSpacing = _minimumDependeciesInterItemSpacing;


- (instancetype) init
{
    if ( ( self = [super init]) == nil )
    {
        return nil;
    }
    self.identifier = kAFTextFieldCollectionViewCellIdentifier;
    self.textFieldClass = nil;
    return self;
}

#pragma mark - Public API methods

+ (id) defaultTextFieldConfig
{
    AFTextFieldCellConfig *config = [AFTextFieldCellConfig new];
    config.verifier = [AFDefaultVerifier new];
    config.keyboardKeyType = UIKeyboardTypeDefault;
    config.borderStyle = AFTextInputBorderLine;
    
    return config;
}

+ (id) dateTextFieldConfigWithDatePickerConfig:(AFDatePickerConfig *)datePickerConfig
{
    if (!datePickerConfig)
    {
        datePickerConfig = [AFDatePickerConfig new];
    }
    
    AFTextFieldCellConfig *config = [AFTextFieldCellConfig new];
    config.verifier = [AFDefaultVerifier new];
    config.keyboardKeyType = UIKeyboardTypeDefault;
    config.borderStyle = AFTextInputBorderLine;
    config.inputViewConfig = datePickerConfig;
    
    return config;
}

+ (id) emailTextFieldConfig
{
    AFTextFieldCellConfig *config = [AFTextFieldCellConfig new];
    config.verifier = [AFEmailVerifier new];
    config.keyboardKeyType = UIKeyboardTypeDefault;
    config.borderStyle = AFTextInputBorderLine;
    
    return config;
}

#pragma mark - NSCopying protocol methods

- (id)copyWithZone:(NSZone *)zone
{
    AFTextFieldCellConfig *config = [super copyWithZone:zone];
    config.textFieldClass = self.textFieldClass;
    config.placeholder = self.placeholder;
  
    return config;
}


@end
