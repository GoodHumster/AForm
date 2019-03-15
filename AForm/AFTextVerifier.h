//
//  AFTextVerifier.h
//  AForm
//
//  Created by Administrator on 14/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AFTextOwner <NSObject>

- (NSString *) getOwnerText;

- (void) setOwnerText:(NSString *)text;

@end

@protocol AFTextVerifier <NSObject,NSCopying>

- (void) willBeginEditingText;

- (void) didBeginEditingText;

- (void) willEndEditingText;

- (void) didEndEditingText;

- (BOOL) text:(id<AFTextOwner>)textOwner shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

- (BOOL) isValidText;

@end
