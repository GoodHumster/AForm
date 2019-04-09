//
//  AFRow.h
//  AForm
//
//  Created by Administrator on 12/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFValue.h"
#import "AFCellRow.h"
#import "AFCellConfig.h"

@class AFLayoutConfig;
@class AFBaseCellConfig;

@interface AFRow : NSObject
{
    @private
    NSString *identifier;
}

@property (nonatomic, strong, readonly) NSString *key;
@property (nonatomic, strong) id<AFValue> value;
@property (nonatomic, strong) id<AFCellConfig> cellConfig;
@property (nonatomic, strong) AFLayoutConfig *layoutConfig;

+ (id)rowWithKey:(NSString *)key inputViewConfig:(id<AFCellConfig>)ivConfig layoutConfig:(AFLayoutConfig *)layoutConfig;

+ (id)compositeRowWithKey:(NSString *)key withRows:(NSArray<AFRow *> *)rows;

+ (id)multiplieRowWithKey:(NSString *)key withRows:(NSArray<AFRow *> *)rows;


@end
