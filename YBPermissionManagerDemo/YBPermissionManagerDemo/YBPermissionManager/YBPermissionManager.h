//
//  YBPermissionManager.h
//  DDKuaiqian
//
//  Created by asance on 2017/11/17.
//  Copyright © 2017年 asance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YBPermissionBeLimitedView.h"

@interface YBPermissionManager : NSObject
+ (instancetype)shareInstance;
@property(weak, nonatomic) YBPermissionBeLimitedView *permissionBeLimitedView;
/**remove YBPermissionBeLimitedView*/
+ (void)reomvePermissionBeLimitedView;

#pragma mark - Contact
/**whether can access contact*/
+ (BOOL)canAccessContact;
/**fetch contact permission*/
+ (void)fetchAccessContactPermissionsWithCompletionHandler:(void(^)(BOOL granted))completion;

#pragma mark - Photo
/**whether can access photo*/
+ (BOOL)canAccessPhoto;
/**fetch photo permission*/
+ (void)fetchAccessPhotoPermissionsWithCompletionHandler:(void(^)(BOOL granted))completion;

#pragma mark - Video
/**whether can access video*/
+ (BOOL)canAccessVideo;
/**fetch video permission*/
+ (void)fetchAccessVideoPermissionsWithCompletionHandler:(void(^)(BOOL granted))completion;

#pragma mark - Location
/**whether can access location*/
+ (BOOL)canAccessLocation;
/**fetch location permission*/
+ (void)fetchAccessLocationPermissionsWithCompletionHandler:(void (^)(BOOL granted))completion;

@end
