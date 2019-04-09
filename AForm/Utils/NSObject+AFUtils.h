//
//  NSObject+AFUtils.h
//  AForm
//
//  Created by Administrator on 09/04/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NSObject_AFUtils <NSObject>

- (id) af_objectAsClass:(Class)cls;

- (id) af_objectAsProto:(Protocol *)proto;

@end

@interface NSObject (AFUtils)<NSObject_AFUtils>
@end

