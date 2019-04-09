//
//  AFormCollectionViewFlowLayout.m
//  AForm
//
//  Created by Administrator on 12/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import <objc/runtime.h>

#import "AFCollectionViewFlowLayout.h"
#import "AFFormLayoutAttributes.h"
#import "AFLayoutAttributesDictionary.h"
#import "AFFormLayoutInvalidationContext.h"


#import "AFLayoutConfig.h"

typedef NS_ENUM(NSInteger, AFCollectionViewElementKind)
{
    AFCollectionViewElementKind_Header,
    AFCollectionViewElementKind_Footer,
    AFCollectionViewElementKind_Cell
};


@interface AFCollectionViewFlowLayout()

@property (nonatomic, strong) AFLayoutAttributesDictionary *cachedLayoutAttributes;

@property (nonatomic, assign) CGSize contentSize;

@end

@implementation AFCollectionViewFlowLayout

#pragma mark - init methods

- (instancetype) init
{
    if ( ( self = [super init]) == nil )
    {
        return nil;
    }
    
    _contentSize = CGSizeZero;
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.prepareCollectionViewContentSize = CGSizeZero;
    self.invalidateLayoutBoundsChange = NO;
    self.cachedLayoutAttributes = [AFLayoutAttributesDictionary new];
    return self;
}

+ (Class)layoutAttributesClass
{
    return [AFFormLayoutAttributes class];
}

 + (Class)invalidationContextClass
{
    return [AFFormLayoutInvalidationContext class];
}

#pragma mark - UICollectionViewFlowLayout methods

- (CGSize)collectionViewContentSize
{
    if (CGSizeEqualToSize(CGSizeZero, _contentSize))
    {
        return  [super collectionViewContentSize];
    }
    
    return _contentSize;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray<AFFormLayoutAttributes *> *attributes = [self.cachedLayoutAttributes getFormAttributeInRect:rect];
    AFFormLayoutAttributes *layoutAttributes = attributes.lastObject;
    
    if (attributes && [self.cachedLayoutAttributes isFilledRect:rect])
    {
        return attributes;
    }
    
    NSMutableArray<AFFormLayoutAttributes *> *mAttributes = [attributes mutableCopy];
    NSIndexPath *indexPath = layoutAttributes.indexPath;
    
    if (!mAttributes)
    {
          mAttributes = [NSMutableArray new];
    }
    
    NSArray *buildedAttributes = [self layoutAttributesBuildFromIndexPath:indexPath inRect:rect];
    [mAttributes addObjectsFromArray:buildedAttributes];

    NSArray<AFFormLayoutAttributes *> *layoutesAttibutes = [mAttributes copy];
    UICollectionViewLayoutAttributes *lastLayoutAttribute = layoutesAttibutes.lastObject;
    
    if (CGRectGetMaxY(lastLayoutAttribute.frame) > _contentSize.height)
    {
        _contentSize.height = CGRectGetMaxY(lastLayoutAttribute.frame) + self.minimumLineSpacing;
        _contentSize.width = CGRectGetWidth(self.collectionView.frame);
        
        if ([self.delegate respondsToSelector:@selector(layoutDidUpdatedContentSize)])
        {
            [self.delegate layoutDidUpdatedContentSize];
        }
    }
    
    return layoutesAttibutes;
}

- (NSArray *) layoutAttributesBuildFromIndexPath:(NSIndexPath *)indexPath inRect:(CGRect)rect
{
    AFLayoutAttributesDictionary *cachedAttributes = self.cachedLayoutAttributes;
    NSMutableArray *mAttributes = [NSMutableArray new];
    
    void (^createIfNeededAndCachedBlock) (NSIndexPath *indexPath, AFCollectionViewElementKind elementKind) = ^(NSIndexPath *indexPath, AFCollectionViewElementKind elementKind) {
        
        AFFormLayoutAttributes *attr = [self formLayoutAttributesAtIndexPath:indexPath elementKind:elementKind];
        
        if (!attr)
        {
            return;
        }
        
        [cachedAttributes cacheFormAttribute:attr];
        [mAttributes addObject:attr];
    };
    
    [self enumerateIndexPathsFromIndexPath:indexPath withBlock:^(NSIndexPath *indexPath, BOOL *stop) {
        
        if (indexPath.row == 0)
        {
            createIfNeededAndCachedBlock(indexPath,AFCollectionViewElementKind_Header);
        }
        
        createIfNeededAndCachedBlock(indexPath,AFCollectionViewElementKind_Cell);
        
        if ([cachedAttributes isFilledRect:rect])
        {
            *stop = YES;
        }
        
    }];
    
    return mAttributes;
}

- (AFFormLayoutAttributes *) formLayoutAttributesAtIndexPath:(NSIndexPath *)indexPath elementKind:(AFCollectionViewElementKind)kind
{
    AFFormLayoutAttributes *formLayoutAttributes = nil;
    NSString *elementKind = nil;
    
    switch (kind) {
        case AFCollectionViewElementKind_Header:
            elementKind = UICollectionElementKindSectionHeader;
            formLayoutAttributes = (AFFormLayoutAttributes *)[self layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPath:indexPath];
            break;
        case AFCollectionViewElementKind_Footer:
            elementKind = UICollectionElementKindSectionFooter;
            formLayoutAttributes = (AFFormLayoutAttributes *)[self layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPath:indexPath];
            break;
        case AFCollectionViewElementKind_Cell:
            formLayoutAttributes = (AFFormLayoutAttributes *)[self layoutAttributesForItemAtIndexPath:indexPath];
            break;
        default:
            break;
    }
    
    if (!formLayoutAttributes)
    {
        return nil;
    }
    
    AFFormLayoutAttributes *lastFormLayoutAttributes = [self.cachedLayoutAttributes lastFormAttribute];
    CGRect lastAttrFrame = lastFormLayoutAttributes.frame;
    
    formLayoutAttributes.uuid = lastFormLayoutAttributes.uuid+1;
    formLayoutAttributes.flowLayout = self;
    formLayoutAttributes.initionalSize = formLayoutAttributes.frame.size;
    [formLayoutAttributes setPositionAfterFrame:lastAttrFrame];
    
    return formLayoutAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    attributes.size = [self sizeForElementKind:AFCollectionViewElementKind_Cell atIndexPath:indexPath];
    
    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    AFCollectionViewElementKind element = [elementKind isEqualToString:UICollectionElementKindSectionHeader] ? AFCollectionViewElementKind_Header : AFCollectionViewElementKind_Footer;
    
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPath:indexPath];
    attributes.size = [self sizeForElementKind:element atIndexPath:indexPath];
    
    return attributes;
}

#pragma mark - Layout helpers methods

- (CGSize) sizeForElementKind:(AFCollectionViewElementKind)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    switch (elementKind) {
        case AFCollectionViewElementKind_Header:
            return [self sizeForHeaderAtIndexPath:indexPath];
            break;
        case AFCollectionViewElementKind_Cell:
            return [self sizeForCellAtIndexPath:indexPath];
        default:
            return CGSizeZero;
    }
}

- (CGSize) sizeForHeaderAtIndexPath:(NSIndexPath *)indexPath
{
    if (![self.delegate respondsToSelector:@selector(layoutConfigForHeaderAtSection:)])
    {
        return CGSizeZero;
    }
    
    UIEdgeInsets sectionInsets = [self sectionInsetsForSection:indexPath.section];
    AFLayoutConfig *config = [self.delegate layoutConfigForHeaderAtSection:indexPath.section];
    
    if (!config)
    {
        return CGSizeZero;
    }
    
    return [self sizeForLayoutConfig:config wihtSectionInsets:sectionInsets];
}

- (CGSize) sizeForCellAtIndexPath:(NSIndexPath *)indexPath
{
    if (![self.delegate respondsToSelector:@selector(layoutConfigForItemAtIndexPath:)])
    {
        return CGSizeZero;
    }
    
    UIEdgeInsets sectionInsets = [self sectionInsetsForSection:indexPath.section];
    AFLayoutConfig *config = [self.delegate layoutConfigForItemAtIndexPath:indexPath];
    
    if (!config)
    {
        return CGSizeZero;
    }
    
    return [self sizeForLayoutConfig:config wihtSectionInsets:sectionInsets];
}

- (CGSize) sizeForLayoutConfig:(AFLayoutConfig *)config wihtSectionInsets:(UIEdgeInsets)insets
{
    CGFloat parentWidth = CGRectGetWidth(self.collectionView.frame);
    CGFloat parentHeight = CGRectGetHeight(self.collectionView.frame);
    CGFloat minimumInteritemSpacing = self.minimumInteritemSpacing;
    
    AFLayoutConstraint *heightConstraint = config.height;
    AFLayoutConstraint *widthConstraint = config.width;
    
    CGFloat height = heightConstraint.constant == AFLayoutConstraintAutomaticDimension ?
    config.height.multiplie * parentHeight : config.height.constant;
    
    CGFloat width = widthConstraint.constant == AFLayoutConstraintAutomaticDimension ?
    config.width.multiplie * parentWidth : config.width.constant;
    
    CGFloat interItemMultiplie = widthConstraint.constant == AFLayoutConstraintAutomaticDimension ?
    config.width.multiplie : config.width.constant / CGRectGetWidth(self.collectionView.frame);
    
    width -= (interItemMultiplie*minimumInteritemSpacing + minimumInteritemSpacing);
    width -= (insets.left + insets.right);
    
    return CGSizeMake(width, height);
}


#pragma mark - Public API methods

- (UIEdgeInsets) sectionInsetsForSection:(NSInteger)section
{
    if (![self.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)])
    {
        return self.sectionInset;
    }
    
    return [self.delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:section];
}

- (void) invalidateLayout:(AFFormLayoutAttributes *)formLayoutAttributes withNewHeight:(CGFloat)height
{
//    CGSize size = formLayoutAttributes.size;
//    size.height = height;
//
//    [self invalidateLayout:formLayoutAttributes withNewSize:size];
}

- (void) invalidateLayout:(AFFormLayoutAttributes *)formLayoutAttributes withNewSize:(CGSize)size
{
//    __block CGRect prevFrame = CGRectZero;
//
//    prevFrame = formLayoutAttributes.frame;
//    prevFrame.size = size;
//    formLayoutAttributes.frame = prevFrame;
//
//    NSMutableArray *replacedAttributes = [NSMutableArray new];
//    [replacedAttributes addObject:formLayoutAttributes];
//    [self.cachedLayoutAttributes enumerateFormAttributeStartFrom:formLayoutAttributes.uuid wihtBlock:^(AFFormLayoutAttributes *formLayoutAttributes) {
//
//        [formLayoutAttributes setPositionAfterFrame:prevFrame];
//       // [self invalidateLayout:formLayoutAttributes fromRect:prevFrame];
//        prevFrame = formLayoutAttributes.frame;
//
//        [replacedAttributes addObject:formLayoutAttributes];
//    }];
//
//    [self.cachedLayoutAttributes replaceFormAttributes:[replacedAttributes copy]];
//
//    [UIView animateWithDuration:0.4 animations:^{
//        [self scrollToFormAttribute:formLayoutAttributes];
//        [self invalidateLayout];
//    }];
}

- (AFFormLayoutAttributes *) getFormLayoutAttributesAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.cachedLayoutAttributes getFormAttributeByIndexPath:indexPath];
}

#pragma mark - utils methods

- (void) enumerateIndexPathsFromIndexPath:(NSIndexPath *)indexPath withBlock:(void(^)(NSIndexPath *indexPath, BOOL *stop))enumerationBlock
{
    NSInteger sectionCounts = [self.collectionView numberOfSections];
    NSInteger section = indexPath ? indexPath.section : 0;
    NSInteger row = indexPath ? indexPath.row+1 : 0;
    
    if (sectionCounts <= section)
    {
        return;
    }
    
    while (sectionCounts > section)
    {
        [self enumerateRowsInSection:section fromRow:row withBlock:enumerationBlock];
        
        row = 0;
        section += 1;
    }
}

- (void) enumerateRowsInSection:(NSUInteger)section fromRow:(NSUInteger)row withBlock:(void(^)(NSIndexPath *indexPath, BOOL *stop))enumerationBlock
{
    BOOL stop = NO;
    
    NSUInteger rowsCount = [self.collectionView numberOfItemsInSection:section];
    
    if (rowsCount <= row)
    {
        return;
    }
    
    while (row < rowsCount) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
        enumerationBlock(indexPath,&stop);
        
        if (stop)
        {
            return;
        }
        
        row += 1;
    }
}


@end

//- (void)scrollToFormAttribute:(AFFormLayoutAttributes *)formLayoutAttributes
//{
//    CGFloat height = CGRectGetHeight(self.collectionView.frame);
//
//    CGPoint proposedContentOffset = self.collectionView.contentOffset;
//    proposedContentOffset.y = (CGRectGetMaxY(formLayoutAttributes.frame) + self.minimumLineSpacing) - height;
//
//    [self.collectionView setContentOffset:proposedContentOffset];
//}
//


