//
//  AFForm.m
//  AForm
//
//  Created by Administrator on 27/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import <CoreFoundation/CoreFoundation.h>
#import <UIKit/UIKit.h>

#import "AFForm.h"

#import "AFIndexPathSet.h"
#import "AFIndexPath.h"

#import "AFSection.h"
#import "AFRow_Private.h"

static const void* __rowsAsKeyRetainCallback( CFAllocatorRef __unused allocator, const void *value )
{
    return CFBridgingRetain((__bridge id)(value));
}


static void __rowsAsKeyReleaseCallback( CFAllocatorRef __unused allocator, const void *value )
{
    CFBridgingRelease(value);
}

static const void* __rowsAsValueRetainCallback( CFAllocatorRef __unused allocator, const void *value )
{
    return value;
}

static void __rowsAsValueReleaseCallback( CFAllocatorRef __unused allocator, const void *value )
{
}


///**
// * Copy description callback for CF dictionary with resource provider references, used as values.
// *
// * @param value Reference to a dictionary key to describe.
// * @return Allocated and initialized key descriptive string.
// */
//static CFStringRef __providerAsValueCopyDescriptionCallBack( const void *value )
//{
//    DEBUG_ASSERTS_VALID_PROTOCOL(CoreProvider, (__bridge id)(value));
//    CFMutableStringRef descr = CFStringCreateMutable(kCFAllocatorDefault, 0);
//    if( descr )
//    {
//        const char* className = class_getName([(__bridge id<CoreProvider>)value class]);
//        CFStringAppendFormat(descr, NULL, CFSTR("%s["), className);
//        BOOL first = YES;
//        for( Class cls in [(__bridge id<CoreProvider>)value providedResourceClasses])
//        {
//            className = class_getName(cls);
//            if( first )
//            {
//                CFStringAppendCString(descr, className, kCFStringEncodingUTF8);
//                first = NO;
//            }
//            else
//            {
//                CFStringAppendFormat(descr, NULL, CFSTR(", %s"), className);
//
//            }
//        }
//        CFStringAppend(descr, CFSTR("]"));
//    }
//    return descr;
//}
//
///**
// * Copy description callback for CF dictionary with Class type references, used as keys.
// *
// * @param value Reference to a dictionary key to describe.
// * @return Allocated and initialized key descriptive string.
// */
//static CFStringRef __classAsKeyCopyDescriptionCallBack( const void *value )
//{
//    DEBUG_ASSERTS_NOT_NIL(value);
//    const char* className = class_getName((__bridge Class)value);
//    return CFStringCreateWithCString(kCFAllocatorDefault, className, kCFStringEncodingUTF8);
//}


@interface AFForm()

@property (nonatomic, weak) id<AFForming> forming;
@property (nonatomic, strong) NSMutableDictionary *rowsCountBySection;
@property (nonatomic, strong) AFIndexPathSet *indexPathSet;

/// Rows providers collection, indexed by indexPath.
@property (nonatomic, strong) CFMutableDictionaryRef __attribute__((NSObject)) rowsByIndexPath;

@end

@implementation AFForm

- (instancetype) initWithForming:(id<AFForming>)forming
{
    if ( ( self = [super init]) == nil)
    {
        return nil;
    }
    
    CFDictionaryKeyCallBacks indexPathAsKeyCallbacks = {
        .version = 0,
        .retain = __rowsAsKeyRetainCallback,
        .release = __rowsAsKeyReleaseCallback,
        .copyDescription = NULL,
        .equal = NULL,
        .hash = NULL
    };

    CFDictionaryValueCallBacks rowsAsValueCallbacks = {
        .version = 0,
        .retain = __rowsAsValueRetainCallback,
        .release = __rowsAsValueReleaseCallback,
        .copyDescription = NULL,
        .equal = NULL
    };

    CFMutableDictionaryRef dict = CFDictionaryCreateMutable(kCFAllocatorDefault, 16, &indexPathAsKeyCallbacks, &rowsAsValueCallbacks);
    self.rowsByIndexPath = dict;
    if( self.rowsByIndexPath == NULL )
    {
        return nil;
    }
    CFRelease(dict);
    
    self.indexPathSet = [[AFIndexPathSet alloc] init];
    self.forming = forming;
    self.rowsCountBySection = [NSMutableDictionary new];
    return self;
}

#pragma mark - Public API methods

- (NSUInteger)numberOfSections
{
    return [self.forming numberOfSections];
}

- (NSUInteger)numberOfRowsInSection:(NSUInteger)section
{
    if (![self.rowsCountBySection objectForKey:@(section)])
    {
        NSArray<AFRow *> *rows = [self.forming getRowsInSection:section];
        NSUInteger rowsCount = [self calculateCountOfRows:rows];
        
        if (rowsCount == NSNotFound)
        {
            return 0;
        }
        
        [self.rowsCountBySection setObject:@(rowsCount) forKey:@(section)];
    }
    
    return [[self.rowsCountBySection objectForKey:@(section)] unsignedIntegerValue];
}


- (AFRow *)getRowAtIndex:(NSUInteger)index inSection:(NSUInteger)seciton
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:seciton];
    AFRow *row = [self getCachedRowAtIndexPath:indexPath];
    
    if (!row)
    {
        row = [self getAndCacheRowAtIndexPath:indexPath];
    }
    
    return row;
}

- (AFSection *)getSection:(NSUInteger)section
{
    return  [self.forming getSection:section];
}

#pragma mark - utils methods

- (NSUInteger) calculateCountOfRows:(NSArray<AFRow *> *)rows
{
    NSInteger rowsCount = 0;
    for (AFRow *row in rows)
    {
        rowsCount += row.inputRow.attributes.numberOfRows;
    }
    
    return rowsCount;
}

- (AFRow *) getCachedRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CFDictionaryGetValue(self.rowsByIndexPath, (__bridge const void *)(indexPath));
}

- (AFRow *) getAndCacheRowAtIndexPath:(NSIndexPath *)indexPath
{
    AFIndexPath *realIndexPath = [self.indexPathSet getIntersectIndexPathFromIndexPath:indexPath];
    
    if (realIndexPath)
    {
        AFRow *row = [self getRowAtIndexPath:realIndexPath withOffset:indexPath.row];
        [self cacheRow:row atIndexPath:indexPath];
        return row;
    }
    
    NSIndexPath *nearIndexPath = [self findNearIndexPathFromIndexPath:indexPath];
    
    AFRow *row = [self.forming getRowAtIndex:nearIndexPath.row inSection:nearIndexPath.section];;
    id<AFInputRow> inputRow = row.inputRow;
    
    if (!realIndexPath)
    {
        NSUInteger numberOfRows = inputRow.attributes.numberOfRows;
        realIndexPath = [AFIndexPath indexPathWithRow:nearIndexPath.row section:nearIndexPath.section andRangeLenght:numberOfRows];
        [self.indexPathSet appendIndexPath:realIndexPath];
    }
    
     row = [self getRowAtIndexPath:realIndexPath withOffset:indexPath.row];
     [self cacheRow:row atIndexPath:indexPath];
     return row;
}

- (AFRow *) getRowAtIndexPath:(AFIndexPath *)indexPath withOffset:(NSUInteger)offset
{
     AFRow *row = [self.forming getRowAtIndex:indexPath.row inSection:indexPath.section];
     id<AFInputRow> inputRow = row.inputRow;
    
    if (inputRow.attributes.multiplie)
    {
        NSUInteger iRow = abs((int)(indexPath.minIndex - offset));
        row = [inputRow getRowAtIndex:iRow];
    }
    return row;
}

- (NSIndexPath *) findNearIndexPathFromIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *beforeIndexPath = [NSIndexPath indexPathForRow:indexPath.row-1 inSection:indexPath.section];
    AFIndexPath *beforeRealIndexPath = [self.indexPathSet getIntersectIndexPathFromIndexPath:beforeIndexPath];

    if (beforeRealIndexPath)
    {
        return [NSIndexPath indexPathForRow:beforeRealIndexPath.row+1 inSection:beforeRealIndexPath.section];
    }
    
    return indexPath;
}


- (void) cacheRow:(AFRow *)row atIndexPath:(NSIndexPath *)indexPath
{
    if (!indexPath || !row)
    {
        NSLog(@"%@ ERROR: Failed cahced row",NSStringFromClass(self.class));
        return;
    }
    
    CFDictionarySetValue(self.rowsByIndexPath, (__bridge const void *)(indexPath), (__bridge const void *)(row));
}

@end
