//
//  AFTextViewCellConfig.h
//  AForm
//
//  Created by Administrator on 25/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import "AFBaseTextContainerCellConfig.h"
#import "AFTextView.h"

@interface AFTextViewCellConfig : AFBaseTextContainerCellConfig

@property (nonatomic, assign) Class<AFTextView> textViewClass;

+ (id) defaultTextViewConfig;

@end

