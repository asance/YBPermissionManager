//
//  YBPermissionPhotoWorker.h
//  DDKuaiqian
//
//  Created by asance on 2017/11/17.
//  Copyright © 2017年 asance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBPermissionPhotoWorker : NSObject
/**whether can access photo*/
+ (BOOL)canAccessPhoto;
/**fetch photo permission*/
+ (void)fetchAccessPhotoPermissionsWithCompletionHandler:(void(^)(BOOL granted))completion;

@end
