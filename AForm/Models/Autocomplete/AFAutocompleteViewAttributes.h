//
//  AFAutocompleteViewAttributes.h
//  AForm
//
//  Created by Administrator on 14/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

static CGFloat const kAFAutocompletViewHeightAutomaticDemision = CGFLOAT_MAX;

@interface AFAutocompleteViewAttributes : NSObject

@property (nonatomic, assign) UIEdgeInsets instes;

@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat estimatedHeight;

@end

