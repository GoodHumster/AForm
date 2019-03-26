//
//  AFBaseTextContainerCollectionViewCell.h
//  AForm
//
//  Created by Administrator on 26/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import "AFBaseCollectionViewCell.h"
#import "AFBaseTextContainerCellConfig.h"

@class AFBaseTextContainerCollectionViewCell;

@protocol AFBaseTextContainerCollectionViewCellOutput <AFCollectionViewCellOutput>

- (void) textContainerCellDidBeginEditing:(AFBaseTextContainerCollectionViewCell *)cell;
- (void) textContainerCellDidEndEditing:(AFBaseTextContainerCollectionViewCell *)cell;
- (void) textContainerCellDidPressReturnKey:(AFBaseTextContainerCollectionViewCell *)cell;

- (void) textContainerCell:(AFBaseTextContainerCollectionViewCell *)cell didChangeValueAtIndexPath:(NSIndexPath *)indexPath;
- (void) textContainerCell:(AFBaseTextContainerCollectionViewCell *)cell shouldShowAutocomplete:(UIView<AFAutocompleteView> *)view withControllBlock:(void(^)(BOOL show))controllBlock;


@end

@interface AFBaseTextContainerCollectionViewCell : AFBaseCollectionViewCell

@property (nonatomic, weak) AFBaseTextContainerCellConfig *config;
@property (nonatomic, weak) id<AFBaseTextContainerCollectionViewCellOutput> output;


@end
