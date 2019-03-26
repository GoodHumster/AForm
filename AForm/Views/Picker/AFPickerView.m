//
//  AFPickerView.m
//  AForm
//
//  Created by Administrator on 26/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import "AFPickerView.h"
#import "AFPickerConfig.h"

#import "UIScreen+AFScreenMetrics.h"

@interface AFPickerView()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, weak) id<AFPickerConfigDataSource> dataSource;

@end

@implementation AFPickerView

@synthesize output = _output;

#pragma mark - init methods

- (instancetype) init
{
    UIScreen *mainScreen = [UIScreen mainScreen];
    
    CGFloat width = CGRectGetWidth(mainScreen.bounds);
    CGFloat height = mainScreen.defaultKeyboardHeightForCurrentOrientation;
    
    if ( ( self = [super initWithFrame:CGRectMake(0, 0, width, height)]) == nil )
    {
        return nil;
    }
    [self initailize];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    if ( (self = [super initWithCoder:coder]) == nil )
    {
        return nil;
    }
    [self initailize];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( ( self = [super initWithFrame:frame]) == nil )
    {
        return nil;
    }
    [self initailize];
    return self;
}

- (void)initailize
{
    UIPickerView *pickerView = [[UIPickerView alloc] init];
    pickerView.translatesAutoresizingMaskIntoConstraints = NO;
    pickerView.backgroundColor = [UIColor clearColor];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    pickerView.showsSelectionIndicator = YES;
    
    [self addSubview:pickerView];
    self.pickerView = pickerView;
    
    [pickerView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [pickerView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
    [self.bottomAnchor constraintEqualToAnchor:pickerView.bottomAnchor].active = YES;
    [self.trailingAnchor constraintEqualToAnchor:pickerView.trailingAnchor].active = YES;
}

#pragma mark - AFTextFieldCellInputView protocol methods

+ (UIView<AFTextFieldCellInputView> *) inputView
{
    return [[AFPickerView alloc] init];
}

- (void)prepareWithConfiguration:(id<AFTextFieldCellInputViewConfig>)config
{
    AFPickerConfig *pickerConfig = (AFPickerConfig *)config;
    self.dataSource = pickerConfig.dataSource;
}

#pragma mark - UIPickerViewDataSource protocol methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.dataSource.numberOfItems;
}

#pragma mark - UIPickerViewDelegate protocol methods

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.dataSource pickerItemAtIndex:row].getRowTitle;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    id<AFPickerItem> item = [self.dataSource pickerItemAtIndex:row];
    [self.output inputViewDidChangeValue:item];
}



@end
