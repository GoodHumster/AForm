//
//  AFTestForm.m
//  AFormTest
//
//  Created by Administrator on 28/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import "AFTestForm.h"



@interface AFTestForm()

@property (nonatomic, strong) NSArray *rows;

@end

@implementation AFTestForm

#pragma mark - Form create methods

+ (id<AFForming>)singleRowOnlyForm
{
    AFTestForm *testForm = [AFTestForm new];
    testForm.rows = @[
                      [self createSingleRow],
                      [self createSingleRow],
                      [self createSingleRow],
                      [self createSingleRow]
                    ];
    
    return testForm;
}

+ (id<AFForming>)compositeRowForm
{
    AFTestForm *testForm = [AFTestForm new];
    testForm.rows = @[
                       [self createSingleRow],  //0
                       [self createSingleRow],  //1
                       [self createCompositeRowWithCountSingleRows:3], //2,3,4
                       [self createSingleRow],  //5
                       [self createCompositeRowWithDifferentRows] //6,7,8,9,10
                     ];
    return testForm;
}

#pragma mark - Row create methods

+ (AFRow *) createSingleRow
{
    return [AFRow rowWithKey:[[NSUUID UUID] UUIDString] inputViewConfig:nil layoutConfig:nil];
}

+ (AFRow *) createCompositeRowWithCountSingleRows:(NSInteger)numberOfRows
{
    return [AFRow compositeRowWithKey:@"2" withRows:[self createSingleRowsCount:numberOfRows]];
}

+ (AFRow *) createCompositeRowWithDifferentRows
{
    NSArray *differentRows = @[
                               [self createSingleRow],
                               [self createSingleRow],
                               [self createCompositeRowWithCountSingleRows:3]
                              ];
    
    return [AFRow compositeRowWithKey:@"2" withRows:differentRows];
}

+ (AFRow *) createMultiplieRowWithCountSingleRows:(NSInteger)numberOfRows
{
    return [AFRow multiplieRowWithKey:@"3" withRows:[self createSingleRowsCount:numberOfRows]];
}

+ (AFRow *) createMultiplieRowWithDifferentRows
{
    NSArray *differentRows = @[
                               [self createSingleRow],
                               [self createSingleRow],
                               [self createCompositeRowWithCountSingleRows:3],
                               [self createMultiplieRowWithCountSingleRows:3]
                              ];
    
    return [AFRow multiplieRowWithKey:@"3" withRows:differentRows];
}

#pragma mark - utils methods

+ (NSArray *) createSingleRowsCount:(NSUInteger)count
{
    NSMutableArray *inputRows = [NSMutableArray new];
    
    for (NSInteger i = 0; i < count; i++)
    {
        [inputRows addObject:[self createSingleRow]];
    }
    
    return [inputRows copy];
}

#pragma mark - AFForming protocol methods

- (NSUInteger) numberOfSections
{
    return 1;
}

- (NSArray<AFRow *> *) getRowsInSection:(NSUInteger)section
{
    return self.rows;
}

- (AFRow *) getRowAtIndex:(NSUInteger)row inSection:(NSUInteger)seciton
{
    return [self.rows objectAtIndex:row];
}

- (AFSection *) getSection:(NSUInteger)section
{
    return nil;
}


@end
