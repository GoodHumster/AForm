//
//  AFSelectorTextFieldRow.m
//  AForm
//
//  Created by Administrator on 26/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import "AFDropDownSelectionListRow.h"

#import "AFPickerConfig.h"

static NSString *const kAFDropDownSelectionListRowIdentifier = @"AFDropDownSelectionListRowIdentifier";

@interface AFDropDownSelectionListRow() <AFPickerConfigDataSource>
@end

@implementation AFDropDownSelectionListRow

@synthesize cellConfig = _cellConfig;

#pragma mark - init methods

- (instancetype) initWithKey:(NSString *)key andIdentifier:(NSString *)identifier
{
    if ( ( self = [super initWithKey:key andIdentifier:identifier]) == nil )
    {
        return nil;
    }
    
    AFLayoutConstraint *widht = [AFLayoutConstraint constrainWithMultiplie:1.0 andConstant:AFLayoutConstraintAutomaticDimension andEstimate:0.0f];
    AFLayoutConstraint *height = [AFLayoutConstraint constrainWithMultiplie:1.0 andConstant:50 andEstimate:0.0f];
    
    AFPickerConfig *pickerConfig = [AFPickerConfig new];
    pickerConfig.dataSource = self;

    AFTextFieldCellConfig *tfConfig = [AFTextFieldCellConfig defaultTextFieldConfig];
    tfConfig.placeholder = @"Select answer";
    tfConfig.inputViewConfig = pickerConfig;
    tfConfig.layoutConfig = [AFLayoutConfig layoutConfigWithHeightConstrain:height andWidthConstrain:widht];
    
    self.cellConfig = tfConfig;
    
    
    return self;
}

#pragma mark - Public API methods

+ (id) rowWithKey:(NSString *)key andTextViewConfig:(AFTextViewCellConfig *)textViewConfig
{
    return [self rowWithKey:key andLayoutConfig:nil andTextViewConfig:textViewConfig];
}

+ (id) rowWithKey:(NSString *)key andLayoutConfig:(AFLayoutConfig *)layoutConfig andTextViewConfig:(AFTextViewCellConfig *)textViewConfig
{
    AFDropDownSelectionListRow *row = [[AFDropDownSelectionListRow alloc] initWithKey:key andIdentifier:kAFDropDownSelectionListRowIdentifier];
    
    if (layoutConfig)
    {
        row.cellConfig.layoutConfig = layoutConfig;
    }
  
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.row.value.other == YES"];
    [row.cellConfig addDependencyConfig:textViewConfig withShowPredicate:predicate];
    
    return row;
}

#pragma mark - AFPickerConfigDataSource protocol methods

- (NSInteger)numberOfItems
{
    return [self.dataSource numberOfItems];
}

- (id<AFPickerItem>)pickerItemAtIndex:(NSInteger)index
{
    return [self.dataSource dropDownListItemAtIndex:index];
}

@end
