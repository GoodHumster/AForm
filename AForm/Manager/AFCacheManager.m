//
//  AFCacheManager.m
//  AForm
//
//  Created by Administrator on 19/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import "AFCacheManager.h"
#import <objc/runtime.h>
#import <CoreFoundation/CoreFoundation.h>


/**
 * Key retain callback for CF dictionary with provider references, used as keys.
 *
 * @param allocator Allocator to use for memory operations.
 * @param value Reference to a dictionary key to retain.
 * @return Retained reference to a dictionary key.
 */
static const void* __providerAsKeyRetainCallback( CFAllocatorRef __unused allocator, const void *value )
{
    return CFBridgingRetain((__bridge id)(value));
}

/**
 * Key release callback for CF dictionary with provider references, used as keys.
 *
 * @param allocator Allocator to use for memory operations.
 * @param value Reference to a dictionary key to release.
 */
static void __providerAsKeyReleaseCallback( CFAllocatorRef __unused allocator, const void *value )
{
    CFBridgingRelease(value);
}

/**
 * Copy description callback for CF dictionary with resource provider references, used as values.
 *
 * @param value Reference to a dictionary key to describe.
 * @return Allocated and initialized key descriptive string.
 */
//static CFStringRef __providerAsValueCopyDescriptionCallBack( const void *value )
//{
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

/**
 * Copy description callback for CF dictionary with Class type references, used as keys.
 *
 * @param value Reference to a dictionary key to describe.
 * @return Allocated and initialized key descriptive string.
 */
static CFStringRef __classAsKeyCopyDescriptionCallBack( const void *value )
{
    const char* className = class_getName((__bridge Class)value);
    return CFStringCreateWithCString(kCFAllocatorDefault, className, kCFStringEncodingUTF8);
}

@interface AFCacheManager()

/// Resource providers collection, indexed by resource class.
@property (nonatomic, strong) CFMutableDictionaryRef __attribute__((NSObject)) resouceProviderByClass;

@end


@implementation AFCacheManager

+ (id) sharedInstance
{
    static AFCacheManager *_sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [AFCacheManager new];
    });
    
    return _sharedInstance;
}

- (instancetype) init
{
    if ( ( self = [super init]) == nil )
    {
        return nil;
    }
    
    CFDictionaryKeyCallBacks classAsKeyCallbacks = {
        .version = 0,
        .retain = NULL,
        .release = NULL,
        .copyDescription = __classAsKeyCopyDescriptionCallBack,
        .equal = NULL,
        .hash = NULL
    };
    
    CFDictionaryValueCallBacks providerAsValueCallbacks = {
        .version = 0,
        .retain = __providerAsKeyRetainCallback,
        .release = __providerAsKeyReleaseCallback,
        .copyDescription = NULL,
        .equal = NULL
    };
    
    CFMutableDictionaryRef dict = CFDictionaryCreateMutable(kCFAllocatorDefault, 16, &classAsKeyCallbacks, &providerAsValueCallbacks);
    self.resouceProviderByClass = dict;
    
    if( self.resouceProviderByClass == NULL )
    {
        return nil;
    }
    CFRelease(dict);
    
    return self;
}

#pragma mark - Public API methods

- (void)cacheView:(UIView *)view forClass:(Class)cls
{
    if (!view || !cls)
    {
        return;
    }
    
    if (CFDictionaryGetValue(self.resouceProviderByClass, (__bridge const void *)cls) != NULL)
    {
        CFDictionaryRemoveValue(self.resouceProviderByClass, (__bridge const void *)cls);
    }
    
    NSError *error = nil;
    NSData *data = nil;
    if (@available(iOS 11.0, *))
    {
       data = [NSKeyedArchiver archivedDataWithRootObject:view requiringSecureCoding:NO error:&error];
    }
    else
    {
        data = [NSKeyedArchiver archivedDataWithRootObject:view];
    }
    
    if (error || !data)
    {
        return;
    }
    
    CFDictionarySetValue(self.resouceProviderByClass, (__bridge const void *)cls, (__bridge const void *)data);
}

- (UIView *)cachedViewForClass:(Class)cls
{
    if (!cls)
    {
        return nil;
    }
    
    NSData *data = CFDictionaryGetValue(self.resouceProviderByClass, (__bridge const void *)cls);
    
    if (!data)
    {
        return nil;
    }
    
    UIView *v = nil;
    NSError *error = nil;
    
    if (@available(iOS 11.0, *))
    {
        NSKeyedUnarchiver *keyUnarchive = [[NSKeyedUnarchiver alloc] initForReadingFromData:data error:&error];
        keyUnarchive.requiresSecureCoding = NO;
        keyUnarchive.decodingFailurePolicy = NSDecodingFailurePolicySetErrorAndReturn;
        v = [keyUnarchive decodeObjectForKey:NSKeyedArchiveRootObjectKey];
        [keyUnarchive finishDecoding];
    }
    else
    {
        v = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    
    return v;
}

- (void)clearAll
{
    CFDictionaryRemoveAllValues(self.resouceProviderByClass);
}


@end
