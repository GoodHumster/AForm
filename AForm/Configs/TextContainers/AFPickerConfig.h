//
//  AFPickerConfig.h
//  AForm
//
//  Created by Administrator on 26/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "AFTextFieldCellInputViewConfig.h"
#import "AFValue.h"
#import "AFPickerItem.h"

@protocol AFPickerConfigDataSource <NSObject>

- (NSInteger) numberOfItems;

- (id<AFPickerItem>) pickerItemAtIndex:(NSInteger)index;

@end

@interface AFPickerConfig : NSObject<AFTextFieldCellInputViewConfig>

@property (nonatomic, weak) id<AFPickerConfigDataSource> dataSource;

@end
