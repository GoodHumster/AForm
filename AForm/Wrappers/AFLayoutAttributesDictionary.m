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

@property (nonatomic, assign) CGFloat sumSquare;


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
    
    CGFloat count = (CGFloat)self.cachedIdBySquare.count;
    CGFloat neededSquare = CGRectGetMaxX(rect) * CGRectGetMaxY(rect);
    CGFloat middleSquare = self.maxSquare / count;
    
    NSInteger minIdx = roundf(neededSquare / middleSquare);
    NSInteger maxIdx = roundf(neededSquare*count/self.sumSquare) + minIdx;
    
    NSArray<NSNumber *> *cachedIdxs = [self.cachedIdBySquare.allValues subarrayWithRange:NSMakeRange(minIdx, maxIdx-minIdx)];
    
    NSMutableArray *mAttibutes = [NSMutableArray new];
    for (NSNumber *idx in cachedIdxs)
    {
        [mAttibutes addObject:[self.cachedAttributesById objectForKey:idx]];
    }
    
    return [mAttibutes copy];
}

- (AFFormLayoutAttributes *)getFormAttributeByIndexPath:(NSIndexPath *)indexPath
{
    return [self.cachedIdByIndexPath objectForKey:indexPath];
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
    
    self.maxSquare = square;
    self.sumSquare += square;
}

- (AFFormLayoutAttributes *)lastFormAttribute
{
    return [self.cachedAttributesById.allValues lastObject];
}

- (AFFormLayoutAttributes *)firtFormAttribute
{
    return [self.cachedAttributesById.allKeys firstObject];
}

- (void)enumerateFormAttributeStartFrom:(NSUInteger)uuid wihtBlock:(void (^)(AFFormLayoutAttributes *))enumerationBlock
{
    NSSet<NSNumber *>* keys = [self.cachedAttributesById keysOfEntriesWithOptions:NSEnumerationConcurrent passingTest:^BOOL(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSUInteger keyUuid = [key unsignedIntegerValue];
        return keyUuid > uuid;
    }];
    
    [keys enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, BOOL * _Nonnull stop) {
        
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

- (CGFloat) getSquareForFormAttribute:(AFFormLayoutAttributes *)attribute
{
    CGFloat maxX = CGRectGetMaxX(attribute.collectionLayoutAttributes.frame);
    CGFloat maxY = CGRectGetMaxY(attribute.collectionLayoutAttributes.frame);
    
    return maxX * maxY;
}

@end
