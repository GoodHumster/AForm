//
//  AFTextFieldCollectionViewCell.m
//  AForm
//
//  Created by Administrator on 12/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import "AFTextFieldCollectionViewCell.h"

#import "AFRow_Private.h"
#import "AFTextFieldConfig.h"

#import "AFResourceManager.h"

NSString *const kAFTextFieldCollectionViewCellIdentifier = @"AFTextFieldCollectionViewCellIdentifier";

@interface AFTextFieldCollectionViewCell()<AFRowOutput,UITextFieldDelegate,AFTextOwner>

@property (nonatomic, strong) UIView<AFTextField> *userTextField;

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIView *underlineView;
@property (nonatomic, strong) UIView<AFAutocompleteView> *autocompleteView;

@property (nonatomic, strong) NSLayoutConstraint *underlinViewBottomConstraint;

@end

@implementation AFTextFieldCollectionViewCell

+ (void) load
{
    AFResourceManager *resourceManager = [AFResourceManager sharedInstance];
    [resourceManager registrateResourceClass:[AFTextFieldCollectionViewCell class] withKind:AFResourceManagerElementKind_Cell andIdentifier:kAFTextFieldCollectionViewCellIdentifier];
}

- (instancetype) init
{
    if ( ( self = [super init]) == nil )
    {
        return nil;
    }
    [self commonInit];
    return self;
}

- (void) commonInit
{
    self.contentView.clipsToBounds = YES;
    
    UITextField *textField = [UITextField new];
    textField.translatesAutoresizingMaskIntoConstraints = NO;
    textField.delegate = self;
    
    self.textField = textField;
    [self addTextField:textField];
    
    UIView *underlineView = [UIView new];
    underlineView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.underlineView = underlineView;
    [self addSubview:underlineView];
    
    [underlineView.heightAnchor constraintEqualToConstant:1].active = YES;
    [underlineView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor].active = YES;
    [self.contentView.trailingAnchor constraintEqualToAnchor:underlineView.trailingAnchor].active = YES;
    self.underlinViewBottomConstraint = [self.contentView.bottomAnchor constraintEqualToAnchor:underlineView.bottomAnchor];
    self.underlinViewBottomConstraint.active = YES;
}

#pragma mark - UICollectionViewCell override methods

- (void)prepareForReuse
{
    [super prepareForReuse];
    [self.userTextField removeFromSuperview];
    [self.autocompleteView removeFromSuperview];
}

#pragma mark - AFBaseCollectionViewCell protocol methods

- (void) configWithRow:(AFRow *)row layoutAttributes:(AFFormLayoutAttributes *)attributes
{
    self.backgroundColor = [UIColor blackColor];
    [super configWithRow:row layoutAttributes:attributes];
    row.output = self;
    
    [self setupConfigurations:(AFTextFieldConfig *)row.inputViewConfig];
}

- (void) setupConfigurations:(AFTextFieldConfig *)config
{
    UITextField *textField = self.textField;
    if (config.textFieldClass)
    {
        [textField removeFromSuperview];
        [self addUserTextFieldWithConfig:config];
        return;
    }
    self.backgroundColor = config.backgroundColor;
    self.underlineView.hidden = config.borderStyle != AFTextFieldBorderUnderline;
    self.underlineView.backgroundColor = config.borderColor;
    
    textField.textColor = config.textColor;
    textField.font = config.font;
    textField.layer.borderColor = config.borderColor.CGColor;
    textField.borderStyle = config.borderStyle == AFTextFieldBorderUnderline ?
                                                  UITextBorderStyleNone : (UITextBorderStyle)config.borderStyle;
    textField.keyboardType = config.keyboardKeyType;
    textField.returnKeyType = config.returnKeyType;
    textField.placeholder = config.placeholder;
    
    if (config.haveAutocomplete)
    {
        [self addAutocompleteViewWithConfig:config];
    }
}

#pragma mark - UITextFieldDelegate protocol methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [[self getVerifier] willBeginEditingText];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [[self getVerifier] didBeginEditingText];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [[self getVerifier] willEndEditingText];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [[self getVerifier] didBeginEditingText];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return [[self getVerifier] text:self shouldChangeCharactersInRange:range replacementString:string];
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

#pragma mark - ZFRowOutput protocol methods

- (void) didUpdateRowValue
{
    
}

#pragma mark - AFTextOwner protocol methods

- (void)setOwnerText:(NSString *)text
{
    if (self.textField)
    {
        self.textField.text = text;
    }
    
    [self.userTextField setText:text];
}

- (NSString *)getOwnerText
{
    if (self.textField)
    {
        return self.textField.text;
    }
    
    return self.userTextField.getText;
}

#pragma mark - utils methods

- (void) addUserTextFieldWithConfig:(AFTextFieldConfig *)config
{
    UIView<AFTextField> *view = [config.textFieldClass textFieldWithConfig:config andSetDelegate:self];
    
    if (![view isKindOfClass:[UIView class]])
    {
        NSLog(@"%@: [WARNING] Failed add user text field, because he not inherited uiview class \n",NSStringFromClass(self.class));
        return;
    }
    
    self.userTextField = view;
    [self addTextField:view];
}

- (void) addTextField:(UIView *)view
{
    [self.contentView addSubview:view];
    
    [view.topAnchor constraintEqualToAnchor:self.contentView.topAnchor].active = YES;
    [view.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor].active = YES;
    [self.contentView.trailingAnchor constraintEqualToAnchor:view.trailingAnchor].active = YES;
    [self.contentView.bottomAnchor constraintEqualToAnchor:view.bottomAnchor constant:1].active = YES;
}

- (void) addAutocompleteViewWithConfig:(AFTextFieldConfig *)config
{
    UIView<AFAutocompleteView> *autocompleteView = [config.autocompleteViewClass automcompleteView];
    autocompleteView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.contentView addSubview:autocompleteView];
    [self.contentView removeConstraint:self.underlinViewBottomConstraint];
    
    [self.underlineView.bottomAnchor constraintEqualToAnchor:autocompleteView.topAnchor].active = YES;
    [autocompleteView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor].active = YES;
    [self.contentView.trailingAnchor constraintEqualToAnchor:autocompleteView.trailingAnchor].active = YES;
    [self.contentView.bottomAnchor constraintEqualToAnchor:autocompleteView.bottomAnchor].active = YES;
}

- (AFTextFieldConfig *) getConfig
{
    return (AFTextFieldConfig *)self.row.inputViewConfig;
}

- (id<AFTextVerifier>) getVerifier
{
    AFTextFieldConfig *config = [self getConfig];
    return config.verifier;
}

@end
