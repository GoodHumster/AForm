//
//  AFBaseTextContainerCollectionViewCell_Private.h
//  AForm
//
//  Created by Administrator on 26/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import "AFBaseTextContainerCollectionViewCell.h"
#import "AFTextInputContentView.h"
#import "AFFormLayoutAttributes.h"

@interface AFBaseTextContainerCollectionViewCell()<AFAutocompleteViewDelegate>

@property (nonatomic, assign) CGFloat autocompleteHeight;

- (void) initialize;
- (void) addTextContainer:(UIView *)textContainer;

- (void) showAutocompleteViewIfNeeded;

- (void) setNewValue:(id<AFValue>)value;

@end
