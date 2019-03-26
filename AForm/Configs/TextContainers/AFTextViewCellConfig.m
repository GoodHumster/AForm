//
//  AFTextViewCellConfig.m
//  AForm
//
//  Created by Administrator on 25/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import "AFTextViewCellConfig.h"
#import "AFTextViewCollectionViewCell.h"

#import "AFDefaultVerifier.h"
#import "AFEmailVerifier.h"
#import "AFPhoneNumberVerifier.h"
#import "AFRussianPassportVerifier.h"

@interface AFTextViewCellConfig()

@property (nonatomic, strong) NSString *identifier;

@end

@implementation AFTextViewCellConfig

@synthesize identifier = _identifier;
@synthesize minimumDependeciesLineSpacing = _minimumDependeciesLineSpacing;
@synthesize minimumDependeciesInterItemSpacing = _minimumDependeciesInterItemSpacing;

- (instancetype) init
{
    if ( ( self = [super init]) == nil )
    {
        return nil;
    }
    self.identifier = kAFTextViewCollectionViewCellIdentifier;
    self.textViewClass = nil;
    return self;
}

+ (id)defaultTextViewConfig
{
    AFTextViewCellConfig *config = [AFTextViewCellConfig new];
    config.verifier = [AFDefaultVerifier new];
    config.keyboardKeyType = UIKeyboardTypeDefault;
    config.borderStyle = AFTextInputBorderLine;
    
    return config;
}

#pragma mark - NSCopying protocol methods

- (id)copyWithZone:(NSZone *)zone
{
    AFTextViewCellConfig *config = [super copyWithZone:zone];
    config.textViewClass = self.textViewClass;
    
    return config;
}


@end
