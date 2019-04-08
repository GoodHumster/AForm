//
//  AFIndexPathSetTest.m
//  AFormTest
//
//  Created by Administrator on 05/04/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "AFIndexPathSet.h"
#import "AFIndexPath.h"

@interface AFIndexPathSetTest : XCTestCase

@end

@implementation AFIndexPathSetTest


- (void)test001_CreateIndexesLayout
{
    AFIndexPathSet *indexPathSet = [[AFIndexPathSet alloc] init];
    XCTAssertNotNil(indexPathSet);
}

- (void)test002_AddIndexAtSectionWithRange
{
    AFIndexPathSet *indexPathSet = [self createIndexPathRangeSet];
    NSUInteger count = indexPathSet.count;
    XCTAssertTrue(count == 6);
}

- (void) test003_GetIndexPathForRowAtSection
{
    AFIndexPathSet *indexPathSet = [self createIndexPathRangeSet];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:7 inSection:0];
    AFIndexPath *intersectIndexPath = [indexPathSet getIntersectIndexPathFromIndexPath:indexPath];
    
    XCTAssertNotNil(intersectIndexPath);
    XCTAssertTrue(intersectIndexPath.rangeLenght == 3);
    XCTAssertTrue(intersectIndexPath.row == 4);
    XCTAssertTrue(intersectIndexPath.section == 0);
}

- (void) test004_PerfomanceAddingIndexPaths
{
    [self measureBlock:^{
        AFIndexPathSet *indexPathSet = [self createIndexPathRangeSet];
        
        for (NSUInteger idx = 0; idx < 1000; idx++)
        {
            AFIndexPath *indexPath = [AFIndexPath indexPathWithRow:idx+5 section:0 andRangeLenght:3];
            [indexPathSet appendIndexPath:indexPath];
        }
    }];
}

- (void) test005_PreformanceGetIntersectPaths
{
    AFIndexPathSet *indexPathSet = [self createIndexPathRangeSet];
    
    for (NSUInteger idx = 0; idx < 1000; idx++)
    {
        AFIndexPath *indexPath = [AFIndexPath indexPathWithRow:idx+5 section:0 andRangeLenght:3];
        [indexPathSet appendIndexPath:indexPath];
    }
    
    [self measureBlock:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:7 inSection:0];
        AFIndexPath *intersectIndexPath = [indexPathSet getIntersectIndexPathFromIndexPath:indexPath];
        
        XCTAssertNotNil(intersectIndexPath);
        XCTAssertTrue(intersectIndexPath.rangeLenght == 3);
        XCTAssertTrue(intersectIndexPath.row == 4);
        XCTAssertTrue(intersectIndexPath.section == 0);
    }];
}

#pragma mark - utils methods

- (AFIndexPathSet *) createIndexPathRangeSet
{
    AFIndexPathSet *indexPathSet = [[AFIndexPathSet alloc] init];
    [indexPathSet appendIndexPath:[AFIndexPath indexPathWithRow:0 section:0 andRangeLenght:1]]; // 0
    [indexPathSet appendIndexPath:[AFIndexPath indexPathWithRow:1 section:0 andRangeLenght:1]]; // 1
    [indexPathSet appendIndexPath:[AFIndexPath indexPathWithRow:2 section:0 andRangeLenght:3]]; // 2,3,4
    [indexPathSet appendIndexPath:[AFIndexPath indexPathWithRow:3 section:0 andRangeLenght:2]]; // 5,6
    [indexPathSet appendIndexPath:[AFIndexPath indexPathWithRow:4 section:0 andRangeLenght:3]]; // 7,8,9
    [indexPathSet appendIndexPath:[AFIndexPath indexPathWithRow:5 section:0 andRangeLenght:2]]; // 10,11
    
    
    return indexPathSet;
}



@end
