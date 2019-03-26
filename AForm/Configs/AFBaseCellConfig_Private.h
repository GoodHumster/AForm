//
//  AFBaseCellConfig_Private.h
//  AForm
//
//  Created by Administrator on 22/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import "AFBaseCellConfig.h"



@interface AFBaseCellConfig(Private)

@property (nonatomic, assign, readonly) NSInteger dependenciesCount;

@property (nonatomic, assign, readonly) CGFloat dependenciesPreapreHeight;

- (AFBaseCellConfig *) dependencyConfigAtIndex:(NSInteger)index;

- (NSPredicate *) dependencyPredicateAtIndex:(NSInteger)index;

- (void) enumerateDependenciesWithBlock:(void(^)(AFBaseCellConfig *config, NSPredicate *predicate, NSInteger))enumrationBlock;

@end
