//
//  YBPermissionPhotoWorker.m
//  DDKuaiqian
//
//  Created by asance on 2017/11/17.
//  Copyright © 2017年 asance. All rights reserved.
//

#import "YBPermissionPhotoWorker.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>

#define kRPWSystemVersion9      (9)

@implementation YBPermissionPhotoWorker

+ (BOOL)canAccessPhoto{
    if([[[UIDevice currentDevice] systemVersion] floatValue]>kRPWSystemVersion9){
        PHAuthorizationStatus photoAuthorStatus = [PHPhotoLibrary authorizationStatus];
        if(PHAuthorizationStatusAuthorized!=photoAuthorStatus){
            NSLog(@"Rejected photo permissions");
            return NO;
        }
    }
    else{
        ALAuthorizationStatus authorizationStatus = [ALAssetsLibrary authorizationStatus];
        if(ALAuthorizationStatusAuthorized!=authorizationStatus){
            NSLog(@"Rejected photo permissions");
            return NO;
        }
    }
    return YES;
}
+ (void)fetchAccessPhotoPermissionsWithCompletionHandler:(void (^)(BOOL))completion{
    if([[[UIDevice currentDevice] systemVersion] floatValue]>kRPWSystemVersion9){
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if(completion){
                    if(PHAuthorizationStatusAuthorized==status){
                        completion(YES);
                    }
                    else{
                        NSLog(@"Rejected photo permissions");
                        completion(NO);
                    }
                }
            });
        }];
    }
}

@end
