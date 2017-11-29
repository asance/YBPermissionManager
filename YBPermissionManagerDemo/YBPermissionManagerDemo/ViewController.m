//
//  ViewController.m
//  YBPermissionManagerDemo
//
//  Created by asance on 2017/11/29.
//  Copyright © 2017年 asance. All rights reserved.
//

#import "ViewController.h"
#import "YBPermissionManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self testPhotoPermission];
}

- (void)testPhotoPermission {
    BOOL canAccessPhoto = [YBPermissionManager canAccessPhoto];
    if(NO==canAccessPhoto){
        [YBPermissionManager fetchAccessPhotoPermissionsWithCompletionHandler:^(BOOL granted) {
            if(NO==granted){
                [YBPermissionBeLimitedView fetchPermissionWithType:YBPermissionTypePhoto success:^{} failure:^{}];
            }
        }];
    }
}

@end
