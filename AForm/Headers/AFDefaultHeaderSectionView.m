//
//  AFDefaultHeaderSectionViewCell.m
//  AForm
//
//  Created by Administrator on 14/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import "AFDefaultHeaderSectionView.h"

#import "AFResourceManager_Private.h"

#import "AFHeaderViewConfig.h"
#import "AFSection.h"

NSString *const kAFDefaultHeaderSectionViewIdentifier = @"AFDefaultHeaderSectionViewCellIdentifier";


@interface AFDefaultHeaderSectionView()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation AFDefaultHeaderSectionView

+ (void) load
{
    AFResourceManager *resourceManager = [AFResourceManager sharedInstance];
    [resourceManager registrateResourceClass:[AFDefaultHeaderSectionView class] withKind:AFResourceManagerElementKind_Header andIdentifier:kAFDefaultHeaderSectionViewIdentifier];
}

#pragma mark - init methods

- (instancetype) init
{
    if ( (self = [super init]) == nil )
    {
        return nil;
    }
    
    [self commonInit];
    return self;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
    if ( (self = [super initWithCoder:aDecoder]) == nil )
    {
        return nil;
    }
    
    [self commonInit];
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame
{
    if ( (self = [super initWithFrame:frame]) == nil)
    {
        return nil;
    }
    
    [self commonInit];
    return self;
}

- (void) commonInit
{
    UILabel *titleLabel = [UILabel new];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.backgroundColor = [UIColor clearColor];
    
    self.titleLabel = titleLabel;
    [self addSubview:titleLabel];
    
    [titleLabel.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [titleLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
    [self.trailingAnchor constraintEqualToAnchor:titleLabel.trailingAnchor].active = YES;
    [self.bottomAnchor constraintEqualToAnchor:titleLabel.bottomAnchor].active = YES;
}

#pragma mark - AFBaseHeaderSectionViewCell override method

- (void) configWithSection:(AFSection *)section
{
    id<AFHeaderViewConfig> config = section.headerConfig;
    [self applyConfig:config];
    
    id value = section.value;
    [self setupValue:value];
}

#pragma mark - utils

- (void) applyConfig:(id<AFHeaderViewConfig>)config
{
    
}

- (void) setupValue:(id)value
{
    if (![value isKindOfClass:[NSString class]])
    {
        return;
    }
    
    self.titleLabel.text = value;
}

@end
