//
//  AFTextFieldCellInputView.h
//  AForm
//
//  Created by Administrator on 15/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AFTextFieldCellInputViewConfig.h"
#import "AFValue.h"


@protocol AFTextFieldCellInputViewOutput <NSObject>

- (void) inputViewDidChangeValue:(id<AFValue>)value;

@end

@protocol AFTextFieldCellInputView <NSObject,NSCoding>

@required

@property (nonatomic, weak) id<AFTextFieldCellInputViewOutput> output;

+ (UIView<AFTextFieldCellInputView> *) inputView;

- (void) prepareWithConfiguration:(id<AFTextFieldCellInputViewConfig>) config;

@end
