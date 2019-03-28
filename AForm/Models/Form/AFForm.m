//
//  AFForm.m
//  AForm
//
//  Created by Administrator on 27/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import "AFForm.h"

#import "AFSection.h"
#import "AFRow_Private.h"

@interface AFForm()

@property (nonatomic, weak) id<AFForming> forming;
@property (nonatomic, strong) NSMutableDictionary *rowsCountBySection;
@property (nonatomic, strong) NSMutableDictionary *rowsIndexByAbsouluteIndex;

@property (nonatomic, assign) NSUInteger lastCachedAbsouluteIndex;


@end

@implementation AFForm

- (instancetype) initWithForming:(id<AFForming>)forming
{
    if ( ( self = [super init]) == nil)
    {
        return nil;
    }
    self.forming = forming;
    self.rowsIndexByAbsouluteIndex = [NSMutableDictionary new];
    self.rowsCountBySection = [NSMutableDictionary new];
    self.lastCachedAbsouluteIndex = 0;
    return self;
}



#pragma mark - Public API methods

- (NSUInteger)numberOfSections
{
    return [self.forming numberOfSections];
}

- (NSUInteger)numberOfRowsInSection:(NSUInteger)section
{
    if ([self.rowsCountBySection objectForKey:@(section)])
    {
        return [[self.rowsCountBySection objectForKey:@(section)] unsignedIntegerValue];
    }
    
    NSArray<AFRow *> *rowsInSection = [self.forming getRowsInSection:section];

    NSUInteger count = [self calculateAbsouluteNumberRows:rowsInSection];
    [self.rowsCountBySection setObject:@(count) forKey:@(section)];
    return count;
}


- (AFRow *)getRowAtIndex:(NSUInteger)index inSection:(NSUInteger)seciton
{
    NSUInteger idx = [self getRealIndexFromAbsoluteIndex:index];
    BOOL needCache = self.lastCachedAbsouluteIndex < index;
    
    AFRow *row = [self.forming getRowAtIndex:idx inSection:seciton];
    id<AFInputRow> inputRow = row.inputRow;

    if (needCache)
    {
        [self.rowsIndexByAbsouluteIndex setObject:@(idx) forKey:@(index)];
        
        NSUInteger numberOfRows = inputRow.numberOfRows - 1;
        NSUInteger absoluteIndex = index + 1;
        while (numberOfRows > 0)
        {
            [self.rowsIndexByAbsouluteIndex setObject:@(idx) forKey:@(absoluteIndex)];
            absoluteIndex += 1;
            numberOfRows -= 1;
        }
        self.lastCachedAbsouluteIndex = absoluteIndex;
    }
   
    if (inputRow.numberOfRows > 0)
    {
        NSUInteger inIndex = (self.lastCachedAbsouluteIndex - idx) + (inputRow.numberOfRows - 1);
        return [inputRow getRowAtIndex:inIndex];
    }
    
    return row;
}

- (AFSection *)getSection:(NSUInteger)section
{
    return  [self.forming getSection:section];;
}

#pragma mark - utils methods

- (NSUInteger) calculateAbsouluteNumberRows:(NSArray<AFRow *> *)rows
{
    NSArray<AFRow *> *mRowsInSection =  [rows filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.inputRow.numberOfRows > 0"]];
    NSUInteger count = rows.count - mRowsInSection.count ;
    __block NSUInteger inputRowCount = 0;
    
    [mRowsInSection enumerateObjectsUsingBlock:^(AFRow * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        inputRowCount += obj.inputRow.numberOfRows;
    }];
    
    count += inputRowCount;
    
    return count;
}

- (NSUInteger) getRealIndexFromAbsoluteIndex:(NSUInteger)index
{
    NSUInteger idx = index;
    if (self.lastCachedAbsouluteIndex > index)
    {
        idx = [[self.rowsIndexByAbsouluteIndex objectForKey:@(index)] unsignedIntegerValue];
    }
    else if (self.lastCachedAbsouluteIndex > 0)
    {
        idx = [[self.rowsIndexByAbsouluteIndex objectForKey:@(self.lastCachedAbsouluteIndex)] unsignedIntegerValue];
        idx += 1;
    }

    return idx;
}



@end
