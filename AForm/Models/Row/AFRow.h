//
//  AFRow.h
//  AForm
//
//  Created by Administrator on 12/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AFRowConfig;
@class AFLayoutConfig;

@protocol AFInputViewConfig;


@interface AFRow : NSObject
{
    @private
    NSString *identifier;
}

@property (nonatomic, strong, readonly) NSString *key;

@property (nonatomic, strong) id value;

@property (nonatomic, strong) id<AFInputViewConfig> inputViewConfig;

@property (nonatomic, strong) AFLayoutConfig *layoutConfig;

+ (id) rowWithConfig:(AFRowConfig *)rowConfig inputViewConfig:(id<AFInputViewConfig>)ivConfig layoutConfig:(AFLayoutConfig *)layoutConfig;

+ (id) rowWithKey:(NSString *)key value:(id)value andIdentifier:(NSString *)identifier;

+ (id) rowWithKey:(NSString *)key andIdentifier:(NSString *)identifier;

@end
