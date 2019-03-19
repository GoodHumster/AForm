//
//  AFEmailNumberVerifier.h
//  AForm
//
//  Created by Administrator on 15/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFTextVerifier.h"

@interface AFEmailVerifier : NSObject<AFTextVerifier>

@property (nonatomic, assign, readonly) BOOL valid;

@end

