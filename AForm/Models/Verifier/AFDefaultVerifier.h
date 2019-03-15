//
//  AFDefaultVerifier.h
//  AForm
//
//  Created by Administrator on 15/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFTextVerifier.h"

@interface AFDefaultVerifier : NSObject<AFTextVerifier>

@property (nonatomic, assign) NSUInteger maxCharecterCount;
@property (nonatomic, assign) NSUInteger minCharecterCount;

@property (nonatomic, strong) NSCharacterSet *allowedCharactersString;
@property (nonatomic, strong) NSCharacterSet *disallowedCharactersString;

@end
