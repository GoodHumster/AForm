//
//  AFLayoutConfig.h
//  AForm
//
//  Created by Administrator on 12/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

const CGFloat AFLayoutConstraintAutomaticDimension = CGFLOAT_MAX;

@interface AFLayoutConstraint: NSObject

@property (nonatomic, assign) CGFloat multiplie;

@property (nonatomic, assign) CGFloat constant;

@property (nonatomic, assign) CGFloat estimate;

+ (id) constrainWithMultiplie:(CGFloat)multiplie andConstant:(CGFloat)constant andEstimate:(CGFloat)estimate;

@end

@implementation AFLayoutConstraint

+ (id) constrainWithMultiplie:(CGFloat)multiplie andConstant:(CGFloat)constant
{
    AFLayoutConstraint *constraint = [AFLayoutConstraint new];
    constraint.multiplie = multiplie;
    constraint.constant = constant;
    
    return constraint;
}

@end

@interface AFLayoutConfig : NSObject

@property (nonatomic, assign) AFLayoutConstraint *height;
@property (nonatomic, assign) AFLayoutConstraint *width;

+ (id) layoutConfigWithHeightConstrain:(AFLayoutConstraint *)heightConstraint
               andWidthConstrain:(AFLayoutConstraint *)widthConstraint;

@end

