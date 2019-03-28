//
//  AFForm.h
//  AForm
//
//  Created by Administrator on 27/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFForming.h"

@interface AFForm : NSObject

- (instancetype) initWithForming:(id<AFForming>)forming;

- (NSUInteger) numberOfSections;
- (NSUInteger) numberOfRowsInSection:(NSUInteger)section;

- (AFRow *) getRowAtIndex:(NSUInteger)index inSection:(NSUInteger)seciton;
- (AFSection *) getSection:(NSUInteger)section;

@end

