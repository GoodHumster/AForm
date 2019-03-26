//
//  AFBaseTextContainerCellConfig.h
//  AForm
//
//  Created by Administrator on 25/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AFBaseCellConfig.h"
#import "AFTextFieldCellInputViewConfig.h"
#import "AFTextFieldCellInputView.h"
#import "AFAutocompleteView.h"
#import "AFTextVerifier.h"

typedef NS_ENUM(NSInteger, AFTextInputBorderStyle)
{
    AFTextInputBorderNone,
    AFTextInputBorderLine,
    AFTextInputBorderBezel,
    AFTextInputBorderRoundedRect,
    AFTextInputBorderUnderline
};

@interface AFBaseTextContainerCellConfig : AFBaseCellConfig

@property (nonatomic, assign) NSTextAlignment textAlignment;
@property (nonatomic, assign) AFTextInputBorderStyle borderStyle;
@property (nonatomic, assign) UIKeyboardType keyboardKeyType;
@property (nonatomic, assign) UIReturnKeyType returnKeyType;

@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *textColor;

@property (nonatomic, assign) BOOL haveAutocomplete;
@property (nonatomic, assign) Class<AFAutocompleteView> autocompleteViewClass;

@property (nonatomic, strong) id<AFTextVerifier> verifier;
@property (nonatomic, strong) id<AFTextFieldCellInputViewConfig> inputViewConfig;

@end

