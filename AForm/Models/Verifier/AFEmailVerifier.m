//
//  AFEmailNumberVerifier.m
//  AForm
//
//  Created by Administrator on 15/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import "AFEmailVerifier.h"

@interface AFEmailVerifier()

@property (nonatomic, assign) BOOL valid;

@end

@implementation AFEmailVerifier

#pragma mark - AFTextVerifier protocol methods

- (BOOL) text:(id<AFTextOwner>)textOwner shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return YES;
}

- (BOOL)isValidText:(NSString *)text
{
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailRegEx];
    return [predicate evaluateWithObject:text];
}

#pragma mark - NSCopying protocol methods

- (id) copyWithZone:(NSZone *)zone
{
    AFEmailVerifier *other = [AFEmailVerifier new];
    other.valid = self.valid;
    
    return other;
}

@end
