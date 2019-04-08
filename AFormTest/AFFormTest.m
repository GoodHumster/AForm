//
//  AFFormTest.m
//  AFormTest
//
//  Created by Administrator on 28/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "AFTestForm.h"

#import "AFSingleRow.h"
#import "AFCompositeRow.h"
#import "AFMultiplieRow.h"

#import "AFRow.h"
#import "AFRow_Private.h"
#import "AFForm.h"


@interface AFFormTest : XCTestCase

@end

@implementation AFFormTest


- (void) test001_CountOfRowsAndSectionInSingleRowsOnlyForm
{
    AFTestForm *signleRowsForming = [AFTestForm singleRowOnlyForm];
    AFForm *form = [[AFForm alloc] initWithForming:signleRowsForming];
    
    XCTAssertTrue([form numberOfRowsInSection:0] == 4);
    XCTAssertTrue([form numberOfSections] == 1);
}

- (void) test002_CountOfRowsAndSectionInSingleAndCompositeRowsForm
{
    AFTestForm *compositeRowsForming = [AFTestForm compositeRowForm];
    AFForm *form = [[AFForm alloc] initWithForming:compositeRowsForming];
    
    XCTAssertTrue([form numberOfSections] == 1);
    XCTAssertTrue([form numberOfRowsInSection:0] == 11);
}

- (void)test003_GetRowFromSingleRowsOnlyForm
{
    AFTestForm *signleRowsForming = [AFTestForm singleRowOnlyForm];
    AFForm *form = [[AFForm alloc] initWithForming:signleRowsForming];
    [self assertToAquireSingleRowFromForm:form];
}

- (void)test004_GetRowFromSingleAndCompositeRowsForm
{
    AFTestForm *compositeRowsForming = [AFTestForm compositeRowForm];
    AFForm *form = [[AFForm alloc] initWithForming:compositeRowsForming];
    [self assertToAquireSingleRowFromForm:form];
}

- (void)test005_PerfomanceEnumerateCompositeRowsFrom
{
    AFTestForm *compositeRowsForming = [AFTestForm compositeRowForm];
    AFForm *form = [[AFForm alloc] initWithForming:compositeRowsForming];
    
    [self measureBlock:^{
         [self assertToAquireSingleRowFromForm:form];
    }];
}

#pragma mark - utils

- (void) assertToAquireSingleRowFromForm:(AFForm *)form
{
    __block NSString *prevKey = nil;
    [self enumeratForm:form withBlock:^(NSInteger idx, NSInteger section, AFRow *row) {
        XCTAssertTrue(![prevKey isEqualToString:row.key]);
        XCTAssertTrue([row.inputRow isKindOfClass:[AFSingleRow class]]);
        prevKey = row.key;
    }];
}

- (void) enumeratForm:(AFForm *)form withBlock:(void(^)(NSInteger idx, NSInteger section, AFRow *row))enumerationBlock
{
    NSUInteger numberOfSection = form.numberOfSections;
    for (NSUInteger sectionIdx = 0; sectionIdx < numberOfSection; sectionIdx++)
    {
        NSUInteger numberOfRows = [form numberOfRowsInSection:sectionIdx];
        
        if (numberOfRows == NSNotFound)
        {
            continue;
        }
        
        for (NSUInteger rowIdx = 0; rowIdx < numberOfRows; rowIdx++)
        {
            AFRow *row = [form getRowAtIndex:rowIdx inSection:sectionIdx];
            if (enumerationBlock)
            {
                enumerationBlock(rowIdx,sectionIdx,row);
            }
        }
    }
}


@end
