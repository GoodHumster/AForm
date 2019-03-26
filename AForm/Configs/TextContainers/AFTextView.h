//
//  AFTextView.h
//  AForm
//
//  Created by Administrator on 25/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class AFTextViewCellConfig;

@protocol AFTextView <NSObject>

+ (UITextView<AFTextView> *) textFieldWithConfig:(AFTextViewCellConfig *)config andSetDelegate:(id<UITextViewDelegate>)delegate;

- (void) textFieldChangeTextVereficationState:(BOOL)state;

@end
