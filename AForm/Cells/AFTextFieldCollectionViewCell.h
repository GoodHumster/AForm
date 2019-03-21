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

- (void) textFieldDidBeginEditing:(AFTextFieldCollectionViewCell *)cell;
- (void) textFieldDidEndEditing:(AFTextFieldCollectionViewCell *)cell;
- (void) textFieldDidPressReturnKey:(AFTextFieldCollectionViewCell *)cell;

- (void) textFieldCell:(AFTextFieldCollectionViewCell *)cell didChangeValue:(NSString *)value inRow:(AFRow *)row;
- (void) textFieldCell:(AFTextFieldCollectionViewCell *)cell shouldShowAutocomplete:(UIView<AFAutocompleteView> *)view withControllBlock:(void(^)(BOOL show))controllBlock;

@end

@interface AFTextFieldCollectionViewCell : AFBaseCollectionViewCell

@property (nonatomic, weak) id<AFTextFieldCollectionViewCellOutput> output;
@property (nonatomic, strong) UIView *underlineView;

@end

extern NSString *const kAFTextFieldCollectionViewCellIdentifier;

