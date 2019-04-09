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

@property (nonatomic, weak) id<AFCollectionViewCellOutput> output;

- (void) configWithRow:(id<AFCellRow>)row andConfig:(id<AFCellConfig>)config;

@end

@interface AFBaseCollectionViewCell : UICollectionViewCell<AFCollectionViewCell>

@property (nonatomic, weak, readonly) NSIndexPath *indexPath;
@property (nonatomic, weak, readonly) id<AFCellRow> cellRow;
@property (nonatomic, weak, readonly) id<AFCellConfig> config;
@property (nonatomic, assign) CGFloat height;

- (void) setRowValue:(id)value;
- (void) updateRowValue;
- (void) initialize;



@end

