//
//  AFIndexPathSet.h
//  AForm
//
//  Created by Administrator on 05/04/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AFIndexPath;

@interface AFIndexPathSet : NSObject

@property (nonatomic, assign, readonly) NSUInteger count;

- (void) appendIndexPath:(AFIndexPath *)indexPath;
- (AFIndexPath *) getIntersectIndexPathFromIndexPath:(NSIndexPath *)indexPath;

@end

