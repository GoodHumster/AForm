//
//  AFormExample.m
//  AFormSample
//
//  Created by Administrator on 15/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import "AFormExample.h"
#import <AForm/AFTextFieldCellConfig.h>
#import <AForm/AFDatePickerConfig.h>
#import <AForm/AFLayoutConfig.h>
#import <AForm/AFLabelCellConfig.h>
#import <AForm/AFTextViewCellConfig.h>
#import <AForm/AFDropDownSelectionListRow.h>

typedef NS_ENUM(NSInteger, kExampleFieldsType)
{
    kExampleFieldsType_Name,
    kExampleFieldsType_Surename,
    kExampleFieldsType_Phone,
    kExampleFieldsType_Email,
    kExampleFieldsType_Birthday,
    kExampleFieldsType_IssueDate,
    kExampleFieldsType_TextView,
    kExampleFieldsType_Questionary
    
};

@interface AFormExample()<AFDropDownSelectionListRowDataSource>


@property (nonatomic, strong) NSArray *dropDownList;
@property (nonatomic, strong) NSMutableArray *source;

@end

@implementation AFormExample

- (instancetype) init
{
    if ( (self = [super init]) == nil )
    {
        return nil;
    }
    
    self.source = [@[
                    [self createRowWithType:kExampleFieldsType_Name],
                    [self createRowWithType:kExampleFieldsType_Surename],
                    [self createRowWithType:kExampleFieldsType_Email],
                    [self createRowWithType:kExampleFieldsType_Phone],
                    [self createRowWithType:kExampleFieldsType_Birthday],
                    [self createRowWithType:kExampleFieldsType_IssueDate],
                    [self createRowWithType:kExampleFieldsType_TextView],
                    [self createRowWithType:kExampleFieldsType_Questionary]
                   ] mutableCopy];
    
    self.dropDownList = @[
                          [self itemWithTitle:@"1 Вариант" tag:1 other:NO],
                          [self itemWithTitle:@"2 Вариант" tag:1 other:NO],
                          [self itemWithTitle:@"3 Вариант" tag:1 other:NO],
                          [self itemWithTitle:@"4 Вариант" tag:1 other:NO],
                          [self itemWithTitle:@"5 Вариант" tag:1 other:NO],
                          [self itemWithTitle:@"Другой" tag:1 other:YES]
                        ];
    
    return self;
}

- (NSUInteger) numberOfSections
{
    return 1;
}

- (NSUInteger) numberOfRowsInSection:(NSUInteger)section
{
    return self.source.count;
}

- (AFSection *)getSection:(NSUInteger)section
{
    return nil;
}

- (AFRow *)getRowAtIndex:(NSUInteger)row inSection:(NSUInteger)seciton
{
    return [self.source objectAtIndex:row];
}

#pragma mark - utils

- (AFRow *) createRowWithType:(kExampleFieldsType)type
{
    AFTextFieldCellConfig *tfConfig = [AFTextFieldCellConfig defaultTextFieldConfig];
    AFLayoutConstraint *heightConstrain = [AFLayoutConstraint constrainWithMultiplie:1.0 andConstant:44 andEstimate:0];;
    AFLayoutConstraint *widthConstrain =  [AFLayoutConstraint constrainWithMultiplie:1.0 andConstant:AFLayoutConstraintAutomaticDimension andEstimate:0];
    AFDatePickerConfig *datePickerConfig = [AFDatePickerConfig new];
    datePickerConfig.dateFormmat = @"dd.MM.YYYY";
    datePickerConfig.pickerMode = UIDatePickerModeDate;
    
    switch (type) {
        case kExampleFieldsType_Name:
            widthConstrain = [AFLayoutConstraint constrainWithMultiplie:0.5 andConstant:AFLayoutConstraintAutomaticDimension andEstimate:0];
            tfConfig.placeholder = @"Имя";
            break;
        case kExampleFieldsType_Surename:
        {
            widthConstrain = [AFLayoutConstraint constrainWithMultiplie:0.5 andConstant:AFLayoutConstraintAutomaticDimension andEstimate:0];
            tfConfig.placeholder = @"Фамилия";
            break;
        }
        case kExampleFieldsType_Email:
        {
            tfConfig = [AFTextFieldCellConfig emailTextFieldConfig];
            tfConfig.placeholder = @"Email";
            AFLabelCellConfig *config = [AFLabelCellConfig new];
            config.textColor = [UIColor purpleColor];
            config.font = [UIFont systemFontOfSize:15];
            config.aligment = NSTextAlignmentLeft;
            config.editable = NO;
            config.defaultText = @"Данные необходимы для получения информации из Бюро кредитных историй";
            config.layoutConfig = [AFLayoutConfig layoutConfigWithHeightConstrain:[AFLayoutConstraint constrainWithMultiplie:1.0 andConstant:20 andEstimate:0] andWidthConstrain: [AFLayoutConstraint constrainWithMultiplie:1.0 andConstant:AFLayoutConstraintAutomaticDimension andEstimate:0]];
            
            
            [tfConfig addAlwaysShowDependencyConfig:config];
            
            break;
        }
        case kExampleFieldsType_Phone:
            tfConfig.placeholder = @"phone";
            break;
        case kExampleFieldsType_Birthday:
            tfConfig.placeholder = @"birthday";
            tfConfig.inputViewConfig = datePickerConfig;
            break;
        case kExampleFieldsType_IssueDate:
            datePickerConfig.dateFormmat = @"dd.MM.YYYY HH:mm:ss";
            datePickerConfig.pickerMode = UIDatePickerModeDateAndTime;
            tfConfig.placeholder = @"issue date";
            tfConfig.inputViewConfig = datePickerConfig;
            break;
        case kExampleFieldsType_TextView:
        {
            AFTextViewCellConfig *tvConfig = [AFTextViewCellConfig defaultTextViewConfig];
            heightConstrain.constant = 100;
            tvConfig.borderStyle = AFTextInputBorderUnderline;
            AFLayoutConfig *config = [AFLayoutConfig layoutConfigWithHeightConstrain:heightConstrain andWidthConstrain:widthConstrain];
            return [AFRow rowWithConfig:nil inputViewConfig:tvConfig layoutConfig:config];;
        }
        case kExampleFieldsType_Questionary:
        {
            heightConstrain.constant = 100;
            AFTextViewCellConfig *config = [AFTextViewCellConfig defaultTextViewConfig];
            config.borderStyle = AFTextInputBorderUnderline;
            config.layoutConfig = [AFLayoutConfig layoutConfigWithHeightConstrain:heightConstrain andWidthConstrain:widthConstrain];
            
            AFDropDownSelectionListRow *row = [AFDropDownSelectionListRow rowWithKey:@"Test" andTextViewConfig:config];
            row.dataSource = self;
            return row;
        }
        default:
            break;
    }
    tfConfig.borderStyle = AFTextInputBorderUnderline;
    
    AFLayoutConfig *config = [AFLayoutConfig layoutConfigWithHeightConstrain:heightConstrain andWidthConstrain:widthConstrain];
    return [AFRow rowWithConfig:nil inputViewConfig:tfConfig layoutConfig:config];
}

- (AFDropDownSelectionListItem *) itemWithTitle:(NSString *)title tag:(NSInteger)tag other:(BOOL)other
{
    return [[AFDropDownSelectionListItem alloc] initWithTitle:title tag:tag other:other];
}

#pragma mark - AFDropDownSelectionListRowDataSource protocol methods

- (NSInteger)numberOfItems
{
    return self.dropDownList.count;
}

- (AFDropDownSelectionListItem *)dropDownListItemAtIndex:(NSInteger)index
{
    return [self.dropDownList objectAtIndex:index];
}

@end
