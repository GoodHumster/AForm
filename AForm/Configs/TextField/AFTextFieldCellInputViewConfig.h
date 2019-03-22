//
//  AFTextFieldCellInputViewConfig.h
//  AForm
//
//  Created by Administrator on 19/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AFTextFieldCellInputView;

@protocol AFTextFieldCellInputViewConfig <NSCopying>

@property (nonatomic, assign) Class<AFTextFieldCellInputView> inputViewClass;

@end
