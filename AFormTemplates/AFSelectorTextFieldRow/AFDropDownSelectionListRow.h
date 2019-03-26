//
//  AFSelectorTextFieldRow.h
//  AForm
//
//  Created by Administrator on 26/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import "AFRow.h"
#import "AFDropDownSelectionListItem.h"
#import "AFTextFieldCellConfig.h"
#import "AFTextViewCellConfig.h"

@protocol AFDropDownSelectionListRowDataSource <NSObject>

- (NSInteger) numberOfItems;

- (AFDropDownSelectionListItem *)dropDownListItemAtIndex:(NSInteger)index;

@end

@interface AFDropDownSelectionListRow : AFRow

@property (nonatomic, weak) id<AFDropDownSelectionListRowDataSource> dataSource;

@property (nonatomic, strong) AFTextFieldCellConfig *cellConfig;

+ (id) rowWithKey:(NSString *)key andTextViewConfig:(AFTextViewCellConfig *)textViewConfig;
+ (id) rowWithKey:(NSString *)key andLayoutConfig:(AFLayoutConfig *)layoutConfig andTextViewConfig:(AFTextViewCellConfig *)textViewConfig;

@end

