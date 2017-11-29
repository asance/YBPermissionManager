//
//  YBPermissionBeLimitedView.h
//  test_CodeReview
//
//  Created by asance on 2017/10/13.
//  Copyright © 2017年 asance. All rights reserved.
//

#import <UIKit/UIKit.h>

/**枚举:权限类型*/
typedef NS_ENUM(NSInteger, YBPermissionType) {
    /**通信录类型*/
    YBPermissionTypeContact = 10,
    /**相册类型*/
    YBPermissionTypePhoto = 20,
    /**相机类型*/
    YBPermissionTypeVido = 30,
    /**定位类型*/
    YBPermissionTypeLocation = 40,
};

@interface YBPermissionBeLimitedView : UIView
@property(strong, nonatomic) UIView *backgroundView;
@property(strong, nonatomic) UIView *contentView;

@property(strong, nonatomic) UILabel *titleLabel;
@property(strong, nonatomic) UILabel *detailLabel;

@property(strong, nonatomic) UIView *line1View;
@property(strong, nonatomic) UIView *line2View;

@property(strong, nonatomic) UIButton *cancelButton;
@property(strong, nonatomic) UIButton *confirmButton;

@property(assign, nonatomic) YBPermissionType permissionType;
@property(copy, nonatomic) NSString *appName;

/**
 * When the user clicks the "Authorize" button will call back,
 * and then open the Settings interface, prompts the user to open permissions.
 */
@property(copy, nonatomic) void(^onOpenPermissionBlock)(void);
/**
 * When the user clicks the "Rejected" button will call back,
 * and then remove from super view.
 */
@property(copy, nonatomic) void(^onClosePermissionBlock)(void);

/**
 * Get permissions by type, and call back user authorization results.
 * @param success success callback.
 * @param failure rejected callback.
 */
+ (void)fetchPermissionWithType:(YBPermissionType)type success:(void(^)(void))success failure:(void(^)(void))failure;
/**
 * Get permissions by type, and call back user authorization results.
 * @param appName app name.
 * @param success success callback.
 * @param failure rejected callback.
 */
+ (void)fetchPermissionWithType:(YBPermissionType)type appName:(NSString *)appName success:(void(^)(void))success failure:(void(^)(void))failure;

@end
