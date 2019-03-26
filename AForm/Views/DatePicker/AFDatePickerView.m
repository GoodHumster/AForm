//
//  AFDatePicker.m
//  AForm
//
//  Created by Administrator on 18/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import "AFDatePickerView.h"

#import "AFDatePickerConfig.h"

#import "UIScreen+AFScreenMetrics.h"

@interface AFDatePickerView()

@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation AFDatePickerView

@synthesize output = _output;

- (instancetype) init
{
    UIScreen *mainScreen = [UIScreen mainScreen];
    CGFloat width = CGRectGetWidth(mainScreen.bounds);
    CGFloat height = mainScreen.defaultKeyboardHeightForCurrentOrientation;
    
    if ( ( self = [super initWithFrame:CGRectMake(0, 0, width, height)]) == nil )
    {
        return nil;
    }
    [self commonInit];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    if ( (self = [super initWithCoder:coder]) == nil )
    {
        return nil;
    }
    self.datePicker = [coder decodeObjectForKey:@"datePicker"];
    self.dateFormatter = [coder decodeObjectForKey:@"dateFormatter"];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [super encodeWithCoder:coder];
    [coder encodeObject:self.datePicker forKey:@"datePicker"];
    [coder encodeObject:self.dateFormatter forKey:@"dateFormatter"];
}

- (void) commonInit
{
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.translatesAutoresizingMaskIntoConstraints = NO;
    datePicker.backgroundColor = [UIColor clearColor];
    
    [self addSubview:datePicker];
    
    [datePicker.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [datePicker.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
    [self.trailingAnchor constraintEqualToAnchor:datePicker.trailingAnchor].active = YES;
    [self.bottomAnchor constraintEqualToAnchor:datePicker.bottomAnchor].active = YES;
    
    self.datePicker = datePicker;
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateFormat = @"dd.MM.YYYY";
}

#pragma mark - Public API methods

+ (UIView<AFTextFieldCellInputView> *) inputView
{
    return [[AFDatePickerView alloc] init];
}

- (void) prepareWithConfiguration:(id<AFTextFieldCellInputViewConfig>)config
{
    AFDatePickerConfig *datePickerConfig = (AFDatePickerConfig *)config;
    self.datePicker.minimumDate = datePickerConfig.minDate;
    self.datePicker.maximumDate = datePickerConfig.maxDate;
    self.datePicker.datePickerMode = datePickerConfig.pickerMode;
    self.dateFormatter.dateFormat = datePickerConfig.dateFormmat;
 
    [self.  datePicker addTarget:self action:@selector(didPickerChangeValue:) forControlEvents:UIControlEventValueChanged];
    
}

#pragma mark - NSSecureCoding protocol methods

+ (BOOL)supportsSecureCoding
{
    return YES;
}

#pragma mark - Action methods

- (void) didPickerChangeValue:(id)sender
{
    NSDate *date = self.datePicker.date;
    NSString *dateString = [self.dateFormatter stringFromDate:date];
    
    [self.output inputViewDidChangeValue:dateString];
}

@end
