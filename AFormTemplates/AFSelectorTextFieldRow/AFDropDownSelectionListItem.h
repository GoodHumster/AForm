//
//  AFDropDownSelectionListItem.h
//  AForm
//
//  Created by Administrator on 26/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFPickerItem.h"

@interface AFDropDownSelectionListItem : NSObject<AFPickerItem>

@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, strong) NSString *otherDescription;
@property (nonatomic, assign) BOOL other;

- (instancetype) initWithTitle:(NSString *)title tag:(NSInteger)tag other:(BOOL)other;

@end
