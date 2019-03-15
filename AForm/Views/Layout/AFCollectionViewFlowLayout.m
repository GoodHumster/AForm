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

@end

@implementation AFCollectionViewFlowLayout

#pragma mark - init methods

- (instancetype) init
{
    if ( ( self = [super init]) == nil )
    {
        return nil;
    }
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.cachedLayoutAttributes = [AFLayoutAttributesDictionary new];
    return self;
}

#pragma mark - UICollectionViewFlowLayout methods

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray<AFFormLayoutAttributes *> *attributes = [self.cachedLayoutAttributes getFormAttributeInRect:rect];
    
    if (attributes && [self.cachedLayoutAttributes isFilledRect:rect])
    {
        return [attributes valueForKey:@"collectionLayoutAttributes"];
    }
    
    NSMutableArray<AFFormLayoutAttributes *> *mAttributes = [attributes mutableCopy];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    if (mAttributes)
    {
        AFFormLayoutAttributes *layoutAttributes = mAttributes.lastObject;
        indexPath = layoutAttributes.indexPath;
    }
    
    AFLayoutAttributesDictionary *cachedAttributes = self.cachedLayoutAttributes;
    
    void (^createIfNeededAndCachedBlock) (NSIndexPath *indexPath, AFCollectionViewElementKind elementKind) = ^(NSIndexPath *indexPath, AFCollectionViewElementKind elementKind) {
        
        AFFormLayoutAttributes *attr = [self createAFFormLayoutAttributesAtIndexPath:indexPath elementKind:elementKind];
        
        if (!attr)
        {
            return;
        }
        
        [cachedAttributes cacheFormAttribute:attr];
        [mAttributes addObject:attr];
    };
    
    while (![cachedAttributes isFilledRect:rect])
    {
        [self enumerateIndexPathsFromIndexPath:indexPath withBlock:^(NSIndexPath *indexPath) {
           
            if (indexPath.row == 0)
            {
                createIfNeededAndCachedBlock(indexPath,AFCollectionViewElementKind_Header);
            }
            
            createIfNeededAndCachedBlock(indexPath,AFCollectionViewElementKind_Cell);
        }];
    }

    return [mAttributes valueForKey:@"collectionLayoutAttributes"];
}

- (void)invalidateLayout
{
    [self.cachedLayoutAttributes clear];
    [super invalidateLayout];
}

#pragma mark - Public API

- (AFFormLayoutAttributes *) getFormLayoutAttributesAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.cachedLayoutAttributes getFormAttributeByIndexPath:indexPath];
}

- (void) invalidateLayout:(AFFormLayoutAttributes *)attribute withNewSize:(CGSize)size
{
    NSUInteger prevUuid = attribute.uuid - 1;
    __block CGRect prevFrame = CGRectZero;
    
    if (prevUuid != NSNotFound)
    {
        prevFrame = [self.cachedLayoutAttributes getFormAttributeById:prevUuid].collectionLayoutAttributes.frame;
    }
    
    UICollectionViewLayoutAttributes *collectionLayoutAttribute = attribute.collectionLayoutAttributes;
    [self moveLayout:collectionLayoutAttribute fromRect:prevFrame withSize:size];
    prevFrame = collectionLayoutAttribute.frame;
    
    [self.cachedLayoutAttributes enumerateFormAttributeStartFrom:attribute.uuid wihtBlock:^(AFFormLayoutAttributes *formAttribute) {

        UICollectionViewLayoutAttributes *collectionLayoutAttribute = formAttribute.collectionLayoutAttributes;
        [self moveLayout:collectionLayoutAttribute fromRect:prevFrame withSize:collectionLayoutAttribute.frame.size];
        prevFrame = collectionLayoutAttribute.frame;
    }];
}

- (void) moveLayout:(UICollectionViewLayoutAttributes *)attributes fromRect:(CGRect)fromFrame withSize:(CGSize)size
{
    CGFloat minimumInteritemSpacing = self.minimumInteritemSpacing;
    CGFloat x = CGRectGetMaxX(fromFrame) + minimumInteritemSpacing;
    CGFloat y = CGRectGetMinY(fromFrame);
    
    CGFloat width = CGRectGetWidth(attributes.frame);
    CGFloat parentWidth = CGRectGetWidth(self.collectionView.frame);

    if ((width+x) > parentWidth)
    {
        x = minimumInteritemSpacing;
        y = CGRectGetMaxY(fromFrame) + self.minimumLineSpacing;
    }
    
    CGRect frame = attributes.frame;
    frame.origin = CGPointMake(x, y);
    frame.size = size;
    
    attributes.frame = frame;
}


#pragma mark - utils methods

- (AFFormLayoutAttributes *) createAFFormLayoutAttributesAtIndexPath:(NSIndexPath *)indexPath elementKind:(AFCollectionViewElementKind)kind
{
    CGSize size = [self sizeForElementKind:kind atIndexPath:indexPath];
    
    if (!CGSizeEqualToSize(size, CGSizeZero))
    {
        return nil;
    }
    
    AFFormLayoutAttributes *lastFromLayoutAttribute = [self.cachedLayoutAttributes lastFormAttribute];
    UICollectionViewLayoutAttributes *lastCollectionLayoutAttributes = lastFromLayoutAttribute.collectionLayoutAttributes;
    
    UICollectionViewLayoutAttributes *layoutAttributes = nil;
    
    NSString *elementKind = nil;
    
    switch (kind) {
        case AFCollectionViewElementKind_Header:
            elementKind = UICollectionElementKindSectionHeader;
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
    
    CGRect lastAttrFrame = lastCollectionLayoutAttributes.frame;
    
    [self moveLayout:layoutAttributes fromRect:lastAttrFrame withSize:size];
    
    AFFormLayoutAttributes *formLayoutAttribute = [AFFormLayoutAttributes new];
    
    formLayoutAttribute.collectionLayoutAttributes = layoutAttributes;
    formLayoutAttribute.uuid = lastFromLayoutAttribute.uuid+=1;
    formLayoutAttribute.indexPath = indexPath;
    formLayoutAttribute.flowLayout = self;
    
    return formLayoutAttribute;
}

- (void) enumerateIndexPathsFromIndexPath:(NSIndexPath *)indexPath withBlock:(void(^)(NSIndexPath *indexPath))enumerationBlock
{
    NSInteger sectionCounts = [self.collectionView numberOfSections];
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row +1;
    
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
            enumerationBlock(indexPath);
            row += 1;
        }
        
        section += 1;
    }
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
    if ([self.delegate respondsToSelector:@selector(layoutConfigForHeaderAtSection:)])
    {
        return CGSizeZero;
    }
    
    AFLayoutConfig *config = [self.delegate layoutConfigForHeaderAtSection:indexPath.section];
    return [self sizeForLayoutConfig:config wihtSectionInsets:UIEdgeInsetsZero];
}

- (CGSize) sizeForCellAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(layoutConfigForItemAtIndexPath:)])
    {
        return CGSizeZero;
    }
    
    UIEdgeInsets sectionInsets = [self sectionInsetsAtIndex:indexPath.section];
    AFLayoutConfig *config = [self.delegate layoutConfigForItemAtIndexPath:indexPath];
    
    return [self sizeForLayoutConfig:config wihtSectionInsets:sectionInsets];
}

- (CGSize) sizeForLayoutConfig:(AFLayoutConfig *)config wihtSectionInsets:(UIEdgeInsets)insets
{
    CGFloat parentWidth = CGRectGetWidth(self.collectionView.frame);
    CGFloat parentHeight = CGRectGetHeight(self.collectionView.frame);
    
    
    CGFloat height = config.height.constant + config.height.multiplie * parentHeight;
    CGFloat width = config.width.constant + config.width.multiplie * parentWidth;
    
    if (height == AFLayoutConstraintAutomaticDimension)
    {
        height = config.height.estimate;
    }
    
    if (width == AFLayoutConstraintAutomaticDimension)
    {
        width = config.width.estimate;
    }
    
    CGRect frame = {.origin = CGPointZero, .size = CGSizeMake(width, height)};
    return UIEdgeInsetsInsetRect(frame, insets).size;
}

- (UIEdgeInsets) sectionInsetsAtIndex:(NSInteger)section
{
    if (![self.delegate respondsToSelector:@selector(collectionView:layout:insetForSectionAtIndex:)])
    {
        return self.sectionInset;
    }
    
    return [self.delegate collectionView:self.collectionView layout:self insetForSectionAtIndex:section];
}

@end


