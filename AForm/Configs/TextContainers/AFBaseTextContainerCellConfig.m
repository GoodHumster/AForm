//
//  AFBaseTextContainerCellConfig.m
//  AForm
//
//  Created by Administrator on 25/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import "AFBaseTextContainerCellConfig.h"

@interface AFBaseTextContainerCellConfig()

@property (nonatomic, strong) NSString *identifier;

@end

@implementation AFBaseTextContainerCellConfig

@synthesize identifier = _identifier;

- (instancetype) init
{
    if  ( (self = [super init]) == nil )
    {
        return nil;
    }
    
    self.inputViewConfig = nil;
    self.haveAutocomplete = NO;
    self.identifier = nil;
    self.font = [UIFont systemFontOfSize:15];
    self.backgroundColor = [UIColor whiteColor];
    self.textColor = [UIColor blackColor];
    self.borderColor = [UIColor lightGrayColor];
    self.borderWidth = 1;
    self.insets = UIEdgeInsetsZero;
    
    return self;
}

#pragma mark - NSCopying protocol methods

- (id) copyWithZone:(NSZone *)zone
{
    AFBaseTextContainerCellConfig *copy = [super copyWithZone:zone];
    copy.inputViewConfig = [(id)self.inputViewConfig copy];
    copy.haveAutocomplete = self.haveAutocomplete;
    copy.autocompleteViewClass = self.autocompleteViewClass;
    copy.textAlignment = self.textAlignment;
    copy.identifier = self.identifier;
    copy.font = self.font;
    copy.backgroundColor = self.backgroundColor;
    copy.textColor = self.textColor;
    copy.backgroundColor = self.backgroundColor;
    copy.borderColor = self.borderColor;
    copy.borderWidth = self.borderWidth;
    copy.borderStyle = self.borderStyle;
    copy.verifier = [(id)self.verifier copy];
    copy.insets = self.insets;
    
    return copy;
}

@end
