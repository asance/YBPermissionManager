//
//  YBPermissionLocationWorker.m
//  YoubanLoan
//
//  Created by asance on 2017/7/24.
//  Copyright © 2017年 asance. All rights reserved.
//

#import "YBPermissionLocationWorker.h"
#import <CoreLocation/CoreLocation.h>

@interface YBPermissionLocationWorker ()<CLLocationManagerDelegate>

@property(strong, nonatomic) CLLocationManager *loacationManager;

@end

@implementation YBPermissionLocationWorker

+ (instancetype)shareInstance{
    static YBPermissionLocationWorker *shareInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        shareInstance = [[YBPermissionLocationWorker alloc] init];
    });
    return shareInstance;
}

+ (BOOL)canAccessLocation{
    if ([CLLocationManager locationServicesEnabled] &&
        ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedWhenInUse||
         [CLLocationManager authorizationStatus]==kCLAuthorizationStatusAuthorizedAlways)) {
            return YES;
        }
    NSLog(@"Location not authorized");
    return NO;
}
+ (void)fetchAccessLocationPermissionsWithCompletionHandler:(void (^)(BOOL))completion{
    if([CLLocationManager locationServicesEnabled]){
        NSLog(@"Access location permission");
        [YBPermissionLocationWorker shareInstance].onLocationPermissionsGrantedBlock = completion;
        [[YBPermissionLocationWorker shareInstance].loacationManager requestWhenInUseAuthorization];
        [[YBPermissionLocationWorker shareInstance].loacationManager startUpdatingLocation];
    }
    else{
        NSLog(@"Rejected location permission");
        dispatch_async(dispatch_get_main_queue(), ^{
            if(completion){
                completion(NO);
            }
        });
    }
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    [manager stopUpdatingLocation];
    if(kCLErrorDenied==[error code]){
        NSLog(@"Location permission not denied");
    }
    else if (kCLErrorLocationUnknown==[error code]){
        NSLog(@"Unknown location");
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if(self.onLocationPermissionsGrantedBlock){
            self.onLocationPermissionsGrantedBlock(NO);
        }
    });
}
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    NSLog(@"CLAuthorizationStatus==%@",@(status));

    dispatch_async(dispatch_get_main_queue(), ^{
        if((kCLAuthorizationStatusAuthorizedAlways==status)||
           (kCLAuthorizationStatusAuthorizedWhenInUse==status)){
            if(self.onLocationPermissionsGrantedBlock){
                self.onLocationPermissionsGrantedBlock(YES);
            }
        }
        else if (kCLAuthorizationStatusNotDetermined==status){
            
        }
        else{
            if(self.onLocationPermissionsGrantedBlock){
                self.onLocationPermissionsGrantedBlock(NO);
            }
        }
    });
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    CLLocation *newLocation = [locations lastObject];
    
    //获取当前城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    //根据经纬度反向编译出地址信息
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if(placemarks.count){
            CLPlacemark *placemark = [placemarks lastObject];
            
            //获取城市
            NSString *city = placemark.locality;
            if(!city){
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
            }
            
//            NSLog(@"国家：%@",placemark.country);
//            NSLog(@"省份：%@",placemark.administrativeArea);
//            NSLog(@"城市：%@", city);
//            NSLog(@"区：%@",placemark.subLocality);
//            NSLog(@"具体位置：%@",placemark.name);
            
            self.latitude = [NSString stringWithFormat:@"%@",@(placemark.location.coordinate.latitude)];
            self.longitude = [NSString stringWithFormat:@"%@",@(placemark.location.coordinate.longitude)];
            
            NSLog(@"latitude:%@, longitude:%@",self.latitude,self.longitude);
        }
        else if ((placemarks.count==0)&&(error==nil)){
            NSLog(@"None location info");
        }
        else if (error){
            NSLog(@"An error occurred = %@", error);
        }
    }];
    [manager stopUpdatingLocation];
}

#pragma mark - Getter Setter
- (CLLocationManager *)loacationManager{
    if(!_loacationManager){
        _loacationManager = [[CLLocationManager alloc] init];
        _loacationManager.delegate = self;
        
        _loacationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        _loacationManager.distanceFilter = 5.0f;
    }
    return _loacationManager;
}

@end
