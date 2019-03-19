//
//  AFTextFieldCollectionViewCell.m
//  AForm
//
//  Created by Administrator on 12/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import "AFTextFieldCollectionViewCell.h"

#import "AFFormLayoutAttributes.h"

#import "AFRow_Private.h"
#import "AFTextFieldConfig.h"

#import "AFCacheManager.h"
#import "AFResourceManager.h"

NSString *const kAFTextFieldCollectionViewCellIdentifier = @"AFTextFieldCollectionViewCellIdentifier";

@interface AFTextFieldCollectionViewCell()< AFRowOutput,
                                            UITextFieldDelegate,
                                            AFTextOwner,
                                            AFAutocompleteViewDelegate,
                                            AFTextFieldInputViewOutput >

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIView<AFAutocompleteView> *autocompleteView;

@property (nonatomic, strong) NSLayoutConstraint *underlinViewBottomConstraint;

@property (nonatomic, assign) BOOL canEditing;
@property (nonatomic, assign) CGFloat autocompleteHeight;

@end

@implementation AFTextFieldCollectionViewCell

@synthesize output = _output;

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
    self.canEditing = YES;
    self.autocompleteHeight = 0;
    [self commonInit];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( (self = [super initWithFrame:frame]) == nil )
    {
        return nil;
    }
    [self commonInit];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    if ( (self = [super initWithCoder:coder]) == nil )
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
    self.textField.text = nil;
    self.textField.inputView = nil;
    
    if ([self getConfig].textFieldClass)
    {
        [self.textField removeFromSuperview];
    }
    [self.autocompleteView removeFromSuperview];
}

#pragma mark - Public API methods

- (BOOL)haveAutocomplete
{
    return [self getConfig].haveAutocomplete;
}

#pragma mark - AFBaseCollectionViewCell protocol methods

- (void) configWithRow:(AFRow *)row layoutAttributes:(AFFormLayoutAttributes *)attributes
{
    self.backgroundColor = [UIColor blackColor];
    [super configWithRow:row layoutAttributes:attributes];
    row.output = self;
    
    [self setupConfigurations:(AFTextFieldConfig *)row.inputViewConfig];
    self.textField.text = self.row.value;
}

#pragma mark - UIResponder methods

- (void)reloadInputViews
{
    [super reloadInputViews];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL) becomeFirstResponder
{
    BOOL becomeFR = [self.textField becomeFirstResponder];
    
    if (becomeFR)
    {
        [self.output textFieldDidBecomFirstResponder:self];
    }
    
    return becomeFR;
}

- (BOOL)resignFirstResponder
{
    BOOL resignFR = [self.textField resignFirstResponder];
    
    if (resignFR)
    {
        [self.output textFieldDidResignFirstResponder:self];
        [self hideAutocompleteView];
    }
    
    return resignFR;
}

- (BOOL)canResignFirstResponder
{
    return YES;
}

#pragma mark - UITextFieldDelegate protocol methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    AFTextFieldConfig *config = [self getConfig];
    Class<AFTextFieldInputView> inputViewClass = config.inputViewConfig.inputViewClass;
    AFCacheManager *cacheManager = [AFCacheManager sharedInstance];
    
    if (!inputViewClass)
    {
        return YES;
    }
    
    UIView<AFTextFieldInputView> *inputView = ( UIView<AFTextFieldInputView> *)[cacheManager cachedViewForClass:inputViewClass];
    inputView.output = self;
    [inputView prepareWithConfiguration:[self getConfig].inputViewConfig];
    
    self.textField.inputView = inputView;

    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    BOOL isValid = [[self getVerifier] isValidText:textField.text];
    [self textFieldChanageState:isValid];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL shouldChange = [[self getVerifier] text:self shouldChangeCharactersInRange:range replacementString:string];
    
    if (shouldChange)
    {
        NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
      
        [self.output textFieldCell:self didChangeValue:text inRow:self.row];
        [self textFieldShowAutocompleteIfNeeded];
    }
    
    return shouldChange;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [self.output textFieldDidPressReturnKey:self];
    return YES;
}

#pragma mark - AFAutocompleteViewDelegate protocol methods

- (void)formAutocompleteSetHeight:(CGFloat)height
{
    CGFloat parentHeight = CGRectGetHeight(self.frame);
    
    if (self.autocompleteHeight > 0)
    {
        parentHeight -= self.autocompleteHeight;
    }
    
    self.autocompleteHeight = height;
    [self.layoutAttributes invalidateFlowLayoutWithNewHeight:parentHeight+height];
}

- (void)formAutocompleteHide
{
    [self hideAutocompleteView];
}

- (void)formAutocompleteDidSelectValue:(NSString *)value
{
    self.textField.text = value;
    [self.output textFieldCell:self didChangeValue:value inRow:self.row];
}

#pragma mark - AFTextFieldInputViewOutput protocol methods

- (void)inputViewDidChangeValue:(NSString *)value
{
    self.textField.text = value;
}

#pragma mark - AFRowOutput protocol methods

- (void) didUpdateRowValue
{
    self.textField.text = self.row.value;
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

- (void) setupConfigurations:(AFTextFieldConfig *)config
{
    self.backgroundColor = config.backgroundColor;
    self.underlineView.hidden = config.borderStyle != AFTextFieldBorderUnderline;
    self.underlineView.backgroundColor = config.borderColor;
    
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
    
    [self addAutocompleteViewWithConfig:config];
    [self addInputViewFromConfig:config];
}

- (void) setupTextFieldWithConfig:(AFTextFieldConfig *)config
{
    UITextField *textField = self.textField;
    
    textField.textColor = config.textColor;
    textField.font = config.font;
    textField.layer.borderColor = config.borderColor.CGColor;
    textField.borderStyle = config.borderStyle == AFTextFieldBorderUnderline ?
    UITextBorderStyleNone : (UITextBorderStyle)config.borderStyle;
    textField.keyboardType = config.keyboardKeyType;
    textField.returnKeyType = config.returnKeyType;
    textField.placeholder = config.placeholder;
}

- (void) addUserTextFieldWithConfig:(AFTextFieldConfig *)config
{
    UITextField<AFTextField> *view = [config.textFieldClass textFieldWithConfig:config andSetDelegate:self];
    
    if (![view isKindOfClass:[UIView class]])
    {
        NSLog(@"%@: [WARNING] Failed add user text field, because he not inherited uiview class \n",NSStringFromClass(self.class));
        return;
    }
    
    view.parentCell = self;
    self.textField = view;
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
    if (!config.haveAutocomplete)
    {
        return;
    }
    
    UIView<AFAutocompleteView> *autocompleteView = [config.autocompleteViewClass autocompleteViewWithDelegate:self];
    autocompleteView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.contentView addSubview:autocompleteView];
    [self.contentView removeConstraint:self.underlinViewBottomConstraint];
    
    [self.underlineView.bottomAnchor constraintEqualToAnchor:autocompleteView.topAnchor].active = YES;
    [autocompleteView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor].active = YES;
    [self.contentView.trailingAnchor constraintEqualToAnchor:autocompleteView.trailingAnchor].active = YES;
    [self.contentView.bottomAnchor constraintEqualToAnchor:autocompleteView.bottomAnchor].active = YES;
}

- (void) addInputViewFromConfig:(AFTextFieldConfig *)config
{
    Class<AFTextFieldInputView> inputViewClass = config.inputViewConfig.inputViewClass;
    AFCacheManager *cacheManager = [AFCacheManager sharedInstance];
    
    if (!inputViewClass)
    {
        return;
    }
    
    UIView<AFTextFieldInputView> *inputView = (UIView<AFTextFieldInputView> *)[cacheManager cachedViewForClass:inputViewClass];
    
    if (!inputView)
    {
        inputView = [inputViewClass inputView];
        [cacheManager cacheView:inputView forClass:inputViewClass];
    }
    
    inputView.output = self;
    [inputView prepareWithConfiguration:config.inputViewConfig];
    self.textField.inputView = inputView;
}

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

- (void) textFieldShowAutocompleteIfNeeded
{
    if (![self getConfig].haveAutocomplete)
    {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    [self.output textFieldCell:self shouldShowAutocomplete:self.autocompleteView withControllBlock:^(BOOL show) {
        __strong typeof(weakSelf) blockSelf = weakSelf;
        
        if (!blockSelf)
        {
            return;
        }
        
        if (show)
        {
            [blockSelf showAutocompleteView];
        } else {
            [blockSelf hideAutocompleteView];
        }
    }];
}

- (void) showAutocompleteView
{
    CGFloat height = [self.autocompleteView preferredAutocompleteViewHeight];
    
    if (height <= 0 || self.autocompleteHeight > 0)
    {
        return;
    }
    
    self.autocompleteHeight = height;
    CGFloat parentHeight = CGRectGetHeight(self.frame);
    [self.layoutAttributes invalidateFlowLayoutWithNewHeight:parentHeight+height];
}

- (void) hideAutocompleteView
{
    if (self.autocompleteHeight <= 0)
    {
        return;
    }
    
    CGFloat parentHeight = CGRectGetHeight(self.frame);
    [self.layoutAttributes invalidateFlowLayoutWithNewHeight:parentHeight-self.autocompleteHeight];
    self.autocompleteHeight = 0;
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

- (BOOL) isUsedCustomTextField
{
    return [self getConfig].textFieldClass != nil;
}

@end
