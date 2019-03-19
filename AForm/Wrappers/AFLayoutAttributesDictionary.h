//
//  AFLayoutAttributesDictionary.h
//  AForm
//
//  Created by Administrator on 13/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class AFFormLayoutAttributes;
@class AFLayoutAttributesArray;

@interface AFLayoutAttributesDictionary : NSObject


- (AFFormLayoutAttributes *) getFormAttributeById:(NSUInteger)uuid;
- (AFFormLayoutAttributes *) getFormAttributeByIndexPath:(NSIndexPath *)indexPath;
- (NSArray<AFFormLayoutAttributes *> *) getFormAttributeInRect:(CGRect)rect;

- (void) cacheFormAttribute:(AFFormLayoutAttributes *)attribute;
- (void) replaceFormAttribute:(AFFormLayoutAttributes *)attribute;

- (AFFormLayoutAttributes *) lastFormAttribute;
- (AFFormLayoutAttributes *) firtFormAttribute;

- (void) enumerateFormAttributeStartFrom:(NSUInteger)uuid wihtBlock:(void(^)(AFFormLayoutAttributes *formAttribute))enumerationBlock;

- (BOOL) isFilledRect:(CGRect)rect;
- (BOOL) isEmpty;

- (void) clear;

@end
