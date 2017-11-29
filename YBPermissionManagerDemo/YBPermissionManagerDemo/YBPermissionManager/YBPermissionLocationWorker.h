//
//  YBPermissionLocationWorker.h
//  YoubanLoan
//
//  Created by asance on 2017/7/24.
//  Copyright © 2017年 asance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YBPermissionLocationWorker : NSObject

@property(copy, nonatomic) NSString *latitude;
@property(copy, nonatomic) NSString *longitude;
@property(copy, nonatomic) void(^onLocationPermissionsGrantedBlock)(BOOL granted);

+ (instancetype)shareInstance;
/**whether can access location*/
+ (BOOL)canAccessLocation;
/**fetch location permission*/
+ (void)fetchAccessLocationPermissionsWithCompletionHandler:(void (^)(BOOL granted))completion;

@end
