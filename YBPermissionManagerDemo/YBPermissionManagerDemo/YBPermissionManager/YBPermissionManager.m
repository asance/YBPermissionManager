//
//  YBPermissionManager.m
//  DDKuaiqian
//
//  Created by asance on 2017/11/17.
//  Copyright © 2017年 asance. All rights reserved.
//

#import "YBPermissionManager.h"
#import "YBPermissionPhotoWorker.h"
#import "YBPermissionVideoWorker.h"
#import "YBPermissionContactWorker.h"
#import "YBPermissionLocationWorker.h"

@implementation YBPermissionManager

+ (instancetype)shareInstance{
    static YBPermissionManager *shareInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        shareInstance = [[YBPermissionManager alloc] init];
    });
    return shareInstance;
}
+ (void)reomvePermissionBeLimitedView{
    if([YBPermissionManager shareInstance].permissionBeLimitedView){
        [[YBPermissionManager shareInstance].permissionBeLimitedView removeFromSuperview];
        [YBPermissionManager shareInstance].permissionBeLimitedView = nil;
    }
}

#pragma mark - Contact
+ (BOOL)canAccessContact{
    return [YBPermissionContactWorker canAccessContact];
}
+ (void)fetchAccessContactPermissionsWithCompletionHandler:(void (^)(BOOL))completion{
    [YBPermissionContactWorker fetchAccessContactPermissionsWithCompletionHandler:completion];
}

#pragma mark - Photo
+ (BOOL)canAccessPhoto{
    return [YBPermissionPhotoWorker canAccessPhoto];
}
+ (void)fetchAccessPhotoPermissionsWithCompletionHandler:(void (^)(BOOL))completion{
    [YBPermissionPhotoWorker fetchAccessPhotoPermissionsWithCompletionHandler:completion];
}

#pragma mark - Video
+ (BOOL)canAccessVideo{
    return [YBPermissionVideoWorker canAccessVideo];
}
+ (void)fetchAccessVideoPermissionsWithCompletionHandler:(void (^)(BOOL))completion{
    [YBPermissionVideoWorker fetchAccessVideoPermissionsWithCompletionHandler:completion];
}

#pragma mark - Location
+ (BOOL)canAccessLocation{
    return [YBPermissionLocationWorker canAccessLocation];
}
+ (void)fetchAccessLocationPermissionsWithCompletionHandler:(void (^)(BOOL))completion{
    [YBPermissionLocationWorker fetchAccessLocationPermissionsWithCompletionHandler:completion];
}

@end
