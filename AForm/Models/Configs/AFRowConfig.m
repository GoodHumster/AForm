//
//  AFRowConfig.m
//  AForm
//
//  Created by Administrator on 12/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import "AFRowConfig.h"

@implementation AFRowConfig

+ (id) rowConfigWithKey:(NSString *)key value:(id)value
{
    AFRowConfig *config = [AFRowConfig new];
    config.key = key;
    config.value = value;
    
    return config;
}

@end
