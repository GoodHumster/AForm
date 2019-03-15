//
//  AFormView.m
//  AForm
//
//  Created by Administrator on 12/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import "AFormView.h"

#import "AFResourceManager_Private.h"

#import "AFCollectionViewFlowLayout.h"
#import "AFBaseCollectionViewCell.h"
#import "AFHeaderSectionView.h"

#import "AFHeaderViewConfig.h"
#import "AFInputViewConfig.h"

@interface AFormView()<UICollectionViewDelegate,UICollectionViewDataSource,AFCollectionViewFlowLayoutDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) AFCollectionViewFlowLayout *flowLayout;

@property (nonatomic, strong) id<AForm> formModel;

@end

@implementation AFormView

#pragma mark - init methods

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
    if ( ( self = [super initWithCoder:aDecoder]) == nil )
    {
        return nil;
    }
    [self commonInit];
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame
{
    if  ( ( self = [super initWithFrame:frame]) == nil )
    {
        return nil;
    }
    [self commonInit];
    return self;
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
    AFCollectionViewFlowLayout *flowLayout = [AFCollectionViewFlowLayout new];
    flowLayout.delegate = self;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    
    [self addSubview:collectionView];
    
    [collectionView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [collectionView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
    [self.trailingAnchor constraintEqualToAnchor:collectionView.trailingAnchor].active = YES;
    [self.bottomAnchor constraintEqualToAnchor:collectionView.bottomAnchor].active = YES;
    
    self.collectionView = collectionView;
    self.flowLayout = flowLayout;
    
    [self prepareCollectionView];
}

#pragma mark - Public API methods

- (void)registrateNib:(UINib *)nib withIdentifier:(NSString *)identifier
{
    AFResourceManager *resourceManager = [AFResourceManager sharedInstance];
    [resourceManager registrateResourceNib:nib withKind:AFResourceManagerElementKind_Cell andIdentifier:identifier];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:identifier];
}

- (void)registarteClass:(Class)cls withIdentifier:(NSString *)identifier
{
    AFResourceManager *resourceManager = [AFResourceManager sharedInstance];
    [resourceManager registrateResourceClass:cls withKind:AFResourceManagerElementKind_Cell andIdentifier:identifier];
    [self.collectionView registerClass:cls forCellWithReuseIdentifier:identifier];
}

- (void) presentForm:(id<AForm>)form animatable:(BOOL)animatable
{
    self.formModel = form;
    [self.collectionView reloadData];
}

#pragma mark - utils methods

- (void) prepareCollectionView
{
    AFResourceManager *resourceManager = [AFResourceManager sharedInstance];

    [resourceManager enumerateClassesByIdentiferByBlock:^(__unsafe_unretained Class cls, NSString *identifier, AFResourceManagerElementKind elementKind) {
        
        if (elementKind == AFResourceManagerElementKind_Header)
        {
            [self.collectionView registerClass:cls forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identifier];
            return;
        }
        
        [self.collectionView registerClass:cls forCellWithReuseIdentifier:identifier];
    }];
    
    [resourceManager enumerateNibsByIdentifierByBlock:^(UINib *nib, NSString *identifier,AFResourceManagerElementKind elementKind) {
        
        if (elementKind == AFResourceManagerElementKind_Header)
        {
            [self.collectionView registerNib:nib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identifier];
            return;
        }
        
        [self.collectionView registerNib:nib forCellWithReuseIdentifier:identifier];
    }];
}

#pragma mark - AFCollectionViewFlowLayoutDelegate protocol methods

- (AFLayoutConfig *) layoutConfigForHeaderAtSection:(NSUInteger)section
{
    AFSection *sc = [self.formModel getSection:section];
    
    if (!sc)
    {
        return nil;
    }
    
    return sc.layoutConfig;
}

- (AFLayoutConfig *)layoutConfigForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AFRow *row = [self.formModel getRowAtIndex:indexPath.row inSection:indexPath.section];
    
    if (!row)
    {
        return nil;
    }
    
    return row.layoutConfig;
}

#pragma mark - UICollectionViewDelegate protocol methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{}

#pragma mark - UICollectionViewDataSource protocol methods

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionFooter])
    {
        return nil;
    }
    
    AFSection *section = [self.formModel getSection:indexPath.section];
    UICollectionReusableView<AFHeaderSectionView> *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:section.headerConfig.identifier forIndexPath:indexPath];
    [headerView configWithSection:section];

    return headerView;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AFRow *row = [self.formModel getRowAtIndex:indexPath.row inSection:indexPath.section];
    id<AFInputViewConfig> inputViewConig = row.inputViewConfig;
    
    UICollectionViewCell<AFCollectionViewCell> *cell = [collectionView dequeueReusableCellWithReuseIdentifier:inputViewConig.identifier forIndexPath:indexPath];
    
    AFFormLayoutAttributes *formAttribute = [self.flowLayout getFormLayoutAttributesAtIndexPath:indexPath];
    [cell configWithRow:row layoutAttributes:formAttribute];
    
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.formModel numberOfSections];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.formModel numberOfRowsInSection:section];
}

@end
