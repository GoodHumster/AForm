//
//  AFBaseCollectionViewCell.m
//  AForm
//
//  Created by Administrator on 12/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import "AFBaseCollectionViewCell.h"

@implementation AFBaseCollectionViewCell

@dynamic output;

- (void) configWithRow:(AFRow *)row layoutAttributes:(AFFormLayoutAttributes *)attributes
{
    self.row = row;
    self.layoutAttributes = attributes;
}

@end
