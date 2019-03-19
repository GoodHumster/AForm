//
//  AFormExample.m
//  AFormSample
//
//  Created by Administrator on 15/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import "AFormExample.h"
#import <AForm/AFTextFieldConfig.h>
#import <AForm/AFDatePickerConfig.h>
#import <AForm/AFLayoutConfig.h>

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
    
//    for (NSInteger index = 0; index < 50; index++)
//    {
//        NSString *indexSTR = [NSString stringWithFormat:@"Field %ld",index];
//        AFRow *row = [self createRowWithType:kExampleFieldsType_Phone];
//        AFTextFieldConfig *config = (AFTextFieldConfig *)row.inputViewConfig;
//        config.placeholder = indexSTR;
//
//        [self.source addObject:row];
//    }
    
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
    AFTextFieldConfig *tfConfig = [AFTextFieldConfig defaultTextFieldConfig];
    AFLayoutConstraint *heightConstrain = [AFLayoutConstraint constrainWithMultiplie:1.0 andConstant:44 andEstimate:0];;
    AFLayoutConstraint *widthConstrain =  [AFLayoutConstraint constrainWithMultiplie:1.0 andConstant:kAFAutocompletViewHeightAutomaticDemision andEstimate:0];
    AFDatePickerConfig *datePickerConfig = [AFDatePickerConfig new];
    datePickerConfig.dateFormmat = @"dd.MM.YYYY";
    datePickerConfig.pickerMode = UIDatePickerModeDate;
    
    switch (type) {
        case kExampleFieldsType_Name:
            widthConstrain = [AFLayoutConstraint constrainWithMultiplie:0.5 andConstant:kAFAutocompletViewHeightAutomaticDemision andEstimate:0];
            tfConfig.placeholder = @"Имя";
            break;
        case kExampleFieldsType_Surename:
            widthConstrain = [AFLayoutConstraint constrainWithMultiplie:0.5 andConstant:kAFAutocompletViewHeightAutomaticDemision andEstimate:0];
            tfConfig.placeholder = @"Фамилия";
            break;
        case kExampleFieldsType_Email:
            tfConfig.placeholder = @"email";
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
    
    AFLayoutConfig *config = [AFLayoutConfig layoutConfigWithHeightConstrain:heightConstrain andWidthConstrain:widthConstrain];
    return [AFRow rowWithConfig:nil inputViewConfig:tfConfig layoutConfig:config];
}

@end
