//
//  YBPermissionVideoWorker.h
//  DDKuaiqian
//
//  Created by asance on 2017/11/17.
//  Copyright © 2017年 asance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBPermissionVideoWorker : NSObject
/**whether can access video*/
+ (BOOL)canAccessVideo;
/**fetch video permission*/
+ (void)fetchAccessVideoPermissionsWithCompletionHandler:(void(^)(BOOL granted))completion;

@end
