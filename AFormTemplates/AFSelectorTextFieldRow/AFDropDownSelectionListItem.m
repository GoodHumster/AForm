//
//  AFDropDownSelectionListItem.m
//  AForm
//
//  Created by Administrator on 26/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import "AFDropDownSelectionListItem.h"

@implementation AFDropDownSelectionListItem

#pragma mark - init methods

- (instancetype) initWithTitle:(NSString *)title tag:(NSInteger)tag other:(BOOL)other
{
    if ( (self = [super init]) == nil )
    {
        return nil;
    }
    self.title = title;
    self.tag = tag;
    self.other = other;
    return self;
}

#pragma mark - AFValue protocol methods

- (NSString *) getStringValue
{
    return self.title;
}

- (NSString *) getRowTitle
{
    return self.title;
}


@end
