//
//  AFInputRow.h
//  AForm
//
//  Created by Administrator on 28/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFValue.h"
#import "AFCellConfig.h"
#import "AFLayoutConfig.h"
#import "AFRow.h"

@protocol AFInputRow <NSObject>

@property (nonatomic, strong, readonly) NSString *key;
@property (nonatomic, strong) id<AFValue> value;
@property (nonatomic, strong) id<AFCellConfig> viewConfig;
@property (nonatomic, strong) AFLayoutConfig *layoutConfig;
@property (nonatomic, assign) NSUInteger numberOfRows;

- (AFRow *) getRowAtIndex:(NSInteger)index;

@end
