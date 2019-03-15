//
//  AFResourceManager.m
//  AForm
//
//  Created by Administrator on 12/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import "AFResourceManager_Private.h"

@interface AFResourceManager()

@property (nonatomic, strong) NSMutableDictionary *resourceNibsByIdentifier;

@property (nonatomic, strong) NSMutableDictionary *resourceClassesByIdentifier;

@property (nonatomic, strong) NSMutableDictionary *resourceHeaderClassesByIdentifier;

@property (nonatomic, strong) NSMutableDictionary *resourceHeaderNibsByIdentifier;

@end

@implementation AFResourceManager

+ (id) sharedInstance
{
    static AFResourceManager *_sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[AFResourceManager alloc] init];
    });
    
    return _sharedInstance;
}

- (instancetype) init
{
    if ( ( self = [super init]) == nil )
    {
        return nil;
    }
    self.resourceNibsByIdentifier = [NSMutableDictionary new];
    self.resourceClassesByIdentifier = [NSMutableDictionary new];
    self.resourceHeaderNibsByIdentifier = [NSMutableDictionary new];
    self.resourceHeaderClassesByIdentifier = [NSMutableDictionary new];
    return self;
}

#pragma mark - PublicAPI methods

- (void)registrateResourceNib:(UINib *)nib withKind:(AFResourceManagerElementKind)kind andIdentifier:(NSString *)identifier
{
    if ([self getResourceNibForIdentifier:identifier forElementKind:kind])
    {
        [self unregisterNibWithIdentifier:identifier withKind:kind];
         NSLog(@"AForm: [WARNING!] you tried registrate resource on idetifier:%@ which alrady registrated, old resource was removed \n",identifier);
    }
    
    NSMutableDictionary *map = [self getMapNibsResourceForKind:kind];
    [map setObject:nib forKey:identifier];
}

- (void) registrateResourceClass:(Class)cls withKind:(AFResourceManagerElementKind)kind andIdentifier:(NSString *)identifier
{
    if ([self getResourceClasssForIdentifier:identifier forElementKind:kind])
    {
        [self unregisterClassWithIdentifier:identifier withKind:kind];
        NSLog(@"AForm: [WARNING!] you tried registrate resource on idetifier:%@ which alrady registrated, old resource was removed \n",identifier);
    }
    
    NSMutableDictionary *map = [self getMapClassesResourceForKind:kind];
    [map setObject:cls forKey:identifier];
}

#pragma mark - PrivateAPI methods

- (void) enumerateNibsByIdentifierByBlock:(void (^)(UINib *, NSString *, AFResourceManagerElementKind))enumerationBlock
{
    [self enumerateMap:self.resourceNibsByIdentifier withElementKind:AFResourceManagerElementKind_Cell withBlock:enumerationBlock];
    [self enumerateMap:self.resourceHeaderNibsByIdentifier withElementKind:AFResourceManagerElementKind_Header withBlock:enumerationBlock];
}

- (void) enumerateClassesByIdentiferByBlock:(void (^)(__unsafe_unretained Class, NSString *, AFResourceManagerElementKind))enumerationBlock
{
    [self enumerateMap:self.resourceClassesByIdentifier withElementKind:AFResourceManagerElementKind_Cell withBlock:enumerationBlock];
    [self enumerateMap:self.resourceHeaderClassesByIdentifier withElementKind:AFResourceManagerElementKind_Header withBlock:enumerationBlock];
}

#pragma mark - utils methods

- (Class) getResourceClasssForIdentifier:(NSString *)identifier forElementKind:(AFResourceManagerElementKind)kind
{
    NSMutableDictionary *map = [self getMapClassesResourceForKind:kind];
    return [map valueForKey:identifier];
}

- (UINib *) getResourceNibForIdentifier:(NSString *)identifier forElementKind:(AFResourceManagerElementKind)kind
{
    NSMutableDictionary *map = [self getMapNibsResourceForKind:kind];
    return [map valueForKey:identifier];
}

- (NSMutableDictionary *) getMapClassesResourceForKind:(AFResourceManagerElementKind)kind
{
    NSMutableDictionary *storage = self.resourceHeaderClassesByIdentifier;
    
    if (kind == AFResourceManagerElementKind_Cell)
    {
        storage = self.resourceClassesByIdentifier;
    }
    
    return storage;
}

- (NSMutableDictionary *) getMapNibsResourceForKind:(AFResourceManagerElementKind)kind
{
    NSMutableDictionary *storage = self.resourceHeaderNibsByIdentifier;
    
    if (kind == AFResourceManagerElementKind_Cell)
    {
        storage = self.resourceNibsByIdentifier;
    }
    
    return storage;
}

- (void) unregisterNibWithIdentifier:(NSString *)identifier withKind:(AFResourceManagerElementKind)elementKind
{
    if (!identifier)
    {
        return;
    }
    NSMutableDictionary *map = [self getMapNibsResourceForKind:elementKind];
    [map removeObjectForKey:identifier];

}

- (void) unregisterClassWithIdentifier:(NSString *)identifier withKind:(AFResourceManagerElementKind)elementKind
{
    if (!identifier)
    {
        return;
    }
    
    NSMutableDictionary *map = [self getMapClassesResourceForKind:elementKind];
    [map removeObjectForKey:identifier];
}

- (void) enumerateMap:(NSDictionary *)map withElementKind:(AFResourceManagerElementKind)elementKind withBlock:(void (^)(id, NSString *, AFResourceManagerElementKind))enumerationBlock
{
    [map enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
    
        if (enumerationBlock)
        {
            enumerationBlock(obj,key,elementKind);
        }
    }];
}

@end
