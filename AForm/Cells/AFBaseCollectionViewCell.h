//
//  AFBaseCollectionViewCell.h
//  AForm
//
//  Created by Administrator on 12/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AFRow;
@class AFFormLayoutAttributes;

@protocol AFCollectionViewCellOutput<NSObject>
@end

@protocol AFCollectionViewCell <NSObject>

- (void) configWithRow:(AFRow *)row layoutAttributes:(AFFormLayoutAttributes *)attributes;

@property (nonatomic, weak) id<AFCollectionViewCellOutput> output;

@end

@interface AFBaseCollectionViewCell : UICollectionViewCell<AFCollectionViewCell>

@property (nonatomic, weak) AFRow *row;
@property (nonatomic, weak) AFFormLayoutAttributes *layoutAttributes;



@end

