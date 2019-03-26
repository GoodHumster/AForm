//
//  AFCellConfig.h
//  AForm
//
//  Created by Administrator on 12/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFTextVerifier.h"
#import "AFLayoutConfig.h"

@protocol AFCellConfig <NSCopying>

@property (nonatomic, strong, readonly) NSString *identifier;
@property (nonatomic, strong) AFLayoutConfig *layoutConfig;

@property (nonatomic, assign) CGFloat minimumDependeciesInterItemSpacing;
@property (nonatomic, assign) CGFloat minimumDependeciesLineSpacing;

@end
