//
//  AFCellRow.h
//  AForm
//
//  Created by Administrator on 25/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFValue.h"
#import "AFBaseCellConfig.h"

@protocol AFCellRow <NSObject>

@property (nonatomic, strong) AFBaseCellConfig *config;

@property (nonatomic, strong, readonly) id<AFValue> cellValue;

@end
