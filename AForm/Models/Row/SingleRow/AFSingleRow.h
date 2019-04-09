//
//  AFSingleRow.h
//  AForm
//
//  Created by Administrator on 28/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFInputRow.h"

@interface AFSingleRow : AFInputRow

+ (id) rowWithKey:(NSString *)key value:(id<AFValue>)value viewConfig:(id<AFCellConfig>)ivConfig layoutConfig:(AFLayoutConfig *)layoutConfig;

@end

