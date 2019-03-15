//
//  AFHeaderSectionViewCell.h
//  AForm
//
//  Created by Administrator on 14/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AFSection;

@protocol AFHeaderSectionView <NSObject>

- (void) configWithSection:(AFSection *)section;

@end
