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

typedef NS_ENUM(NSInteger, kExampleFieldsType)
{
    kExampleFieldsType_Name,
    kExampleFieldsType_Surename,
    kExampleFieldsType_Phone,
    kExampleFieldsType_Email,
    kExampleFieldsType_Birthday,
    kExampleFieldsType_IssueDate
    
};

@interface AFormExample()

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
                    [self createRowWithType:kExampleFieldsType_IssueDate]
                   ] mutableCopy];
    
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
        case kExampleFieldsType_Email:
            tfConfig = [AFTextFieldCellConfig emailTextFieldConfig];
            tfConfig.placeholder = @"Email";
            break;
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
        default:
            break;
    }
    tfConfig.borderStyle = AFTextFieldBorderUnderline;
    
    AFLayoutConfig *config = [AFLayoutConfig layoutConfigWithHeightConstrain:heightConstrain andWidthConstrain:widthConstrain];
    return [AFRow rowWithConfig:nil inputViewConfig:tfConfig layoutConfig:config];
}

@end
