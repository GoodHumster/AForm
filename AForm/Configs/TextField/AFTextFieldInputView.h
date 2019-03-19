//
//  AFTextFieldInputView.h
//  AForm
//
//  Created by Administrator on 15/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AFTextFieldInputViewConfig.h"



@protocol AFTextFieldInputViewOutput <NSObject>

- (void) inputViewDidChangeValue:(NSString *)value;

@end

@protocol AFTextFieldInputView <NSObject,NSCoding>

@required

@property (nonatomic, weak) id<AFTextFieldInputViewOutput> output;

+ (UIView<AFTextFieldInputView> *) inputView;

- (void) prepareWithConfiguration:(id<AFTextFieldInputViewConfig>) config;

@end
