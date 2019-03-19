//
//  AFDefaultVerifier.m
//  AForm
//
//  Created by Administrator on 15/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import "AFDefaultVerifier.h"

@implementation AFDefaultVerifier

- (instancetype) init
{
    if ( (self = [super init]) == nil )
    {
        return nil;
    }
    
    self.minCharecterCount = 0;
    self.maxCharecterCount = NSUIntegerMax;
    self.allowedCharactersString = nil;
    self.disallowedCharactersString = nil;
    
    return self;
}

#pragma mark - NSCopying protocol methods

- (id)copyWithZone:(NSZone *)zone
{
    AFDefaultVerifier *copy = [AFDefaultVerifier new];
    copy.maxCharecterCount = self.maxCharecterCount;
    copy.minCharecterCount = self.minCharecterCount;
    copy.allowedCharactersString = self.allowedCharactersString;
    copy.disallowedCharactersString = self.disallowedCharactersString;
    
    return copy;
}

#pragma mark - AFTextVerifier protocol methods

- (void) willBeginEditingText
{}

- (void) didBeginEditingText
{}

- (void) willEndEditingText
{}

- (void) didEndEditingText
{}

- (BOOL) text:(id<AFTextOwner>)textOwner shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *text = [textOwner getOwnerText];
    text = [text stringByReplacingCharactersInRange:range withString:string];
    
    return [self validateText:text];
}

- (BOOL) isValidText:(NSString *)text
{
    return [self validateText:text];
}

#pragma mark - utils methods

- (BOOL) validateText:(NSString *)text
{
    BOOL valid = YES;
    
    if (self.allowedCharactersString)
    {
        valid &= [text rangeOfCharacterFromSet:self.allowedCharactersString].location != NSNotFound;
    }
    
    if (self.disallowedCharactersString)
    {
        valid &= [text rangeOfCharacterFromSet:self.disallowedCharactersString].location == NSNotFound;
    }
    
    if (self.maxCharecterCount != NSUIntegerMax)
    {
        valid &= (text.length <= self.maxCharecterCount);
    }
    
    if (self.minCharecterCount > 0)
    {
        valid &= text.length >= self.minCharecterCount;
    }
    
    return valid;
}

@end
