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
    self.cachedLayoutAttributes = [AFLayoutAttributesDictionary new];
    return self;
}

#pragma mark - UICollectionViewFlowLayout methods

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray<AFFormLayoutAttributes *> *attributes = [self.cachedLayoutAttributes getFormAttributeInRect:rect];
    AFFormLayoutAttributes *layoutAttributes = attributes.lastObject;
    
    if (attributes && [self.cachedLayoutAttributes isFilledRect:rect])
    {
        return [attributes valueForKey:@"collectionLayoutAttributes"];
    }
    
    NSMutableArray<AFFormLayoutAttributes *> *mAttributes = [attributes mutableCopy];
    NSIndexPath *indexPath = layoutAttributes.indexPath;
    
    if (!mAttributes)
    {
          mAttributes = [NSMutableArray new];
    }
    
    AFLayoutAttributesDictionary *cachedAttributes = self.cachedLayoutAttributes;
    
    void (^createIfNeededAndCachedBlock) (NSIndexPath *indexPath, AFCollectionViewElementKind elementKind) = ^(NSIndexPath *indexPath, AFCollectionViewElementKind elementKind) {
        
        AFFormLayoutAttributes *attr = [self createFormLayoutAttributesAtIndexPath:indexPath elementKind:elementKind];
        
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
   
    NSArray<UICollectionViewLayoutAttributes *> *layoutesAttibutes = [mAttributes valueForKey:@"collectionLayoutAttributes"];
    UICollectionViewLayoutAttributes *lastLayoutAttribute = layoutesAttibutes.lastObject;
    
    if (CGRectGetMaxY(lastLayoutAttribute.frame) > _contentSize.height)
    {
        _contentSize.height = CGRectGetMaxY(lastLayoutAttribute.frame) + 10;
        _contentSize.width = CGRectGetWidth(self.collectionView.frame);
    }
    
    return layoutesAttibutes;
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

- (CGSize)collectionViewContentSize
{
    if (CGSizeEqualToSize(CGSizeZero, _contentSize))
    {
        return [super collectionViewContentSize];
    }
    
    return _contentSize;
}

#pragma mark - Layout create helpers

- (AFFormLayoutAttributes *) createFormLayoutAttributesAtIndexPath:(NSIndexPath *)indexPath elementKind:(AFCollectionViewElementKind)kind
{
    UICollectionViewLayoutAttributes *layoutAttributes = nil;
    NSString *elementKind = nil;
    
    switch (kind) {
        case AFCollectionViewElementKind_Header:
            elementKind = UICollectionElementKindSectionHeader;
            layoutAttributes = [self layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPath:indexPath];
            break;
        case AFCollectionViewElementKind_Footer:
            elementKind = UICollectionElementKindSectionFooter;
            layoutAttributes = [self layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPath:indexPath];
            break;
        case AFCollectionViewElementKind_Cell:
            layoutAttributes = [self layoutAttributesForItemAtIndexPath:indexPath];
            break;
        default:
            break;
    }
    
    if (!layoutAttributes)
    {
        return nil;
    }
    
    AFFormLayoutAttributes *lastFromLayoutAttribute = [self.cachedLayoutAttributes lastFormAttribute];
    UICollectionViewLayoutAttributes *lastCollectionLayoutAttributes = lastFromLayoutAttribute.collectionLayoutAttributes;
    CGRect lastAttrFrame = lastCollectionLayoutAttributes.frame;
    
    AFFormLayoutAttributes *formLayoutAttribute = [AFFormLayoutAttributes new];
    
    formLayoutAttribute.collectionLayoutAttributes = layoutAttributes;
    formLayoutAttribute.uuid = lastFromLayoutAttribute.uuid+1;
    formLayoutAttribute.indexPath = indexPath;
    formLayoutAttribute.flowLayout = self;
    formLayoutAttribute.initionalSize = layoutAttributes.frame.size;
    
    [self invalidateLayout:layoutAttributes fromRect:lastAttrFrame];
    
    return formLayoutAttribute;
}

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
    
    UIEdgeInsets sectionInsets = [self sectionInsetsAtIndex:indexPath.section];
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
    
    UIEdgeInsets sectionInsets = [self sectionInsetsAtIndex:indexPath.section];
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

- (UIEdgeInsets) sectionInsetsAtIndex:(NSInteger)section
{
    if (![self.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)])
    {
        return self.sectionInset;
    }
    
    return [self.delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:section];
}


#pragma mark - Public API methods

- (void) invalidateLayout:(AFFormLayoutAttributes *)attribute withNewHeight:(CGFloat)height
{
    __block CGRect prevFrame = CGRectZero;
    
    UICollectionViewLayoutAttributes *collectionLayoutAttribute = attribute.collectionLayoutAttributes;
    
    prevFrame = collectionLayoutAttribute.frame;
    prevFrame.size.height = height;
    collectionLayoutAttribute.frame = prevFrame;
    
    [self.cachedLayoutAttributes replaceFormAttribute:attribute];
    [self.cachedLayoutAttributes enumerateFormAttributeStartFrom:attribute.uuid wihtBlock:^(AFFormLayoutAttributes *formAttribute) {

        UICollectionViewLayoutAttributes *collectionLayoutAttribute = formAttribute.collectionLayoutAttributes;
        [self invalidateLayout:collectionLayoutAttribute fromRect:prevFrame];
        prevFrame = collectionLayoutAttribute.frame;
        
        [self.cachedLayoutAttributes replaceFormAttribute:attribute];
    }];
    
    [UIView animateWithDuration:0.4 animations:^{
        [self invalidateLayout];
    }];
}

- (AFFormLayoutAttributes *) getFormLayoutAttributesAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.cachedLayoutAttributes getFormAttributeByIndexPath:indexPath];
}

#pragma mark - utils methods

- (void) invalidateLayout:(UICollectionViewLayoutAttributes *)attributes fromRect:(CGRect)fromFrame
{
    UIEdgeInsets sectionInsets = [self sectionInsetsAtIndex:attributes.indexPath.section];
    CGFloat yOffset = CGRectEqualToRect(fromFrame, CGRectZero) ? sectionInsets.top : 0;
    CGFloat minimumInteritemSpacing = self.minimumInteritemSpacing;
    CGFloat x = CGRectGetMaxX(fromFrame) + minimumInteritemSpacing;
    CGFloat y = CGRectGetMinY(fromFrame) + yOffset;
    
    CGFloat width = CGRectGetWidth(attributes.frame);
    CGFloat parentWidth = CGRectGetWidth(self.collectionView.frame);
    
    if ((width+x) > parentWidth)
    {
        x = minimumInteritemSpacing;
        y = CGRectGetMaxY(fromFrame) + self.minimumLineSpacing;
    }
    
    CGRect frame = attributes.frame;
    frame.origin = CGPointMake(x, y);
    
    attributes.frame = frame;
}

- (void) enumerateIndexPathsFromIndexPath:(NSIndexPath *)indexPath withBlock:(void(^)(NSIndexPath *indexPath, BOOL *stop))enumerationBlock
{
    NSInteger sectionCounts = [self.collectionView numberOfSections];
    NSInteger section = indexPath ? indexPath.section : 0;
    NSInteger row = indexPath ? indexPath.row+1 : 0;
    BOOL stop = NO;
    
    if (sectionCounts <= section)
    {
        return;
    }
    
    while (sectionCounts > section)
    {
        NSInteger rowCounts = [self.collectionView numberOfItemsInSection:section];
        
        if (rowCounts <= row)
        {
            row = 0;
            section += 1;
            continue;
        }
        
        while (row < rowCounts) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
            enumerationBlock(indexPath,&stop);
            
            if (stop)
            {
                return;
            }
            row += 1;
        }
        
        section += 1;
    }
}

@end


