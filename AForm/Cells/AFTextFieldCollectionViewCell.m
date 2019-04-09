//
//  AFTextFieldCollectionViewCell.m
//  AForm
//
//  Created by Administrator on 12/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import "AFTextFieldCollectionViewCell.h"
#import "AFBaseTextContainerCollectionViewCell_Private.h"

#import "AFCacheManager.h"
#import "AFResourceManager.h"

#import "AFFormLayoutAttributes.h"
#import "AFTextFieldCellConfig.h"

#import "NSString+AFValue.h"

NSString *const kAFTextFieldCollectionViewCellIdentifier = @"AFTextFieldCollectionViewCellIdentifier";

@interface AFTextFieldCollectionViewCell()< UITextFieldDelegate,
                                            AFTextOwner,
                                            AFTextFieldCellInputViewOutput >

@property (nonatomic, strong) UITextField *textField;

@end

@implementation AFTextFieldCollectionViewCell

@synthesize output = _output;
@synthesize config = _config;

+ (void) load
{
    AFResourceManager *resourceManager = [AFResourceManager sharedInstance];
    [resourceManager registrateResourceClass:[AFTextFieldCollectionViewCell class] withKind:AFResourceManagerElementKind_Cell andIdentifier:kAFTextFieldCollectionViewCellIdentifier];
}

#pragma mark - AFBaseTextContainerCollectionViewCell methods

- (void) initialize
{
    [super initialize];
    
    UITextField *textField = [UITextField new];
    textField.translatesAutoresizingMaskIntoConstraints = NO;
    textField.delegate = self;
    
    self.textField = textField;
    [self addTextContainer:textField];
}

- (void)setNewValue:(id<AFValue>)value
{
    self.textField.text = [value getStringValue];
}

#pragma mark - UICollectionViewCell override methods

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.textField.text = nil;
    self.textField.inputView = nil;
    
    if (self.config.textFieldClass)
    {
        [self.textField removeFromSuperview];
    }
}

#pragma mark - Public API methods

- (BOOL)haveAutocomplete
{
    return self.config.haveAutocomplete;
}

#pragma mark - AFBaseCollectionViewCell protocol methods

- (void)configWithRow:(id<AFCellRow>)row andConfig:(id<AFCellConfig>)config
{
    [self setupConfigurations:(AFTextFieldCellConfig *)config];
    [super configWithRow:row andConfig:config];
    
    self.textField.text = [row.cellValue getStringValue];
}

- (void) setupConfigurations:(AFTextFieldCellConfig *)config
{
    self.backgroundColor = config.backgroundColor;
    UITextField *textField = self.textField;
    if (config.textFieldClass)
    {
        [textField removeFromSuperview];
        [self addUserTextFieldWithConfig:config];
    }
    else
    {
        [self setupTextFieldWithConfig:config];
    }
    
    [self addInputViewFromConfig:config];
}

- (void) setupTextFieldWithConfig:(AFTextFieldCellConfig *)config
{
    UITextField *textField = self.textField;
    
    textField.textColor = config.textColor;
    textField.font = config.font;
    textField.layer.borderColor = config.borderColor.CGColor;
    textField.borderStyle = config.borderStyle == AFTextInputBorderUnderline ?
    UITextBorderStyleNone : (UITextBorderStyle)config.borderStyle;
    textField.keyboardType = config.keyboardKeyType;
    textField.returnKeyType = config.returnKeyType;
    textField.placeholder = config.placeholder;
}

- (void) addUserTextFieldWithConfig:(AFTextFieldCellConfig *)config
{
    UITextField<AFTextField> *view = [config.textFieldClass textFieldWithConfig:config andSetDelegate:self];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    if (![view isKindOfClass:[UITextField class]])
    {
        NSLog(@"%@: [WARNING] Failed add user text field, because he not inherited uiview class \n",NSStringFromClass(self.class));
        return;
    }
    
    //view.parentCell = self;
    self.textField = view;
    [self addTextContainer:view];
}

- (void) addInputViewFromConfig:(AFTextFieldCellConfig *)config
{
    Class<AFTextFieldCellInputView> inputViewClass = config.inputViewConfig.inputViewClass;
    AFCacheManager *cacheManager = [AFCacheManager sharedInstance];
    
    if (!inputViewClass)
    {
        return;
    }
    
    UIView<AFTextFieldCellInputView> *inputView = (UIView<AFTextFieldCellInputView> *)[cacheManager cachedViewForClass:inputViewClass];
    
    if (!inputView)
    {
        inputView = [inputViewClass inputView];
        [cacheManager cacheView:inputView forClass:inputViewClass];
    }
    
    inputView.output = self;
    [inputView prepareWithConfiguration:config.inputViewConfig];
    self.textField.inputView = inputView;
}


#pragma mark - UITextFieldDelegate protocol methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    AFTextFieldCellConfig *config = self.config;
    Class<AFTextFieldCellInputView> inputViewClass = config.inputViewConfig.inputViewClass;
    AFCacheManager *cacheManager = [AFCacheManager sharedInstance];
    
    if (!inputViewClass)
    {
        return YES;
    }
    
    UIView<AFTextFieldCellInputView> *inputView = ( UIView<AFTextFieldCellInputView> *)[cacheManager cachedViewForClass:inputViewClass];
    inputView.output = self;
    [inputView prepareWithConfiguration:self.config.inputViewConfig];
    
    self.textField.inputView = inputView;

    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.output textContainerCellDidBeginEditing:self];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    BOOL isValid = [[self getVerifier] isValidText:textField.text];
    [self.output textContainerCellDidEndEditing:self];
    [self textFieldChanageState:isValid];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL shouldChange = [[self getVerifier] text:self shouldChangeCharactersInRange:range replacementString:string];
    
    if (shouldChange)
    {
        NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
      
        [self setRowValue:text];
        [self showAutocompleteViewIfNeeded];
    }
    
    return shouldChange;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [self.output textContainerCellDidPressReturnKey:self];
    return YES;
}

#pragma mark - AFTextFieldCellInputViewOutput protocol methods

- (void)inputViewDidChangeValue:(id<AFValue>)value
{
    self.textField.text = [value getStringValue];
    [self setRowValue:value];
}

#pragma mark - AFTextOwner protocol methods

- (void)setOwnerText:(NSString *)text
{
    self.textField.text = text;
}

- (NSString *)getOwnerText
{
    return self.textField.text;
}

#pragma mark - utils methods

- (void) textFieldChanageState:(BOOL)state
{
    if ([self isUsedCustomTextField])
    {
        UITextField<AFTextField> *textField = (UITextField<AFTextField> *)self.textField;
        [textField textFieldChangeTextVereficationState:state];
        return;
    }
    self.textField.tintColor = state ? [UIColor blackColor] : [UIColor redColor];
}

#pragma mark - get methods

- (id<AFTextVerifier>) getVerifier
{
    AFTextFieldCellConfig *config = self.config;
    return config.verifier;
}

- (BOOL) isUsedCustomTextField
{
    return self.config.textFieldClass != nil;
}

@end
