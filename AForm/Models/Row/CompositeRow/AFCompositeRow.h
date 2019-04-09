//
//  AFCompositeRow.h
//  AForm
//
//  Created by Administrator on 27/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFInputRow.h"

@interface AFCompositeRow : AFInputRow

+ (id) rowCompositeWithRows:(NSArray<AFRow *> *)rows andKey:(NSString *)key;

@end

