//
//  AFFormAttributesCollection.h
//  AForm
//
//  Created by Administrator on 12/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class AFLayoutConfig;
@class AFCollectionViewFlowLayout;

@interface AFFormLayoutAttributes : UICollectionViewLayoutAttributes

@property (nonatomic, weak) AFCollectionViewFlowLayout *flowLayout;

@property (nonatomic, assign) NSUInteger uuid;
@property (nonatomic, assign) CGSize initionalSize;

- (void)invalidateFlowLayoutWithNewHeight:(CGFloat)height;

- (void)setPositionAfterFrame:(CGRect)afterFrame;

@end

