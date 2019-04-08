//
//  AFIndexPath.m
//  AForm
//
//  Created by Administrator on 05/04/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import "AFIndexPath_Private.h"

@interface AFIndexPath()

@property (nonatomic, assign) NSUInteger rangeLenght;

@end

@implementation AFIndexPath

+ (id) indexPathWithRow:(NSUInteger)row section:(NSUInteger)section andRangeLenght:(NSUInteger)rangeLenght
{
    AFIndexPath *indexPath = [super indexPathForRow:row inSection:section];
    indexPath.rangeLenght = rangeLenght;
    
    return indexPath;
}

- (id) indexPathBySetRow:(NSUInteger)row
{
    AFIndexPath *indexPath = [AFIndexPath indexPathWithRow:row section:self.section andRangeLenght:self.rangeLenght];
    return indexPath;
}

- (BOOL) isEqual:(id)object
{
    AFIndexPath *other = (AFIndexPath *)object;
    
    BOOL equal = YES;
    equal &= other.minIndex == self.minIndex;
    equal &= other.maxIndex == self.maxIndex;
    equal &= other.section == self.section;
    equal &= other.row == self.row;
    
    return equal;
}

- (NSUInteger) hash
{
    return self.minIndex + self.maxIndex + self.section + self.row;
}

@end

