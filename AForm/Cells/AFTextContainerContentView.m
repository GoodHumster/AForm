//
//  AFTextInputContentView.m
//  AForm
//
//  Created by Administrator on 25/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import "AFTextInputContentView.h"

@interface AFTextInputContentView()

@property (nonatomic, strong) NSLayoutConstraint *underlineViewBottomConstraint;
@property (nonatomic, strong) NSLayoutConstraint *underlineViewHeightConstraint;

@property (nonatomic, strong) NSLayoutConstraint *textContainerTop;
@property (nonatomic, strong) NSLayoutConstraint *textContainerBottom;
@property (nonatomic, strong) NSLayoutConstraint *textContainerLeading;
@property (nonatomic, strong) NSLayoutConstraint *textCintainerTrailing;

@end

@implementation AFTextInputContentView

- (instancetype) init
{
    if ( ( self = [super init]) == nil )
    {
        return nil;
    }
    [self initialize];
    return self;
}

- (void) initialize
{
    UIView *underlineView = [UIView new];
    underlineView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.underlineView = underlineView;
    [self addSubview:underlineView];
    
    [underlineView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
    [self.trailingAnchor constraintEqualToAnchor:underlineView.trailingAnchor].active = YES;
    self.underlineViewBottomConstraint = [self.bottomAnchor constraintEqualToAnchor:underlineView.bottomAnchor];
    self.underlineViewHeightConstraint = [underlineView.heightAnchor constraintEqualToConstant:1];
    
    [NSLayoutConstraint activateConstraints:@[self.underlineViewBottomConstraint,self.underlineViewHeightConstraint]];
}

#pragma mark - Public API methods

- (void)addTextContainer:(UIView *)view
{
    [self addSubview:view];
    
    self.textContainerTop = [view.topAnchor constraintEqualToAnchor:self.topAnchor];
    self.textContainerLeading = [view.leadingAnchor constraintEqualToAnchor:self.leadingAnchor];
    self.textCintainerTrailing = [self.trailingAnchor constraintEqualToAnchor:view.trailingAnchor];
    self.textContainerBottom = [self.bottomAnchor constraintEqualToAnchor:view.bottomAnchor constant:1];
    
    [NSLayoutConstraint activateConstraints: @[_textContainerTop,
                                               _textContainerBottom,
                                               _textContainerLeading,
                                               _textCintainerTrailing] ];
    
 //   [self bringSubviewToFront:self.underlineView];
}

- (void)addAutocomopleteView:(UIView *)view
{
    [self addSubview:view];
    [self removeConstraint:self.underlineViewBottomConstraint];
    
    [self.underlineView.bottomAnchor constraintEqualToAnchor:view.topAnchor].active = YES;
    [view.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
    [self.trailingAnchor constraintEqualToAnchor:view.trailingAnchor].active = YES;
    [self.bottomAnchor constraintEqualToAnchor:view.bottomAnchor].active = YES;
}

- (void)setUnderlineViewHeight:(CGFloat)underlineViewHeight
{
    _underlineViewHeight = underlineViewHeight;
    self.underlineViewHeightConstraint.constant = underlineViewHeight;
}

- (void)setTextContainerInsets:(UIEdgeInsets)textContainerInsets
{
    _textContainerInsets = textContainerInsets;
    self.textContainerTop.constant += textContainerInsets.top;
    self.textContainerBottom.constant += textContainerInsets.bottom;
    self.textContainerLeading.constant += textContainerInsets.left;
    self.textCintainerTrailing.constant += textContainerInsets.right;
    
}

@end
