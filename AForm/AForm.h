//
//  AForm.h
//  AForm
//
//  Created by Administrator on 11/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFRow.h"
#import "AFSection.h"

@protocol AForm <NSObject>

- (NSUInteger) numberOfSections;

- (NSUInteger) numberOfRowsInSection:(NSUInteger)section;

- (AFRow *) getRowAtIndex:(NSUInteger)row inSection:(NSUInteger)seciton;

- (AFSection *) getSection:(NSUInteger)section;

@end
