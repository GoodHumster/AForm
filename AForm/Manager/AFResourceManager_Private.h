//
//  AFResourceManager_Private.h
//  AForm
//
//  Created by Administrator on 12/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import "AFResourceManager.h"

@interface AFResourceManager(Private)

- (void) enumerateNibsByIdentifierByBlock:(void(^)(UINib *nib, NSString *identifier, AFResourceManagerElementKind elementKind))enumerationBlock;

- (void) enumerateClassesByIdentiferByBlock:(void(^)(Class cls, NSString *identifier, AFResourceManagerElementKind elementKind))enumerationBlock;

@end
