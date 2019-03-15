//
//  AFHeaderViewConfig.h
//  AForm
//
//  Created by Administrator on 14/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, kAFSectionHeaderType)
{
    kAFSectionHeaderType_System,
    kAFSectionHeaderType_Custom
};

@protocol AFHeaderViewConfig <NSObject>

@property (nonatomic, assign, readonly) kAFSectionHeaderType headerType;

@property (nonatomic, strong, readonly) NSString *identifier;

@end
