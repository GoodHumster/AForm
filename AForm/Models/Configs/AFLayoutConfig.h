//
//  AFLayoutConfig.h
//  AForm
//
//  Created by Administrator on 12/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static CGFloat const AFLayoutConstraintAutomaticDimension = CGFLOAT_MAX;

@interface AFLayoutConstraint: NSObject<NSCopying>

@property (nonatomic, assign) CGFloat multiplie;

@property (nonatomic, assign) CGFloat constant;

@property (nonatomic, assign) CGFloat estimate;

+ (id) constrainWithMultiplie:(CGFloat)multiplie andConstant:(CGFloat)constant andEstimate:(CGFloat)estimate;

@end


@interface AFLayoutConfig : NSObject<NSCopying>

@property (nonatomic, strong) AFLayoutConstraint *height;
@property (nonatomic, strong) AFLayoutConstraint *width;

+ (id) layoutConfigWithHeightConstrain:(AFLayoutConstraint *)heightConstraint
               andWidthConstrain:(AFLayoutConstraint *)widthConstraint;

@end

