//
//  AFResourceManager.h
//  AForm
//
//  Created by Administrator on 12/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, AFResourceManagerElementKind){
    AFResourceManagerElementKind_Header = 0,
    AFResourceManagerElementKind_Cell
};

@interface AFResourceManager : NSObject

+ (id) sharedInstance;

- (void) registrateResourceNib:(UINib * __nonnull)nib withKind:(AFResourceManagerElementKind)kind andIdentifier:(NSString * __nonnull)identifier;

- (void) registrateResourceClass:(Class __nonnull)cls withKind:(AFResourceManagerElementKind)kind andIdentifier:(NSString * __nonnull)identifier;

@end
