//
//  AFBaseCollectionViewCell.m
//  AForm
//
//  Created by Administrator on 12/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import "AFBaseCollectionViewCell.h"

#import "AFCollectionViewFlowLayout.h"
#import "AFFormLayoutAttributes.h"

#import "AFRow_Private.h"
#import "AFBaseCellConfig_Private.h"

@interface AFBaseCollectionViewCell()<UICollectionViewDataSource,
                                      UICollectionViewDelegate,
                                      AFCollectionViewFlowLayoutDelegate,
                                      AFRowOutput>

@property (nonatomic, strong) NSLayoutConstraint *contentViewTop;
@property (nonatomic, strong) NSLayoutConstraint *contentViewBottom;
@property (nonatomic, strong) NSLayoutConstraint *contentViewLeading;
@property (nonatomic, strong) NSLayoutConstraint *contentViewTrailing;
@property (nonatomic, strong) NSLayoutConstraint *contentViewHeight;

@property (nonatomic, strong) UIView *_contentView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, weak) AFCollectionViewFlowLayout *flowLayout;

@property (nonatomic, weak) AFRow *inputRow;

@end

@implementation AFBaseCollectionViewCell

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
   // [self ]
    return self;
}

- (void) initialize
{
    [self addInputContentView];
    [self addCollectionView];
}

- (void) addInputContentView
{
    UIView *contentView = [UIView new];
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    self._contentView = contentView;
    [self addSubview:contentView];
    
    self.contentViewTop = [contentView.topAnchor constraintEqualToAnchor:self.topAnchor];
    self.contentViewLeading = [contentView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor];
    self.contentViewTrailing = [self.trailingAnchor constraintEqualToAnchor:contentView.trailingAnchor];
    self.contentViewHeight = [__contentView.heightAnchor constraintEqualToConstant:0];
    
    [NSLayoutConstraint activateConstraints:@[_contentViewTop,_contentViewLeading,_contentViewTrailing]];
}

- (void) addCollectionView
{
    AFCollectionViewFlowLayout *flowLayout = [AFCollectionViewFlowLayout new];
    flowLayout.delegate = self;
    
    UICollectionView *collectionView = [UICollectionView new];
    collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.scrollEnabled = NO;
    collectionView.collectionViewLayout = flowLayout;

    self.collectionView = collectionView;
    self.flowLayout = (AFCollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    [self addSubview:collectionView];

    [collectionView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
    [self.trailingAnchor constraintEqualToAnchor:collectionView.trailingAnchor].active = YES;
    [self.bottomAnchor constraintEqualToAnchor:collectionView.bottomAnchor].active = YES;
}

#pragma mark - UICollectionViewCell methods

- (void) applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    CGFloat height = CGRectGetHeight(layoutAttributes.frame);
    self.contentViewHeight.constant = height;
    self.contentViewHeight.active = YES;
}

- (UIView *)contentView
{
    return __contentView;
}

#pragma mark - Public API methods

- (void) configWithRow:(id<AFCellRow>)row layoutAttributes:(AFFormLayoutAttributes *)attributes
{
    self.cellRow = row;
    self.inputRow = row;
    self.inputRow.output = self;
    self.layoutAttributes = attributes;
}

- (void)setRowValue:(id)value
{
    self.inputRow.value = value;
}

#pragma mark - AFRowOutput protocol methods

- (void)didChangeRowValue
{
    [self updateRowValue];
    [self showDependenciesIfNeeded];
}

#pragma mark - UICollectionViewDataSource protocol methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    AFBaseCellConfig *cellConfig = (AFBaseCellConfig *)self.cellRow.config;
    return cellConfig.dependeciesCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    id<AFCellConfig> inputViewConig = self.cellRow.config;
    
    UICollectionViewCell<AFCollectionViewCell> *cell = [collectionView dequeueReusableCellWithReuseIdentifier:inputViewConig.identifier forIndexPath:indexPath];
    cell.output = self.output;
    
    AFFormLayoutAttributes *formAttribute = [self.flowLayout getFormLayoutAttributesAtIndexPath:indexPath];
    [cell configWithRow:self.cellRow layoutAttributes:formAttribute];
    
    return cell;
}

#pragma mark - AFCollectionViewFlowLayoutDelegate protocol methods

- (AFLayoutConfig *) layoutConfigForHeaderAtSection:(NSUInteger)section
{
    return nil;
}

- (AFLayoutConfig *)layoutConfigForItemAtIndexPath:(NSIndexPath *)indexPath
{
    id<AFCellRow> row = self.cellRow;
    AFBaseCellConfig *cellConfig = row.config;
    
    NSPredicate *predicate = [cellConfig dependencyPredicateAtIndex:indexPath.row];
    AFBaseCellConfig *config = [cellConfig dependencyConfigAtIndex:indexPath.row];
    
    if (!predicate || !config)
    {
        return nil;
    }
    
    id value = row.cellValue ? (id)row.cellValue : @1;
    
    BOOL shouldShow = [predicate evaluateWithObject:value];
    
    if (!shouldShow)
    {
        return nil;
    }
    
    return config.layoutConfig;
}

#pragma mark - utils methods

- (void) showDependenciesIfNeeded
{
    AFRow *row = self.inputRow;
    
    __block CGFloat height = 0;
    
    __weak typeof(self) weakSelf = self;
    [self.inputRow.config enumerateDependenciesWithBlock:^(AFBaseCellConfig *config, NSPredicate *predicate, NSInteger index) {
        __strong typeof(weakSelf) blockSelf = weakSelf;
        
        if (!blockSelf)
        {
            return;
        }
        
        id value = row.cellValue ? (id)row.cellValue : @1;
        BOOL shouldShow = [predicate evaluateWithObject:value];
        CGSize size = CGSizeZero;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        AFFormLayoutAttributes *formLayoutAttribute = [blockSelf.flowLayout getFormLayoutAttributesAtIndexPath:indexPath];
        
        if (shouldShow)
        {
            size = [blockSelf.flowLayout sizeForLayoutConfig:config.layoutConfig];
            height += size.height;
        } else {
            size = CGSizeZero;
            height -= formLayoutAttribute.initionalSize.height;
        }
        
        [blockSelf.flowLayout invalidateLayout:formLayoutAttribute withNewSize:size];

    }];
    
    CGSize size = self.frame.size;
    [self.layoutAttributes invalidateFlowLayoutWithNewHeight:size.height + height];
}



@end
//
//
//- (void) addStackView
//{
//    UIStackView *stackView = [UIStackView new];
//    stackView.backgroundColor = [UIColor clearColor];
//    stackView.translatesAutoresizingMaskIntoConstraints = NO;
//    stackView.axis = UILayoutConstraintAxisVertical;
//    stackView.distribution = UIStackViewDistributionFill;
//    stackView.alignment = UIStackViewAlignmentLeading;
//
//    self.stackView = stackView;
//    [self addSubview:stackView];
//
//    self.contentViewBottom = [stackView.topAnchor constraintEqualToAnchor:__contentView.bottomAnchor];
//    self.contentViewBottom.active = YES;
//}
