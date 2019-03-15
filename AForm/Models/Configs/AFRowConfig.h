//
//  AFRowConfig.h
//  AForm
//
//  Created by Administrator on 12/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AFRowConfig : NSObject

@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) id value;

+ (id) rowConfigWithKey:(NSString *)key value:(id)value;

@end

NS_ASSUME_NONNULL_END
