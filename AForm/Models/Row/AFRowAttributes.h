//
//  AFRowMeta.h
//  AForm
//
//  Created by Administrator on 28/03/2019.
//  Copyright © 2019 Administrator. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFRowAttributes : NSObject

@property (nonatomic, assign) NSUInteger numberOfRows;
@property (nonatomic, assign) BOOL multiplie;

@end

//AFRow - 0                          //0
//AFRow - 1                          //1
//AFCompositeRow - 2
//    AFRow - 0                      //2
//    AFRow - 1                      //3
//    AFRow - 2                      //4
//    AFCompositeRow - 3
//        AFRow - 0                  //5
//        AFRow - 1                  //6
//        AFCompositeRow - 2
//          AFRow - 0                //7
//          AFRow - 1                //8
//AFRow - 3                          //9
//AFCompositeRow - 4                 //10
//    AFRow - 0                      //11
//    AFRow - 1                      //12
//AFRow - 5                          //13

// 2 - 0 - 3 - 0
//
// 3 - 2 - 0
// 3 - 2 - 1
// 3 - 0
// 3 - 1
// 
