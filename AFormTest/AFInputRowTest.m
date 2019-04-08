//
//  AFInputRowTest.m
//  AFormTest
//
//  Created by Administrator on 03/04/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "AFSingleRow.h"
#import "AFCompositeRow.h"
#import "AFMultiplieRow.h"

#import "AFRow.h"
#import "AFRow_Private.h"
#import "AFForm.h"

#import "AFTestForm.h"

@interface AFInputRowTest : XCTestCase

@end

@implementation AFInputRowTest


- (void)test001_CreateSingleRow
{
    AFRow *row = [AFRow rowWithKey:@"1" inputViewConfig:nil layoutConfig:nil];
    XCTAssertNotNil(row.inputRow);
    XCTAssertTrue([row.inputRow isKindOfClass:[AFSingleRow class]]);
}

- (void)test002_CreateCompositeRow
{
    AFRow *row = [AFRow compositeRowWithKey:@"1" withRows:nil];
    XCTAssertNotNil(row.inputRow);
    XCTAssertTrue([row.inputRow isKindOfClass:[AFCompositeRow class]]);
}

- (void)test003_CreateMulitplieRow
{
    AFRow *row = [AFRow multiplieRowWithKey:@"1" withRows:nil];
    XCTAssertNotNil(row.inputRow);
    XCTAssertTrue([row.inputRow isKindOfClass:[AFMultiplieRow class]]);
}

- (void)test004_GetAndCheckSingleRowAttributes
{
    AFRow *row = [AFRow rowWithKey:@"1" inputViewConfig:nil layoutConfig:nil];
    AFRowAttributes *attributes = row.inputRow.attributes;
    
    XCTAssertNotNil(attributes);
    XCTAssertTrue(attributes.numberOfRows == 1);
    XCTAssertTrue(!attributes.multiplie);
}

- (void)test004_GetAndCheckCompositeRowAttributes
{
    AFRow *row = [AFTestForm createCompositeRowWithCountSingleRows:4];
    AFRowAttributes *attributes = row.inputRow.attributes;
    
    XCTAssertNotNil(attributes);
    XCTAssertTrue(attributes.numberOfRows == 4);
    XCTAssertTrue(attributes.multiplie);
}

- (void)test005_GetAndCheckMultiplieRowAttributes
{
    AFRow *row = [AFTestForm createMultiplieRowWithCountSingleRows:4];
    AFRowAttributes *attributes = row.inputRow.attributes;
    
    XCTAssertNotNil(attributes);
    XCTAssertTrue(attributes.numberOfRows == 4);
    XCTAssertTrue(attributes.multiplie);
}

#pragma mark - utils

@end
