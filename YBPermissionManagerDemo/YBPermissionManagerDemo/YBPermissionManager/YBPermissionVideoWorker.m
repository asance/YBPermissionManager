//
//  YBPermissionVideoWorker.m
//  DDKuaiqian
//
//  Created by asance on 2017/11/17.
//  Copyright © 2017年 asance. All rights reserved.
//

#import "YBPermissionVideoWorker.h"
#import <AVFoundation/AVFoundation.h>

@implementation YBPermissionVideoWorker

+ (BOOL)canAccessVideo{
    AVAuthorizationStatus AVstatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(AVAuthorizationStatusAuthorized!=AVstatus){
        NSLog(@"Rejected photo permissions");
        return NO;
    }
    return YES;
}
+ (void)fetchAccessVideoPermissionsWithCompletionHandler:(void (^)(BOOL))completion{
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:completion];
}

@end
