//
//  AFTextInputContentView.h
//  AForm
//
//  Created by Administrator on 25/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AFAutocompleteView;

@interface AFTextInputContentView : UIView

@property (nonatomic, assign) UIEdgeInsets textContainerInsets;
@property (nonatomic, assign) CGFloat underlineViewHeight;

@property (nonatomic, strong) UIView *underlineView;
@property (nonatomic, strong) UIView<AFAutocompleteView> *autocompleteView;

- (void) addTextField:(UIView *)view;

- (void) addAutocomopleteView:(UIView *)view;

@end
