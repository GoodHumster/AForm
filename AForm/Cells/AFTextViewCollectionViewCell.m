//
//  AFTextViewCollectionViewCell.m
//  AForm
//
//  Created by Administrator on 25/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import "AFTextViewCollectionViewCell.h"
#import "AFBaseTextContainerCollectionViewCell_Private.h"

#import "AFTextContainerContentView.h"

#import "AFCacheManager.h"
#import "AFResourceManager.h"

#import "NSString+AFValue.h"

NSString *const kAFTextViewCollectionViewCellIdentifier = @"AFTextViewCollectionViewCellIdentifier";

@interface AFTextViewCollectionViewCell()<UITextViewDelegate,
                                            AFTextOwner,
                                            AFTextFieldCellInputViewOutput>

@property (nonatomic, strong) UITextView *textView;

@end

@implementation AFTextViewCollectionViewCell

@dynamic config;

+ (void) load
{
    AFResourceManager *resourceManager = [AFResourceManager sharedInstance];
    [resourceManager registrateResourceClass:[AFTextViewCollectionViewCell class] withKind:AFResourceManagerElementKind_Cell andIdentifier:kAFTextViewCollectionViewCellIdentifier];
}

#pragma mark - UICollectionViewCell override methods

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.textView.text = nil;
    self.textView.inputView = nil;
    
    if (self.config.textViewClass)
    {
        [self.textView removeFromSuperview];
    }
}

#pragma mark - AFBaseTextContainerCollectionViewCell methods

- (void) initialize
{
    [super initialize];
    [self addTextView];
}

- (void)setNewValue:(id<AFValue>)value
{
    self.textView.text = [value getStringValue];
}

#pragma mark - AFCollectionViewCell protocol methods

- (void)configWithRow:(id<AFCellRow>)row andConfig:(AFBaseCellConfig *)config layoutAttributes:(AFFormLayoutAttributes *)attributes
{
    [self setupConfiguration:(AFTextViewCellConfig *)config];
    [super configWithRow:row andConfig:config layoutAttributes:attributes];
    
    self.textView.text = [self.cellRow.cellValue getStringValue];
}

#pragma mark - config methods

- (void) setupConfiguration:(AFTextViewCellConfig *)config;
{
    if (config.textViewClass)
    {
        [self.textView removeFromSuperview];
        [self addCustomTextViewFromConfig:config];
    }
    else
    {
        UITextView *textView = self.textView;
        
        textView.textColor = config.textColor;
        textView.font = config.font;
        textView.layer.borderColor = config.borderColor.CGColor;
        textView.keyboardType = config.keyboardKeyType;
        textView.returnKeyType = config.returnKeyType;
    }
    
    [self addInputViewFromConfig:config];
}

#pragma mark - view build methods

- (void) addTextView
{
    UITextView *textView = [[UITextView alloc] init];
    textView.translatesAutoresizingMaskIntoConstraints = NO;
    textView.backgroundColor = [UIColor clearColor];
    textView.delegate = self;
    
    self.textView = textView;
    [self addTextContainer:textView];
}

- (void) addCustomTextViewFromConfig:(AFTextViewCellConfig *)config
{
    UITextView<AFTextView> *view = [config.textViewClass textFieldWithConfig:config andSetDelegate:self];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    if (![view isKindOfClass:[UITextView class]])
    {
        NSLog(@"%@: [WARNING] Failed add user text field, because he not inherited uiview class \n",NSStringFromClass(self.class));
        return;
    }
    
    self.textView = view;
    [self addTextContainer:view];
}

- (void) addInputViewFromConfig:(AFTextViewCellConfig *)config
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
    self.textView.inputView = inputView;
}

#pragma mark - AFTextFieldCellInputViewOutput protocol methods

- (void)inputViewDidChangeValue:(id<AFValue>)value
{
    self.textView.text = [value getStringValue];
    [self setRowValue:value];
}

#pragma mark - AFTextOwner protocol methods

- (void)setOwnerText:(NSString *)text
{
    self.textView.text = text;
}

- (NSString *)getOwnerText
{
    return self.textView.text;
}

#pragma mark - UITextViewDelegate protocol methods

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    AFTextViewCellConfig *config = self.config;
    Class<AFTextFieldCellInputView> inputViewClass = config.inputViewConfig.inputViewClass;
    AFCacheManager *cacheManager = [AFCacheManager sharedInstance];
    
    if (!inputViewClass)
    {
        return YES;
    }
    
    UIView<AFTextFieldCellInputView> *inputView = ( UIView<AFTextFieldCellInputView> *)[cacheManager cachedViewForClass:inputViewClass];
    inputView.output = self;
    [inputView prepareWithConfiguration:self.config.inputViewConfig];
    
    self.textView.inputView = inputView;
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [self.output textContainerCellDidBeginEditing:self];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
     [self.output textContainerCellDidEndEditing:self];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    BOOL shouldChange = [[self getVerifier] text:self shouldChangeCharactersInRange:range replacementString:text];
    
    if (shouldChange)
    {
        NSString *value = [textView.text stringByReplacingCharactersInRange:range withString:text];
        
        [self setRowValue:value];
        [self showAutocompleteViewIfNeeded];
    }
    
    return shouldChange;
}

#pragma mark - get methods

- (id<AFTextVerifier>) getVerifier
{
    AFTextViewCellConfig *config = self.config;
    return config.verifier;
}

- (BOOL) isUsedCustomTextField
{
    return self.config.textViewClass != nil;
}

@end
