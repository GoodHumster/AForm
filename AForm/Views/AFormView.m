//
//  AFormView.m
//  AForm
//
//  Created by Administrator on 12/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import "AFormView.h"

#import "AFResourceManager_Private.h"
#import "AFCacheManager.h"

#import "AFCollectionViewFlowLayout.h"

#import "AFBaseCollectionViewCell.h"
#import "AFTextFieldCollectionViewCell.h"
#import "AFHeaderSectionView.h"

#import "AFFormLayoutAttributes.h"

#import "AFHeaderViewConfig.h"
#import "AFInputViewConfig.h"


@interface AFormView()<UICollectionViewDelegate,UICollectionViewDataSource,AFCollectionViewFlowLayoutDelegate, AFTextFieldCollectionViewCellOutput>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) AFCollectionViewFlowLayout *flowLayout;

@property (nonatomic, strong) id<AForm> formModel;

@property (nonatomic, strong) AFBaseCollectionViewCell *currentFocusedCell;

@property (nonatomic, strong) NSLayoutConstraint *collectionViewBottom;

@end

@implementation AFormView

#pragma mark - init methods

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
    if ( ( self = [super initWithCoder:aDecoder]) == nil )
    {
        return nil;
    }
    [self commonInit];
    return self;
}

- (instancetype) initWithFrame:(CGRect)frame
{
    if  ( ( self = [super initWithFrame:frame]) == nil )
    {
        return nil;
    }
    [self commonInit];
    return self;
}

- (instancetype) init
{
    if ( ( self = [super init]) == nil )
    {
        return nil;
    }
    [self commonInit];
    return self;
}

- (void) commonInit
{
    AFCollectionViewFlowLayout *flowLayout = [AFCollectionViewFlowLayout new];
    flowLayout.delegate = self;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    
    [self addSubview:collectionView];
    
    [collectionView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [collectionView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
    [self.trailingAnchor constraintEqualToAnchor:collectionView.trailingAnchor].active = YES;
    self.collectionViewBottom = [self.bottomAnchor constraintEqualToAnchor:collectionView.bottomAnchor];
    self.collectionViewBottom.active = YES;
    
    self.collectionView = collectionView;
    self.flowLayout = flowLayout;
    
    [self prepareCollectionView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
}

- (void) dealloc
{
    AFCacheManager *cacheManager = [AFCacheManager sharedInstance];
    
    NSLog(@"%@ deallcated",NSStringFromClass(self.class));
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [cacheManager clearAll];
}

#pragma mark - Notification handlers

- (void) keyboardWillShowNotification:(NSNotification *)aNotif
{
    NSDictionary *info = [aNotif userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    self.collectionViewBottom.constant = kbSize.height;
    [UIView animateWithDuration:0.4f animations:^{
        [self layoutIfNeeded];
    }];
    
}

- (void) keyboardWillHideNotification:(NSNotification *)aNotif
{
    self.collectionViewBottom.constant = 0.0f;
    [UIView animateWithDuration:0.4f animations:^{
        [self layoutIfNeeded];
    }];
}

#pragma mark - Public API methods

- (void)registrateNib:(UINib *)nib withIdentifier:(NSString *)identifier
{
    AFResourceManager *resourceManager = [AFResourceManager sharedInstance];
    [resourceManager registrateResourceNib:nib withKind:AFResourceManagerElementKind_Cell andIdentifier:identifier];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:identifier];
}

- (void)registarteClass:(Class)cls withIdentifier:(NSString *)identifier
{
    AFResourceManager *resourceManager = [AFResourceManager sharedInstance];
    [resourceManager registrateResourceClass:cls withKind:AFResourceManagerElementKind_Cell andIdentifier:identifier];
    [self.collectionView registerClass:cls forCellWithReuseIdentifier:identifier];
}

- (void) presentForm:(id<AForm>)form animatable:(BOOL)animatable
{
    self.formModel = form;
    [self.collectionView reloadData];
}

#pragma mark - utils methods

- (void) prepareCollectionView
{
    AFResourceManager *resourceManager = [AFResourceManager sharedInstance];

    [resourceManager enumerateClassesByIdentiferByBlock:^(__unsafe_unretained Class cls, NSString *identifier, AFResourceManagerElementKind elementKind) {
        
        if (elementKind == AFResourceManagerElementKind_Header)
        {
            [self.collectionView registerClass:cls forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identifier];
            return;
        }
        
        [self.collectionView registerClass:cls forCellWithReuseIdentifier:identifier];
    }];
    
    [resourceManager enumerateNibsByIdentifierByBlock:^(UINib *nib, NSString *identifier,AFResourceManagerElementKind elementKind) {
        
        if (elementKind == AFResourceManagerElementKind_Header)
        {
            [self.collectionView registerNib:nib forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identifier];
            return;
        }
        
        [self.collectionView registerNib:nib forCellWithReuseIdentifier:identifier];
    }];
}

#pragma mark - AFCollectionViewFlowLayoutDelegate protocol methods

- (AFLayoutConfig *) layoutConfigForHeaderAtSection:(NSUInteger)section
{
    AFSection *sc = [self.formModel getSection:section];
    
    if (!sc)
    {
        return nil;
    }
    
    return sc.layoutConfig;
}

- (AFLayoutConfig *)layoutConfigForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AFRow *row = [self.formModel getRowAtIndex:indexPath.row inSection:indexPath.section];
    
    if (!row)
    {
        return nil;
    }
    
    return row.layoutConfig;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    AFSection *sc = [self.formModel getSection:section];
    
    if (!sc)
    {
        return UIEdgeInsetsZero;
    }
    
    return sc.insets;
}


#pragma mark - UICollectionViewDelegate protocol methods

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{}

#pragma mark - UICollectionViewDataSource protocol methods

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionFooter])
    {
        return nil;
    }
    
    AFSection *section = [self.formModel getSection:indexPath.section];
    UICollectionReusableView<AFHeaderSectionView> *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:section.headerConfig.identifier forIndexPath:indexPath];
    [headerView configWithSection:section];

    return headerView;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AFRow *row = [self.formModel getRowAtIndex:indexPath.row inSection:indexPath.section];
    id<AFInputViewConfig> inputViewConig = row.inputViewConfig;
    
    UICollectionViewCell<AFCollectionViewCell> *cell = [collectionView dequeueReusableCellWithReuseIdentifier:inputViewConig.identifier forIndexPath:indexPath];
    cell.output = self;
    AFFormLayoutAttributes *formAttribute = [self.flowLayout getFormLayoutAttributesAtIndexPath:indexPath];
    [cell configWithRow:row layoutAttributes:formAttribute];
    
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [self.formModel numberOfSections];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.formModel numberOfRowsInSection:section];
}

#pragma mark - AFCollectionViewFlowLayoutDelegate protocol methods

- (void) textFieldDidBeginEditing:(AFTextFieldCollectionViewCell *)cell
{
    self.currentFocusedCell = cell;
}

- (void) textFieldDidEndEditing:(AFTextFieldCollectionViewCell *)cell
{
    self.currentFocusedCell = nil;
}

- (void)textFieldDidPressReturnKey:(AFTextFieldCollectionViewCell *)cell
{
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    NSIndexPath *nextIndexPath = [self getNextIndexPath:indexPath];
    
    if (!nextIndexPath)
    {
        return;
    }
    
    UICollectionViewCell *nextCell = [self.collectionView cellForItemAtIndexPath:nextIndexPath];
    
    if (!nextCell)
    {
        [self.collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self textFieldDidPressReturnKey:cell];
        });
        return;
    }
    
    [cell resignFirstResponder];
    [nextCell becomeFirstResponder];
}

- (void)textFieldCell:(AFTextFieldCollectionViewCell *)cell didChangeValue:(NSString *)value inRow:(AFRow *)row
{
    row.value = value;
}

- (void)textFieldCell:(AFTextFieldCollectionViewCell *)cell shouldShowAutocomplete:(UIView<AFAutocompleteView> *)view withControllBlock:(void (^)(BOOL))controllBlock
{
    AFRow *row = cell.row;
    
    if (![self.textFieldDelegate respondsToSelector:@selector(formView:forRow:shouldShowAutocomplete:withControllBlock:)])
    {
        return;
    }
    
    [self.textFieldDelegate formView:self forRow:row shouldShowAutocomplete:view withControllBlock:controllBlock];
}

#pragma mark - utils methods

- (NSIndexPath *) getNextIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger numOfRows = [self.collectionView numberOfItemsInSection:indexPath.section];
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row + 1;
    
    if (numOfRows <= row)
    {
        row = 0;
        section += 1;
        if ([self.collectionView numberOfSections] <= section)
        {
            return nil;
        }
    }
    
    return [NSIndexPath indexPathForRow:row inSection:section];
}

@end
