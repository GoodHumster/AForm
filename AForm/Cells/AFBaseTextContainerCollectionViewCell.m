//
//  AFBaseTextContainerCollectionViewCell.m
//  AForm
//
//  Created by Administrator on 26/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import "AFBaseTextContainerCollectionViewCell_Private.h"

@interface AFBaseTextContainerCollectionViewCell()

@property (nonatomic, strong) AFTextInputContentView *textContainerContentView;
@property (nonatomic, weak) UIResponder *textContainer;

@end

@implementation AFBaseTextContainerCollectionViewCell

@synthesize config = _config;
@synthesize output = _output;

- (void) initialize
{
    [super initialize];
    [self addInputViewContentView];
}

#pragma mark - UICollectionViewCell override methods

- (void)prepareForReuse
{
    [super prepareForReuse];
    [self.textContainerContentView.autocompleteView removeFromSuperview];
}

#pragma mark - AFBaseCollectionViewCell methods

- (void)updateRowValue
{
    [self setNewValue:self.cellRow.cellValue];
}

#pragma mark - UIResponder methods

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (BOOL) becomeFirstResponder
{
    return [self.textContainer becomeFirstResponder];;
}

- (BOOL)resignFirstResponder
{
    BOOL resignFR = [self.textContainer resignFirstResponder];
    
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

#pragma mark - AFCollectionViewCell protocol methods

- (void)configWithRow:(id<AFCellRow>)row andConfig:(AFBaseCellConfig *)config layoutAttributes:(AFFormLayoutAttributes *)attributes
{
    [super configWithRow:row andConfig:config layoutAttributes:attributes];
    
    [self configView];
    [self addAutocompleteView:self.config];
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
    [self setNewValue:value];
    [self setRowValue:value];
}

#pragma mark - utils methods

- (void) configView
{
    AFBaseTextContainerCellConfig *config = self.config;
    
    self.backgroundColor = config.backgroundColor;
    self.textContainerContentView.underlineView.hidden = config.borderStyle != AFTextInputBorderUnderline;
    self.textContainerContentView.underlineView.backgroundColor = config.borderColor;
    self.textContainerContentView.underlineViewHeight = config.borderWidth;
    self.textContainerContentView.textContainerInsets = config.insets;
}

- (void) addInputViewContentView
{
    AFTextInputContentView *textContainerContentView = [AFTextInputContentView new];
    textContainerContentView.translatesAutoresizingMaskIntoConstraints = NO;
    textContainerContentView.backgroundColor = [UIColor clearColor];
    
    [self.contentView addSubview:textContainerContentView];
    self.textContainerContentView = textContainerContentView;
    
    [textContainerContentView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor].active = YES;
    [textContainerContentView.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor].active = YES;
    [self.contentView.bottomAnchor constraintEqualToAnchor:textContainerContentView.bottomAnchor].active = YES;
    [self.contentView.trailingAnchor constraintEqualToAnchor:textContainerContentView.trailingAnchor].active = YES;
}

- (void) addAutocompleteView:(AFBaseTextContainerCellConfig *)config
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
    
    [self.textContainerContentView addAutocomopleteView:autocompleteView];
}

#pragma mark - Private API methods

- (void)addTextContainer:(UIView *)textContainer
{
    [self.textContainerContentView addTextField:textContainer];
    self.textContainer = textContainer;
}

- (void)showAutocompleteViewIfNeeded
{
    if (!self.config.haveAutocomplete)
    {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    [self.output textContainerCell:self shouldShowAutocomplete:self.textContainerContentView.autocompleteView withControllBlock:^(BOOL show) {
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

- (void)setNewValue:(id<AFValue>)value
{
    NSLog(@"%@ Methods must be ovveride by the subclass",NSStringFromClass(self.class));
}

- (void)setRowValue:(id)value
{
    id<AFValue> obj = self.cellRow.cellValue;
    
    if (obj)
    {
        value = [obj objectByAppendValue:value];
    }
    
    [super setRowValue:value];
    [self.output textContainerCell:self didChangeValueAtIndexPath:self.layoutAttributes.indexPath];
}

#pragma mark - Autocomplete view manipulate

- (void) showAutocompleteView
{
    CGFloat height = [self.textContainerContentView.autocompleteView preferredAutocompleteViewHeight];
    
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


@end
