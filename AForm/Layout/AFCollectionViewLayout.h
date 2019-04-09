//
//  AFormCollectionViewFlowLayout.h
//  AForm
//
//  Created by Administrator on 12/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AFFormLayoutAttributes;
@class AFLayoutConfig;
@class AFRow;
@class AFSection;

@protocol AFCollectionViewLayoutDelegate <UICollectionViewDelegateFlowLayout>

@required

- (AFLayoutConfig *) layoutConfigForItemAtIndexPath:(NSIndexPath *)indexPath;

- (AFLayoutConfig *) layoutConfigForHeaderAtSection:(NSUInteger)section;

@end

@interface AFCollectionViewLayout : UICollectionViewLayout

@property (nonatomic, weak) id<AFCollectionViewLayoutDelegate> delegate;
@property (nonatomic, assign) BOOL invalidateLayoutBoundsChange;
@property (nonatomic, assign) CGSize prepareCollectionViewContentSize;

- (void) invalidateLayout:(AFFormLayoutAttributes *)attribute withNewHeight:(CGFloat)height;
- (void) invalidateLayout:(AFFormLayoutAttributes *)attribute withNewSize:(CGSize)size;

- (AFFormLayoutAttributes *) getFormLayoutAttributesAtIndexPath:(NSIndexPath *)indexPath;
- (UIEdgeInsets) sectionInsetsForSection:(NSInteger)section;

@end

