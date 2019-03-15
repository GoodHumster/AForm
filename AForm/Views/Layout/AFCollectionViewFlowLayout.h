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

@protocol AFCollectionViewFlowLayoutDelegate <UICollectionViewDelegateFlowLayout>

- (AFLayoutConfig *) layoutConfigForItemAtIndexPath:(NSIndexPath *)indexPath;

- (AFLayoutConfig *) layoutConfigForHeaderAtSection:(NSUInteger)section;

@end

@interface AFCollectionViewFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, weak) id<AFCollectionViewFlowLayoutDelegate> delegate;

- (void) invalidateLayout:(AFFormLayoutAttributes *)attribute withNewSize:(CGSize)size;

- (AFFormLayoutAttributes *) getFormLayoutAttributesAtIndexPath:(NSIndexPath *)indexPath;

@end

