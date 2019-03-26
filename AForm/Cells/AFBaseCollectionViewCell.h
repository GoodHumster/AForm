//
//  AFBaseCollectionViewCell.h
//  AForm
//
//  Created by Administrator on 12/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AFCellRow.h"

@class AFFormLayoutAttributes;
@class AFBaseCollectionViewCell;
@protocol AFRowOutput;

@protocol AFCollectionViewCellOutput<NSObject>
@end

@protocol AFCollectionViewCell <NSObject>

- (void) configWithRow:(id<AFCellRow>)row andConfig:(AFBaseCellConfig *)config layoutAttributes:(AFFormLayoutAttributes *)attributes;

@property (nonatomic, weak) id<AFCollectionViewCellOutput> output;

@end

@interface AFBaseCollectionViewCell : UICollectionViewCell<AFCollectionViewCell>

@property (nonatomic, weak) id<AFCellRow> cellRow;
@property (nonatomic, weak) AFBaseCellConfig *config;
@property (nonatomic, weak) AFFormLayoutAttributes *layoutAttributes;
@property (nonatomic, assign) CGFloat height;

- (void) setRowValue:(id)value;
- (void) updateRowValue;
- (void) initialize;



@end

