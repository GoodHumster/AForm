//
//  AFormView.h
//  AForm
//
//  Created by Administrator on 12/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AForm.h"

@protocol AFAutocompleteView;
@class AFormView;

@protocol AFormViewDelegate <NSObject>

- (void) formView:(AFormView *)formView didChangeValue:(id)value atIndexPath:(NSIndexPath *)inedxPath;

- (void) formView:(AFormView *)formView didSelectedRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol AFormViewTextFieldDelegate <NSObject>

- (void)formView:(AFormView *)view forRow:(AFRow *)row shouldShowAutocomplete:(UIView<AFAutocompleteView> *)autocompelteView withControllBlock:(void (^)(BOOL))controllBlock;

@end


@interface AFormView : UIView

@property (nonatomic, weak) id<AFormViewDelegate> delegate;
@property (nonatomic, weak) id<AFormViewTextFieldDelegate> textFieldDelegate;

@property (nonatomic, assign) BOOL hideKeyboardOnScroll;

@property (nonatomic, strong) UIView *headerView;

@property (nonatomic, strong) UIView *footerView;

- (void) presentForm:(id<AForm>)form animatable:(BOOL)animatable;

- (void) registrateNib:(UINib *)nib withIdentifier:(NSString *)identifier;

- (void) registarteClass:(Class)cls withIdentifier:(NSString *)identifier;

@end
