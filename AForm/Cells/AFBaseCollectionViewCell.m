//
//  AFBaseCollectionViewCell.m
//  AForm
//
//  Created by Administrator on 12/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import "AFBaseCollectionViewCell_Private.h"

#import "AFCollectionViewFlowLayout.h"
#import "AFFormLayoutAttributes.h"

#import "AFRow_Private.h"

#import "AFCacheManager.h"
#import "AFResourceManager_Private.h"

#import "NSObject+AFUtils.h"

@interface AFBaseCollectionViewCell()<AFRowOutput>

@property (nonatomic, strong) NSLayoutConstraint *contentViewTop;
@property (nonatomic, strong) NSLayoutConstraint *contentViewBottom;
@property (nonatomic, strong) NSLayoutConstraint *contentViewLeading;
@property (nonatomic, strong) NSLayoutConstraint *contentViewTrailing;

@property (nonatomic, strong) UIView *_contentView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, weak) AFCollectionViewFlowLayout *flowLayout;

@property (nonatomic, weak) AFRow *inputRow;
@property (nonatomic, weak) id<AFCellConfig>config;


@end

@implementation AFBaseCollectionViewCell

@synthesize layoutAttributes = _layoutAttributes;
@dynamic output;

#pragma mark - init methods

- (instancetype) init
{
    if ( ( self = [super init]) == nil )
    {
        return nil;
    }
    [self initialize];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( (self = [super initWithFrame:frame]) == nil )
    {
        return nil;
    }
    [self initialize];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    if ( (self = [super initWithCoder:coder]) == nil )
    {
        return nil;
    }
    [self initialize];
    return self;
}

- (void) initialize
{
    [self addInputContentView];
}

- (void) addInputContentView
{
    UIView *contentView = [UIView new];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    __contentView = contentView;
    [self addSubview:contentView];
    
    self.contentViewTop = [contentView.topAnchor constraintEqualToAnchor:self.topAnchor];
    self.contentViewLeading = [contentView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor];
    self.contentViewTrailing = [self.trailingAnchor constraintEqualToAnchor:contentView.trailingAnchor];
    self.contentViewBottom =  [self.bottomAnchor constraintEqualToAnchor:contentView.bottomAnchor];
    
    [NSLayoutConstraint activateConstraints:@[_contentViewTop,_contentViewLeading,_contentViewTrailing,_contentViewBottom]];
}

#pragma mark - UICollectionViewCell methods

- (UIView *)contentView
{
    return __contentView;
}

#pragma mark - Public API methods

- (void) configWithRow:(id<AFCellRow>)row andConfig:(id<AFCellConfig>)config
{
    self.inputRow = [(id)row af_objectAsClass:[AFRow class]];
    self.config = config;
    self.inputRow.output = self;
}

- (void)setRowValue:(id)value
{
    self.inputRow.value = value;
}

- (void) updateRowValue
{
    NSLog(@"%@ Must be ovverided",NSStringFromClass(self.class));
}

- (void)setHeight:(CGFloat)height
{
   [self.layoutAttributes invalidateFlowLayoutWithNewHeight:height];
}

- (CGFloat)height
{
    return CGRectGetHeight(self.frame);
}

- (NSIndexPath *)indexPath
{
    return self.layoutAttributes.indexPath;
}

- (id<AFCellRow>)cellRow
{
    return [self.inputRow af_objectAsProto:@protocol(AFCellRow)];
}

#pragma mark - AFRowOutput protocol methods

- (void)didChangeRowValue
{
    [self updateRowValue];
}


@end
