//
//  AFMultiplieRow.h
//  AForm
//
//  Created by Administrator on 28/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFInputRow.h"

@interface AFMultiplieRow : AFInputRow

+ (id) multiplieRowWithRows:(NSArray<AFRow *> *)rows andKey:(NSString *)key;

@end

