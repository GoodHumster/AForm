//
//  AFTextField.h
//  AForm
//
//  Created by Administrator on 15/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class AFTextFieldCellConfig;
@class AFTextFieldCollectionViewCell;

@protocol AFTextField <NSObject>

@property (nonatomic, weak) AFTextFieldCollectionViewCell *parentCell;

+ (UITextField<AFTextField> *) textFieldWithConfig:(AFTextFieldCellConfig *)config andSetDelegate:(id<UITextFieldDelegate>)delegate;

- (void) textFieldChangeTextVereficationState:(BOOL)state;

@end
