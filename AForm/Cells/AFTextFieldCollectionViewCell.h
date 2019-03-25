//
//  AFTextFieldCollectionViewCell.h
//  AForm
//
//  Created by Administrator on 12/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import "AFBaseCollectionViewCell.h"


@class AFTextFieldCollectionViewCell;
@protocol AFAutocompleteView;

@protocol AFTextFieldCollectionViewCellOutput <AFCollectionViewCellOutput>

- (void) textFieldCellDidBeginEditing:(AFTextFieldCollectionViewCell *)cell;
- (void) textFieldCellDidEndEditing:(AFTextFieldCollectionViewCell *)cell;
- (void) textFieldCellDidPressReturnKey:(AFTextFieldCollectionViewCell *)cell;

- (void) textFieldCell:(AFTextFieldCollectionViewCell *)cell didChangeValueinRow:(id<AFCellRow>)row;
- (void) textFieldCell:(AFTextFieldCollectionViewCell *)cell shouldShowAutocomplete:(UIView<AFAutocompleteView> *)view withControllBlock:(void(^)(BOOL show))controllBlock;

@end

@interface AFTextFieldCollectionViewCell : AFBaseCollectionViewCell

@property (nonatomic, weak) id<AFTextFieldCollectionViewCellOutput> output;
@property (nonatomic, strong) UIView *underlineView;

@end

extern NSString *const kAFTextFieldCollectionViewCellIdentifier;

