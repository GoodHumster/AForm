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
    self.otherDescription = [NSString new];
    return self;
}

#pragma mark - AFValue protocol methods

- (NSString *) getStringValue
{
    return self.title;
}

- (id)objectByAppendValue:(id)value
{
    if ([value isKindOfClass:[self class]])
    {
        return value;
    }
        
    [self.otherDescription stringByAppendingFormat:@"%@",value];
    return self;
}

#pragma mark - AFPickerItem protocol methods

- (NSString *) getRowTitle
{
    return self.title;
}


@end
