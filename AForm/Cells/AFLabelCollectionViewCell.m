//
//  AFLabelCollectionViewCell.m
//  AForm
//
//  Created by Administrator on 25/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import "AFLabelCollectionViewCell.h"

#import "AFFormLayoutAttributes.h"
#import "AFLabelCellConfig.h"

#import "AFResourceManager.h"

NSString *const kAFLabelCollectionViewCellIdentifier = @"AFLabelCollectionViewCellIdentifier";

@interface AFLabelCollectionViewCell()

@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation AFLabelCollectionViewCell

@synthesize output = _output;
@synthesize config = _config;

#pragma mark - init methods

+ (void) load
{
    AFResourceManager *resourceManager = [AFResourceManager sharedInstance];
    [resourceManager registrateResourceClass:[AFLabelCollectionViewCell class] withKind:AFResourceManagerElementKind_Cell andIdentifier:kAFLabelCollectionViewCellIdentifier];
}

- (instancetype)init
{
    if ( (self = [super init]) == nil )
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
    [self commonInit];
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( (self = [super initWithFrame:frame]) == nil )
    {
        return nil;
    }
    [self commonInit];
    return self;
}

- (void)commonInit
{
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.translatesAutoresizingMaskIntoConstraints = NO;

    [self.contentView addSubview:textLabel];
    self.textLabel = textLabel;
    
    [self.textLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor].active = YES;
    [self.textLabel.leadingAnchor constraintEqualToAnchor:self.contentView.leadingAnchor].active = YES;
    [self.contentView.bottomAnchor constraintEqualToAnchor:self.textLabel.bottomAnchor].active = YES;
    [self.contentView.trailingAnchor constraintEqualToAnchor:self.textLabel.trailingAnchor].active = YES;
}

#pragma mark - AFBaseCollectionViewCell protocol methods

- (void)configWithRow:(id<AFCellRow>)row andConfig:(id<AFCellConfig>)config
{
    [super configWithRow:row andConfig:config];
    self.backgroundColor = [UIColor clearColor];
    
    AFLabelCellConfig *cellConfig = self.config;

    [self setupConfiguration:cellConfig];
    
    if (cellConfig.editable)
    {
        self.textLabel.text = [row.cellValue getStringValue];
    }
    
    CGSize sizeToFit = [self.textLabel sizeThatFits:self.frame.size];
    CGFloat height = sizeToFit.height;
    self.height = height;
}

#pragma mark - utils methods

- (void) setupConfiguration:(AFLabelCellConfig *)config
{
    self.textLabel.textColor = config.textColor;
    self.textLabel.textAlignment = config.aligment;
    self.textLabel.font = config.font;
    self.textLabel.numberOfLines = config.numberOfLines;
    self.textLabel.lineBreakMode = config.lineBreakMode;
    self.textLabel.text = config.defaultText;
}

@end
