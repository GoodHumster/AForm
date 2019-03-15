//
//  AFRow_Private.h
//  AForm
//
//  Created by Administrator on 12/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import "AFRow.h"

@protocol AFRowOutput <NSObject>

- (void) didUpdateRowValue;

@end

@interface AFRow()

@property (nonatomic, weak) id<AFRowOutput> output;

@end
