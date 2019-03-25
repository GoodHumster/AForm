//
//  AFLabelCollectionViewCell.h
//  AForm
//
//  Created by Administrator on 25/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import "AFBaseCollectionViewCell.h"

@class AFLabelCellConfig;

@interface AFLabelCollectionViewCell : AFBaseCollectionViewCell

@property (nonatomic, weak) AFLabelCellConfig *config;

@end

extern NSString *const kAFLabelCollectionViewCellIdentifier;

