//
//  AFLabelCellConfig.m
//  AForm
//
//  Created by Administrator on 25/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import "AFLabelCellConfig.h"
#import "AFLabelCollectionViewCell.h"

@interface AFLabelCellConfig()

@property (nonatomic, strong) NSString *identifier;

@end

@implementation AFLabelCellConfig

@synthesize identifier = _identifier;

- (instancetype)init
{
    if ( (self = [super init]) == nil )
    {
        return nil;
    }
    
    self.identifier = kAFLabelCollectionViewCellIdentifier;
    self.editable = YES;
    self.defaultText = nil;
    return self;
}



@end
