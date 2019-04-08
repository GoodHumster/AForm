//
//  AFIndexPath.h
//  AForm
//
//  Created by Administrator on 05/04/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AFIndexPath : NSIndexPath

@property (nonatomic, assign, readonly) NSUInteger rangeLenght;

@property (nonatomic, assign, readonly) NSUInteger minIndex;
@property (nonatomic, assign, readonly) NSUInteger maxIndex;

+ (id) indexPathWithRow:(NSUInteger)row section:(NSUInteger)section andRangeLenght:(NSUInteger)rangeLenght;

- (id) indexPathBySetRow:(NSUInteger)row;

@end

