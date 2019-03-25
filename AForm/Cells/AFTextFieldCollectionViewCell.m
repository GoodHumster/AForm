//
//  AFTextFieldCollectionViewCell.m
//  AForm
//
//  Created by Administrator on 12/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import "AFTextFieldCollectionViewCell.h"

#import "AFCacheManager.h"
#import "AFResourceManager.h"

#import "AFFormLayoutAttributes.h"
#import "AFTextFieldCellConfig.h"

#import "NSString+AFValue.h"

NSString *const kAFTextFieldCollectionViewCellIdentifier = @"AFTextFieldCollectionViewCellIdentifier";

@interface AFTextFieldCollectionViewCell()< UITextFieldDelegate,
                                            AFTextOwner,
                                            AFAutocompleteViewDelegate,
                                            AFTextFieldCellInputViewOutput >

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIView<AFAutocompleteView> *autocompleteView;

@property (nonatomic, strong) NSLayoutConstraint *underlineViewBottomConstraint;
@property (nonatomic, strong) NSLayoutConstraint *underlineViewHeightConstraint;

@property (nonatomic, strong) NSLayoutConstraint *textFieldTopConstraint;
@property (nonatomic, strong) NSLayoutConstraint *textFieldBottomConstraint;
@property (nonatomic, strong) NSLayoutConstraint *textFieldLeadingConstraint;
@property (nonatomic, strong) NSLayoutConstraint *textFieldTrailingConstraint;

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
    [self.contentView addSubview:underlineView];
    
    [underlineView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor].active = YES;
    [self.contentView.trailingAnchor constraintEqualToAnchor:underlineView.trailingAnchor].active = YES;
    self.underlineViewBottomConstraint = [self.contentView.bottomAnchor constraintEqualToAnchor:underlineView.bottomAnchor];
    self.underlineViewHeightConstraint = [underlineView.heightAnchor constraintEqualToConstant:1];
    
    [NSLayoutConstraint activateConstraints:@[self.underlineViewBottomConstraint,self.underlineViewHeightConstraint]];
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

- (void)configWithRow:(id<AFCellRow>)row layoutAttributes:(AFFormLayoutAttributes *)attributes
{
    self.backgroundColor = [UIColor clearColor];
    [super configWithRow:row layoutAttributes:attributes];
    [self setupConfigurations:(AFTextFieldCellConfig *)row.config];
    self.textField.text = [row.cellValue getStringValue];
}

- (void) setupConfigurations:(AFTextFieldCellConfig *)config
{
    self.backgroundColor = config.backgroundColor;
    self.underlineView.hidden = config.borderStyle != AFTextFieldBorderUnderline;
    self.underlineView.backgroundColor = config.borderColor;
    self.underlineViewHeightConstraint.constant = config.borderWidth;
    
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
    
    [self.contentView bringSubviewToFront:self.underlineView];
    
    UIEdgeInsets insets = config.insets;
    self.textFieldTopConstraint.constant += insets.top;
    self.textFieldBottomConstraint.constant += insets.bottom;
    self.textFieldTrailingConstraint.constant += insets.right;
    self.textFieldLeadingConstraint.constant += insets.left;
    
    [self addAutocompleteViewWithConfig:config];
    [self addInputViewFromConfig:config];
}

- (void) setupTextFieldWithConfig:(AFTextFieldCellConfig *)config
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
    [self addTextField:view];
}


- (void) addTextField:(UIView *)view
{
    [self.contentView addSubview:view];
    
    self.textFieldTopConstraint = [view.topAnchor constraintEqualToAnchor:self.contentView.topAnchor];
    self.textFieldLeadingConstraint = [view.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor];
    self.textFieldTrailingConstraint = [self.contentView.trailingAnchor constraintEqualToAnchor:view.trailingAnchor];
    self.textFieldBottomConstraint = [self.contentView.bottomAnchor constraintEqualToAnchor:view.bottomAnchor constant:1];
    
    [NSLayoutConstraint activateConstraints:@[_textFieldTopConstraint,_textFieldBottomConstraint,_textFieldLeadingConstraint,_textFieldTrailingConstraint]];
}

- (void) addAutocompleteViewWithConfig:(AFTextFieldCellConfig *)config
{
    if (!config.haveAutocomplete)
    {
        return;
    }
    
    UIView<AFAutocompleteView> *autocompleteView = [config.autocompleteViewClass autocompleteViewWithDelegate:self];
    autocompleteView.translatesAutoresizingMaskIntoConstraints = NO;
    
    if (!autocompleteView)
    {
        return;
    }
    
    [self.contentView addSubview:autocompleteView];
    [self.contentView removeConstraint:self.underlineViewBottomConstraint];
    
    [self.underlineView.bottomAnchor constraintEqualToAnchor:autocompleteView.topAnchor].active = YES;
    [autocompleteView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor].active = YES;
    [self.contentView.trailingAnchor constraintEqualToAnchor:autocompleteView.trailingAnchor].active = YES;
    [self.contentView.bottomAnchor constraintEqualToAnchor:autocompleteView.bottomAnchor].active = YES;
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

#pragma mark - UIResponder methods

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL) becomeFirstResponder
{
    return [self.textField becomeFirstResponder];;
}

- (BOOL)resignFirstResponder
{
    BOOL resignFR = [self.textField resignFirstResponder];
    
    if (resignFR)
    {
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
    AFTextFieldCellConfig *config = [self getConfig];
    Class<AFTextFieldCellInputView> inputViewClass = config.inputViewConfig.inputViewClass;
    AFCacheManager *cacheManager = [AFCacheManager sharedInstance];
    
    if (!inputViewClass)
    {
        return YES;
    }
    
    UIView<AFTextFieldCellInputView> *inputView = ( UIView<AFTextFieldCellInputView> *)[cacheManager cachedViewForClass:inputViewClass];
    inputView.output = self;
    [inputView prepareWithConfiguration:[self getConfig].inputViewConfig];
    
    self.textField.inputView = inputView;

    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.output textFieldCellDidBeginEditing:self];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    BOOL isValid = [[self getVerifier] isValidText:textField.text];
    [self.output textFieldCellDidEndEditing:self];
    [self textFieldChanageState:isValid];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL shouldChange = [[self getVerifier] text:self shouldChangeCharactersInRange:range replacementString:string];
    
    if (shouldChange)
    {
        NSString *text = [textField.text stringByReplacingCharactersInRange:range withString:string];
      
        [self updateRowValue:text];
        [self textFieldShowAutocompleteIfNeeded];
    }
    
    return shouldChange;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [self.output textFieldCellDidPressReturnKey:self];
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

- (void)formAutocompleteDidSelectValue:(id<AFValue>)value
{
    self.textField.text = [value getStringValue];
    [self updateRowValue:value];
}

#pragma mark - AFTextFieldCellInputViewOutput protocol methods

- (void)inputViewDidChangeValue:(id<AFValue>)value
{
    self.textField.text = [value getStringValue];
    [self updateRowValue:value];
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

- (void) updateRowValue:(id)value
{
    [self setRowValue:value];
    [self.output textFieldCell:self didChangeValueinRow:self.cellRow];
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

#pragma mark - get methods

- (AFTextFieldCellConfig *) getConfig
{
    return (AFTextFieldCellConfig *)self.cellRow.config;
}

- (id<AFTextVerifier>) getVerifier
{
    AFTextFieldCellConfig *config = [self getConfig];
    return config.verifier;
}

- (BOOL) isUsedCustomTextField
{
    return [self getConfig].textFieldClass != nil;
}

@end
