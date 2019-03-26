//
//  AFTextFieldCollectionViewCell.h
//  AForm
//
//  Created by Administrator on 12/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import "AFBaseCollectionViewCell.h"
#import "AFBaseTextContainerCollectionViewCell.h"
#import "AFTextFieldCellConfig.h"

@interface AFTextFieldCollectionViewCell : AFBaseTextContainerCollectionViewCell

@property (nonatomic, weak) AFTextFieldCellConfig *config;

@end

extern NSString *const kAFTextFieldCollectionViewCellIdentifier;

