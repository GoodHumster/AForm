//
//  AFAutocompleteView.h
//  AForm
//
//  Created by Administrator on 14/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "AFValue.h"


@protocol AFAutocompleteViewDelegate <NSObject>

- (void) formAutocompleteDidSelectValue:(id<AFValue>)value;
- (void) formAutocompleteSetHeight:(CGFloat)height;

- (void) formAutocompleteHide;

@end

@protocol AFAutocompleteView <NSObject>

@required

@property (nonatomic, weak) id<AFAutocompleteViewDelegate> delegate;

+ (UIView<AFAutocompleteView> *) autocompleteViewWithDelegate:(id<AFAutocompleteViewDelegate>)delegate;

- (CGFloat) preferredAutocompleteViewHeight;



@end
