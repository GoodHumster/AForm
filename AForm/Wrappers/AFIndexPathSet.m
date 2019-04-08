//
//  AFIndexPathSet.m
//  AForm
//
//  Created by Administrator on 05/04/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

/*
    0
    1,   2(2-4),  3,   4(4-7),  8,    9
  (1-1)  (2-4)  (3-3)  (4-7)  (8-8) (9-9)
    1      4      5      8      8    10
 
    1
    1,   2(2-4),  3,   4(4-7),  8,    9
    (1-1)  (2-4)  (3-3)  (4-7)  (8-8) (9-9)
 */

#import "AFIndexPathSet.h"
#import "AFIndexPath_Private.h"

@interface AFIndexPathAttribute : NSObject<NSCoding, NSCopying>

@property (nonatomic, assign) NSUInteger minIndex;
@property (nonatomic, assign) NSUInteger maxIndex;

@property (nonatomic, assign) NSUInteger section;
@end

@implementation AFIndexPathAttribute

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
    if ( (self = [super init]) == nil )
    {
        return nil;
    }
    self.maxIndex = [[aDecoder valueForKey:@"maxIndex"] integerValue];
    self.minIndex = [[aDecoder valueForKey:@"minIndex"] integerValue];
    self.section = [[aDecoder valueForKey:@"section"] integerValue];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeInteger:self.maxIndex forKey:@"maxIndex"];
    [coder encodeInteger:self.minIndex forKey:@"minIndex"];
    [coder encodeInteger:self.section forKey:@"section"];
}

- (id)copyWithZone:(NSZone *)zone
{
    AFIndexPathAttribute *copy = [AFIndexPathAttribute new];
    copy.maxIndex = self.maxIndex;
    copy.minIndex = self.minIndex;
    copy.section = self.section;
    
    return copy;
}

- (BOOL) isEqual:(id)object
{
    AFIndexPathAttribute *range = (AFIndexPathAttribute *)object;
    return range.minIndex == self.minIndex &&
           range.maxIndex == self.maxIndex &&
           range.section == self.section;
}

- (NSUInteger) hash
{
    return self.minIndex + self.maxIndex + self.section;
}

@end

@interface AFIndexPathSet()

@property (nonatomic, assign) NSUInteger count;
@property (nonatomic, strong) NSMutableSet *indexPathsSet;

@property (nonatomic, assign) NSUInteger offset;

@end

@implementation AFIndexPathSet

- (instancetype) init
{
    if ( ( self = [super init]) == nil )
    {
        return nil;
    }
    self.indexPathsSet = [NSMutableSet set];
    self.offset = 0;
    return self;
}

- (void) appendIndexPath:(AFIndexPath *)indexPath
{
    NSUInteger rangeLenght = indexPath.rangeLenght - 1;
    indexPath.minIndex = self.offset > 0 ? self.offset : indexPath.row;
    indexPath.maxIndex = self.offset > 0 ? rangeLenght + self.offset : indexPath.row + rangeLenght;
    
    if (indexPath.rangeLenght > 0)
    {
        self.offset = indexPath.maxIndex + 1;
    }
    
    [self.indexPathsSet addObject:indexPath];
    self.count += 1;
}

- (AFIndexPath *)getIntersectIndexPathFromIndexPath:(NSIndexPath *)indexPath
{
    __block AFIndexPath *intersectIndexPath = nil;
    [self.indexPathsSet objectsWithOptions:NSEnumerationConcurrent passingTest:^BOOL(id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        AFIndexPath *ip = (AFIndexPath *)obj;
        
        if (ip.section != indexPath.section)
        {
            return NO;
        }
        
        BOOL intersect = ip.minIndex <= indexPath.row && ip.maxIndex >= indexPath.row;
        
        if (intersect)
        {
            intersectIndexPath = obj;
            *stop = YES;
        }
        
        return intersect;
    }];
    
    return intersectIndexPath;
}


@end