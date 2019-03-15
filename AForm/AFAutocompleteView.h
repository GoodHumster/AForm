//
//  AFAutocompleteView.h
//  AForm
//
//  Created by Administrator on 14/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "AFAutocompleteViewAttributes.h"

@protocol AFAutocompleteView <NSObject>

+ (UIView<AFAutocompleteView> *) automcompleteView;

- (void) preferredAutocompleteViewAttributesFittingAttributes:(AFAutocompleteViewAttributes *)attributes;

@end
