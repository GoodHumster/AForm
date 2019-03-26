//
//  AFBaseCellConfig.m
//  AForm
//
//  Created by Administrator on 21/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import "AFBaseCellConfig_Private.h"

#import "AFLayoutConfig.h"

@interface AFBaseCellDependency : NSObject

@property (nonatomic, strong) AFBaseCellConfig *config;
@property (nonatomic, strong) NSPredicate *predicate;

@end

@implementation AFBaseCellDependency
@end

@interface AFBaseCellConfig()

@property (nonatomic, strong) NSMutableArray<AFBaseCellDependency *> *dependecies;

@end

@implementation AFBaseCellConfig

@synthesize layoutConfig = _layoutConfig;
@synthesize identifier = _identifier;
@synthesize minimumDependeciesLineSpacing = _minimumDependeciesLineSpacing;
@synthesize minimumDependeciesInterItemSpacing = _minimumDependeciesInterItemSpacing;

- (instancetype) init
{
    if ( ( self = [super init]) == nil )
    {
        return nil;
    }
    self.dependecies = [NSMutableArray new];
    self.minimumDependeciesInterItemSpacing = 0;
    self.minimumDependeciesLineSpacing = 0;
    return self;
}

#pragma mark - Public API methods

- (void) addAlwaysShowDependencyConfig:(AFBaseCellConfig *)config
{
    [self addDependencyConfig:config withShowPredicate:[NSPredicate predicateWithValue:YES]];
}

- (void) addDependencyConfig:(AFBaseCellConfig *)config withShowPredicate:(NSPredicate *)predicate
{
    if (!predicate)
    {
        NSLog(@"%@ WARNING Dependency need show predicate",NSStringFromClass(self.class));
        return;
    }
    
    AFBaseCellDependency *cellDependency = [AFBaseCellDependency new];
    cellDependency.config = config;
    cellDependency.predicate = predicate;
    
    [self.dependecies addObject:cellDependency];
}

#pragma mark - Private API methods

- (void)enumerateDependenciesWithBlock:(void(^)(AFBaseCellConfig *, NSPredicate *, NSInteger))enumrationBlock
{
    [self.dependecies enumerateObjectsUsingBlock:^(AFBaseCellDependency * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        enumrationBlock(obj.config,obj.predicate,idx);
    }];
}

- (NSInteger)dependenciesCount
{
    return self.dependecies.count;
}

- (AFBaseCellConfig *)dependencyConfigAtIndex:(NSInteger)index
{
    AFBaseCellDependency *dependency = [self.dependecies objectAtIndex:index];
    return dependency.config;
}

- (NSPredicate *)dependencyPredicateAtIndex:(NSInteger)index
{
    AFBaseCellDependency *dependency = [self.dependecies objectAtIndex:index];
    return dependency.predicate;
}

- (CGFloat)dependenciesPreapreHeight
{
    __block CGFloat height = 0;
    
    [self enumerateDependenciesWithBlock:^(AFBaseCellConfig *config, NSPredicate *predicate, NSInteger index) {
        height += config.layoutConfig.height.constant;
    }];
    
    return height;
}

#pragma mark - NSCoping protocol methods

- (id) copyWithZone:(NSZone *)zone
{
    AFBaseCellConfig *copy = [self.class new];
    copy.dependecies = self.dependecies;
    return copy;
}


@end
