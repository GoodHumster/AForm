//
//  AFMultiplieRow.h
//  AForm
//
//  Created by Administrator on 28/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFInputRow.h"

@interface AFMultiplieRow : NSObject<AFInputRow>

+ (id) multiplieRowWithRows:(NSArray<AFRow *> *)rows andKey:(NSString *)key;

@end

