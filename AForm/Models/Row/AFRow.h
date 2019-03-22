//
//  AFRow.h
//  AForm
//
//  Created by Administrator on 12/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFValue.h"

@class AFRowConfig;
@class AFLayoutConfig;
@protocol AFCellConfig;

@interface AFRow : NSObject
{
    @private
    NSString *identifier;
}

@property (nonatomic, strong, readonly) NSString *key;

@property (nonatomic, strong) id<AFValue> value;

@property (nonatomic, strong) id<AFCellConfig> inputViewConfig;

@property (nonatomic, strong) AFLayoutConfig *layoutConfig;

+ (id) rowWithConfig:(AFRowConfig *)rowConfig inputViewConfig:(id<AFCellConfig>)ivConfig layoutConfig:(AFLayoutConfig *)layoutConfig;

+ (id) rowWithKey:(NSString *)key value:(id)value andIdentifier:(NSString *)identifier;

+ (id) rowWithKey:(NSString *)key andIdentifier:(NSString *)identifier;

@end
