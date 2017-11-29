//
//  YBPermissionContactWorker.h
//  YoubanLoan
//
//  Created by asance on 2017/7/24.
//  Copyright © 2017年 asance. All rights reserved.
//

#import <Foundation/Foundation.h>

/**Enum:Authorization status*/
typedef NS_ENUM(NSInteger, YBCNAuthorizationStatus) {
    /**Not determined*/
    YBCNAuthorizationStatusNotDetermined = 1,
    /**Denied*/
    YBCNAuthorizationStatusDenied = 2,
    /**Authorized*/
    YBCNAuthorizationStatusAuthorized = 3,
};

@interface YBPermissionContactWorker : NSObject

/**whether can access contact*/
+ (BOOL)canAccessContact;
/**fetch contact permission*/
+ (void)fetchAccessContactPermissionsWithCompletionHandler:(void(^)(BOOL granted))completion;
/**fetch contact authorization status*/
+ (YBCNAuthorizationStatus)accessContactStatus;
/**fetch all contacts*/
+ (void)fetchDeviceContactsWithComplete:(void(^)(NSMutableArray *allContacts))complete;

@end
