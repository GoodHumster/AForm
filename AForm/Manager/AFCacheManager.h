//
//  AFCacheManager.h
//  AForm
//
//  Created by Administrator on 19/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AFCacheManager : NSObject

+ (id) sharedInstance;

- (void) cacheView:(UIView *)view forClass:(Class)cls;

- (UIView *) cachedViewForClass:(Class)cls;

- (void) clearAll;

@end
