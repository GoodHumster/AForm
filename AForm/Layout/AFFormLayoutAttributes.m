//
//  AFFormAttributesCollection.m
//  AForm
//
//  Created by Administrator on 12/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//


#import "AFCollectionViewFlowLayout.h"
#import "AFFormLayoutAttributes.h"

@implementation AFFormLayoutAttributes

- (void)invalidateFlowLayoutWithNewHeight:(CGFloat)height
{
    [self.flowLayout invalidateLayout:self withNewHeight:height];
}

#pragma mark - NSObject methods

- (BOOL) isEqual:(id)object
{
    return [super isEqual:object];
}

@end

