//
//  AFSection.m
//  AForm
//
//  Created by Administrator on 12/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import "AFSection.h"

@interface AFSection()

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSArray *rows;

@end

@implementation AFSection

#pragma mark - init methods

- (instancetype) init
{
   if ( ( self = [super init]) == nil )
   {
       return nil;
   }
   return self;
}

#pragma mark - Public API methods

//+ (id) sectionWithTitle:(NSString *)title andHeaderType:(kAFSectionHeaderType)headerType
//{
//    AFSection *section = [AFSection new];
//    section.title = title;
//    section.headerType = headerType;
//    section.rows = [NSArray new];
//    
//    return section;
//}
//
//+ (id) sectionWithTitle:(NSString *)title andHeaderType:(kAFSectionHeaderType)headerType layoutConfig:(AFLayoutConfig *)layoutConfig
//{
//    AFSection *section = [AFSection new];
//    section.title = title;
//    section.headerType = headerType;
//    section.rows = [NSArray new];
//    section.layoutConfig = layoutConfig;
//    
//    return section;
//}

- (void) addRow:(AFRow *)row
{
    self.rows = [self.rows arrayByAddingObject:row];
}

- (void)addRows:(NSArray *)rows
{
    self.rows = [self.rows arrayByAddingObjectsFromArray:rows];
}

@end
