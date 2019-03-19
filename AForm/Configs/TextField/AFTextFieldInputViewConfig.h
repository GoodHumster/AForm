//
//  AFTextFieldInputViewConfig.h
//  AForm
//
//  Created by Administrator on 19/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AFTextFieldInputView;

@protocol AFTextFieldInputViewConfig <NSCopying>

@property (nonatomic, assign) Class<AFTextFieldInputView> inputViewClass;

@end
