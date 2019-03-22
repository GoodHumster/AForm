//
//  AFBaseCellConfig_Private.h
//  AForm
//
//  Created by Administrator on 22/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import "AFBaseCellConfig.h"

@interface AFBaseCellConfig(Private)

- (void) enumerateDependenciesWithBlock:(void(^)(AFBaseCellConfig *config,NSPredicate *predicate))enumrationBlock;

@end
