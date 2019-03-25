//
//  AFLabelCellConfig.h
//  AForm
//
//  Created by Administrator on 25/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AFBaseCellConfig.h"

@interface AFLabelCellConfig : AFBaseCellConfig

@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, assign) NSTextAlignment aligment;
@property (nonatomic, assign) NSInteger numberOfLines;
@property (nonatomic, assign) NSLineBreakMode lineBreakMode;
@property (nonatomic, assign) BOOL editable;
@property (nonatomic, strong) NSString *defaultText;

@end
