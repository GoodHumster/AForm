//
//  AFFormAttributesCollection.m
//  AForm
//
//  Created by Administrator on 12/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//


#import "AFCollectionViewFlowLayout.h"
#import "AFFormLayoutAttributes.h"

@implementation AFFormLayoutAttributes

- (void)invalidateFlowLayoutWithNewHeight:(CGFloat)height
{
    [self.flowLayout invalidateLayout:self withNewHeight:height];
}

- (void)setPositionAfterFrame:(CGRect)afterFrame
{
    UICollectionView *collectionView = self.flowLayout.collectionView;
    UIEdgeInsets sectionInsets = [self.flowLayout sectionInsetsForSection:self.indexPath.section];
    CGFloat minInteritemSpacing = self.flowLayout.minimumInteritemSpacing;
    CGFloat minLineSpacing = self.flowLayout.minimumLineSpacing;
    CGFloat collectionWidth = CGRectGetWidth(collectionView.frame);

    CGFloat yOffset = CGRectEqualToRect(afterFrame, CGRectZero) ? sectionInsets.top : 0;
    CGFloat xOffset = minInteritemSpacing;
    CGFloat x = CGRectGetMaxX(afterFrame) + xOffset;
    CGFloat y = CGRectGetMinY(afterFrame) + yOffset;
    CGFloat width = CGRectGetWidth(self.frame);
    
    if ((width+x) > collectionWidth)
    {
        x = minInteritemSpacing;
        y = CGRectGetMaxY(afterFrame) + minLineSpacing;
    }
    
    CGRect frame = self.frame;
    frame.origin = CGPointMake(x, y);
    
    self.frame = frame;
}

#pragma mark - NSObject methods

- (BOOL) isEqual:(id)object
{
    return [super isEqual:object];
}

@end

