//
//  AFLayoutAttributesDictionary.m
//  AForm
//
//  Created by Administrator on 13/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import "AFLayoutAttributesDictionary.h"
#import "AFFormLayoutAttributes.h"

@interface AFLayoutAttributesDictionary()

@property (nonatomic, strong) NSMutableDictionary *cachedAttributesById;
@property (nonatomic, strong) NSMutableDictionary *cachedIdBySquare;
@property (nonatomic, strong) NSMutableDictionary *cachedIdByIndexPath;

@property (nonatomic, assign) CGFloat maxSquare;
@property (nonatomic, assign) NSInteger lastUUID;

@end

@implementation AFLayoutAttributesDictionary

- (instancetype) init
{
    if ( ( self = [super init]) == nil )
    {
        return nil;
    }
    
    self.cachedIdBySquare = [NSMutableDictionary new];
    self.cachedAttributesById = [NSMutableDictionary new];
    self.cachedIdByIndexPath = [NSMutableDictionary new];
    return self;
}

#pragma mark - Public API methods

- (NSArray<AFFormLayoutAttributes *> *)getFormAttributeInRect:(CGRect)rect
{
    if (self.isEmpty)
    {
        return nil;
    }
    
    CGFloat count = (CGFloat)self.cachedIdBySquare.count; // - 1;
    CGFloat maxY = CGRectGetMaxY(rect) == 0 ? CGRectGetHeight(rect) : CGRectGetMaxY(rect);
    CGFloat minY = CGRectGetMinY(rect) < 0 ? 0 : CGRectGetMinY(rect);
    
    CGFloat maxNeededSquare = fabs(CGRectGetMaxX(rect) * maxY);
    CGFloat minNeededSquare = fabs(CGRectGetMaxX(rect) * minY);
    CGFloat middleSquare = self.maxSquare / count;
    
    NSInteger minIdx = roundf(minNeededSquare / middleSquare);
    NSInteger maxIdx = roundf(maxNeededSquare / middleSquare) + minIdx;
    
    NSInteger neededCount = maxIdx - minIdx;
    
    if (minIdx >= self.cachedIdBySquare.count)
    {
        return @[[self lastFormAttribute]];
    }
    
    if (maxIdx >= self.cachedIdBySquare.count)
    {
        neededCount = self.cachedIdBySquare.count - minIdx;
        maxIdx = minIdx+neededCount;
    }
    
    NSMutableArray *mAttibutes = [NSMutableArray new];
    for (NSInteger idx = minIdx; idx <= maxIdx; idx++)
    {
        id value = [self.cachedAttributesById objectForKey:@(idx)];
        
        if (!value)
        {
            continue;
        }
        [mAttibutes addObject:value];
    }
    
    return [mAttibutes copy];
}

- (AFFormLayoutAttributes *)getFormAttributeByIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *idx = [self.cachedIdByIndexPath objectForKey:indexPath];
    
    if (!idx)
    {
        return nil;
    }
    
    return [self.cachedAttributesById objectForKey:idx];
}


- (AFFormLayoutAttributes *)getFormAttributeById:(NSUInteger)uuid
{
    return [self.cachedAttributesById objectForKey:@(uuid)];
}

- (void) cacheFormAttribute:(AFFormLayoutAttributes *)attribute
{
    if (!attribute || attribute.uuid == NSNotFound)
    {
        return;
    }
    
    NSUInteger uuid = attribute.uuid;
    
    [self.cachedAttributesById setObject:attribute forKey:@(uuid)];
    
    CGFloat square = [self getSquareForFormAttribute:attribute];
    [self.cachedIdBySquare setObject:@(uuid) forKey:@(square)];
    [self.cachedIdByIndexPath setObject:@(uuid) forKey:attribute.indexPath];
    
    self.lastUUID = MAX(self.lastUUID,uuid);
    self.maxSquare = MAX(self.maxSquare,square);
}

- (void)replaceFormAttribute:(AFFormLayoutAttributes *)attribute
{
    if (!attribute || attribute.uuid == NSNotFound)
    {
        return;
    }
    
    NSUInteger uuid = attribute.uuid;
    CGFloat oldSquare = [self getSquareForUUID:uuid];
    CGFloat newSquare = [self getSquareForFormAttribute:attribute];
    
    self.lastUUID = MAX(self.lastUUID,uuid);
    self.maxSquare = MAX(self.maxSquare,newSquare);
    
    [self.cachedAttributesById setObject:attribute forKey:@(uuid)];
    
    if (oldSquare != newSquare)
    {
        [self.cachedIdBySquare removeObjectForKey:@(oldSquare)];
        [self.cachedIdBySquare setObject:@(uuid) forKey:@(newSquare)];
    }
}

- (AFFormLayoutAttributes *)lastFormAttribute
{
    return [self.cachedAttributesById objectForKey:@(self.lastUUID)];
}

- (AFFormLayoutAttributes *)firtFormAttribute
{
    return [self.cachedAttributesById objectForKey:@0];
}

- (void)enumerateFormAttributeStartFrom:(NSUInteger)uuid wihtBlock:(void (^)(AFFormLayoutAttributes *))enumerationBlock
{
    NSSet<NSNumber *>* keysSet = [self.cachedAttributesById keysOfEntriesWithOptions:NSEnumerationConcurrent passingTest:^BOOL(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSUInteger keyUuid = [key unsignedIntegerValue];
        return keyUuid > uuid;
    }];
    
    NSArray<NSNumber *> *keys = [keysSet sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"self" ascending:YES]]];
    
    [keys enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
//    }]
//    [keys enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, BOOL * _Nonnull stop) {
//        
        AFFormLayoutAttributes *layoutAttributes = [self.cachedAttributesById objectForKey:obj];
        
        if (enumerationBlock)
        {
            enumerationBlock(layoutAttributes);
        }
    }];
}

- (BOOL) isFilledRect:(CGRect)rect
{
    CGFloat square = CGRectGetMaxX(rect) * CGRectGetMaxY(rect);
    return square <= self.maxSquare;
}

- (BOOL) isEmpty
{
    return self.cachedAttributesById.count == 0;
}

- (void)clear
{
    [self.cachedIdBySquare removeAllObjects];
    [self.cachedAttributesById removeAllObjects];
}

#pragma mark - utils

- (CGFloat) getSquareForUUID:(NSUInteger)uuid
{
    return [[self.cachedIdBySquare keysOfEntriesPassingTest:^BOOL(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        return [obj unsignedIntegerValue] == uuid;
    }].allObjects.firstObject floatValue];
}

- (CGFloat) getSquareForFormAttribute:(AFFormLayoutAttributes *)attribute
{
    CGFloat maxX = CGRectGetMaxX(attribute.collectionLayoutAttributes.frame);
    CGFloat maxY = CGRectGetMaxY(attribute.collectionLayoutAttributes.frame);
    
    return maxX * maxY;
}

@end
