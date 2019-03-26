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

#import "AFCacheManager.h"
#import "AFResourceManager_Private.h"

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
    flowLayout.invalidateLayoutBoundsChange = NO;
   
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.scrollEnabled = NO;
    collectionView.collectionViewLayout = flowLayout;

    self.collectionView = collectionView;
    self.flowLayout = (AFCollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    [self addSubview:collectionView];
 
    [collectionView.topAnchor constraintEqualToAnchor:self.contentView.bottomAnchor].active = YES;
    [collectionView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
    [self.trailingAnchor constraintEqualToAnchor:collectionView.trailingAnchor].active = YES;
    [self.bottomAnchor constraintEqualToAnchor:collectionView.bottomAnchor].active = YES;
}

#pragma mark - UICollectionViewCell methods

- (UIView *)contentView
{
    return __contentView;
}

#pragma mark - Public API methods

- (void) configWithRow:(id<AFCellRow>)row andConfig:(AFBaseCellConfig *)config layoutAttributes:(AFFormLayoutAttributes *)attributes
{
    self.cellRow = row;
    self.config = config;
    self.inputRow = row;
    self.inputRow.output = self;
    self.layoutAttributes = attributes;
    
    self.contentViewHeight.constant = attributes.initionalSize.height;
    self.contentViewHeight.active = YES;
    
    [self registrateNeededCells];
    [self configFlowLayout];
    [self invalidateCellHeightIfNeeded];
}

- (void)setRowValue:(id)value
{
    self.inputRow.value = value;
}

- (void) updateRowValue
{}

- (void)setHeight:(CGFloat)height
{
    self.contentViewHeight.constant = height;
    [self.layoutAttributes invalidateFlowLayoutWithNewHeight:height];
}

- (CGFloat)height
{
    return self.contentViewHeight.constant;
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
    AFBaseCellConfig *cellConfig = self.config;
    return cellConfig.dependenciesCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AFBaseCellConfig *inputViewConig = [self.config dependencyConfigAtIndex:indexPath.row];
    
    UICollectionViewCell<AFCollectionViewCell> *cell = [collectionView dequeueReusableCellWithReuseIdentifier:inputViewConig.identifier forIndexPath:indexPath];
   // cell.output = self.output;
    
    AFFormLayoutAttributes *formAttribute = [self.flowLayout getFormLayoutAttributesAtIndexPath:indexPath];
    [cell configWithRow:self.cellRow andConfig:inputViewConig layoutAttributes:formAttribute];
    
    self.inputRow.output = self;
    
    return cell;
}

#pragma mark - AFCollectionViewFlowLayoutDelegate protocol methods

- (NSIndexPath *)layoutGetCurrentFocusedCellIndexPath
{
    return nil;
}

- (void)layoutDidUpdatedContentSize
{
    CGFloat contentHeight = self.contentViewHeight.constant;
    CGSize contentSize = self.flowLayout.collectionViewContentSize;
    [self.layoutAttributes invalidateFlowLayoutWithNewHeight:contentHeight + contentSize.height];
}

- (AFLayoutConfig *) layoutConfigForHeaderAtSection:(NSUInteger)section
{
    return nil;
}

- (AFLayoutConfig *)layoutConfigForItemAtIndexPath:(NSIndexPath *)indexPath
{
    id<AFCellRow> row = self.cellRow;
    AFBaseCellConfig *cellConfig = self.config;
    
    NSPredicate *predicate = [cellConfig dependencyPredicateAtIndex:indexPath.row];
    AFBaseCellConfig *config = [cellConfig dependencyConfigAtIndex:indexPath.row];
    
    if (!predicate || !config)
    {
        return nil;
    }
    
    id value = row.cellValue;
    
    BOOL shouldShow = [predicate evaluateWithObject:value];
    
    if (!shouldShow)
    {
        return nil;
    }
    
    return config.layoutConfig;
}

#pragma mark - utils methods

- (void) configFlowLayout
{
    self.flowLayout.minimumInteritemSpacing = self.config.minimumDependeciesInterItemSpacing;
    self.flowLayout.minimumLineSpacing = self.config.minimumDependeciesLineSpacing;
    self.flowLayout.prepareCollectionViewContentSize = self.frame.size;
}

- (void) registrateNeededCells
{
    [self.config enumerateDependenciesWithBlock:^(AFBaseCellConfig *config, NSPredicate *predicate, NSInteger index) {
        
        AFResourceManager *resourceManager = [AFResourceManager sharedInstance];
        NSString *identifier = config.identifier;
        Class cls = [resourceManager classForIdentifier:identifier];
        
        if (cls)
        {
            [self.collectionView registerClass:cls forCellWithReuseIdentifier:identifier];
        }
        
        UINib *nib = [resourceManager nibForIdentifier:identifier];
        
        if (nib)
        {
            [self.collectionView registerNib:nib forCellWithReuseIdentifier:identifier];
        }
    }];
}

- (void) invalidateCellHeightIfNeeded
{
    CGFloat collectionHeight = CGRectGetHeight(self.collectionView.frame);
    CGFloat dependeciesHeight = self.config.dependenciesPreapreHeight;
    
    if (collectionHeight < dependeciesHeight)
    {
        CGSize size = self.layoutAttributes.initionalSize;
        [self.layoutAttributes invalidateFlowLayoutWithNewHeight:size.height + dependeciesHeight];
    }
}

- (void) showDependenciesIfNeeded
{
    AFRow *row = self.inputRow;
    
    __block CGFloat height = 0;
    
    __weak typeof(self) weakSelf = self;
    [self.inputRow.cellConfig enumerateDependenciesWithBlock:^(AFBaseCellConfig *config, NSPredicate *predicate, NSInteger index) {
        __strong typeof(weakSelf) blockSelf = weakSelf;
        
        if (!blockSelf)
        {
            return;
        }
        
        id value = row.cellValue;
        BOOL shouldShow = [predicate evaluateWithObject:value];
        CGSize size = CGSizeZero;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        AFFormLayoutAttributes *formLayoutAttribute = [blockSelf.flowLayout getFormLayoutAttributesAtIndexPath:indexPath];
        CGSize oldSize = formLayoutAttribute.collectionLayoutAttributes.size;
        
        if (shouldShow)
        {
            size = [blockSelf.flowLayout sizeForLayoutConfig:config.layoutConfig];
            height += CGSizeEqualToSize(oldSize, size) ? 0 : size.height;
        } else {
            size = CGSizeZero;
            height -= CGRectGetHeight(formLayoutAttribute.collectionLayoutAttributes.frame);
        }
        
        [formLayoutAttribute invalidateFlowLayoutWithNewHeight:size.height];
    }];
    
    if (height != 0)
    {
        CGSize size = self.frame.size;
        [self.layoutAttributes invalidateFlowLayoutWithNewHeight:size.height + height];
    }
}



@end
