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

@class AFRowConfig;
@class AFLayoutConfig;
@class AFBaseCellConfig;

@interface AFRow : NSObject<AFCellRow>
{
    @private
    NSString *identifier;
}

@property (nonatomic, strong, readonly) NSString *key;

@property (nonatomic, strong) id<AFValue> value;

@property (nonatomic, strong) AFBaseCellConfig *cellConfig;

+ (id) rowWithConfig:(AFRowConfig *)rowConfig inputViewConfig:(AFBaseCellConfig *)ivConfig layoutConfig:(AFLayoutConfig *)layoutConfig;

- (instancetype) initWithKey:(NSString *)key value:(id)value andIdentifier:(NSString *)identifier;

- (instancetype) initWithKey:(NSString *)key andIdentifier:(NSString *)identifier;

@end
