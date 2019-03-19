//
//  AFTextField.h
//  AForm
//
//  Created by Administrator on 15/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class AFTextFieldConfig;

@protocol AFTextField <NSObject>

+ (UITextField<AFTextField> *) textFieldWithConfig:(AFTextFieldConfig *)config andSetDelegate:(id<UITextFieldDelegate>)delegate;

@end
