//
//  AFTextViewCollectionViewCell.h
//  AForm
//
//  Created by Administrator on 25/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import "AFBaseTextContainerCollectionViewCell.h"
#import "AFTextViewCellConfig.h"

@interface AFTextViewCollectionViewCell : AFBaseTextContainerCollectionViewCell

@property (nonatomic, weak) AFTextViewCellConfig *config;

@end

extern NSString *const kAFTextViewCollectionViewCellIdentifier;
