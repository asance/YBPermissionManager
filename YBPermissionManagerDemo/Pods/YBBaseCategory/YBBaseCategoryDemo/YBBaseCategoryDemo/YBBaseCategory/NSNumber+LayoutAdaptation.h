//
//  NSNumber+LayoutAdaptation.h
//  YoubanAgent
//
//  Created by asance on 2017/5/10.
//  Copyright © 2017年 asance. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface NSNumber (LayoutAdaptation)
/**Fit width to screen width of 375 as standard*/
+ (CGFloat)adaptToWidth:(CGFloat)width;
/**Fit height to screen height of 667 as standard*/
+ (CGFloat)adaptToHeight:(CGFloat)height;

/**Fit width to screen width of 375 as standard, Whether to set the minimum value*/
+ (CGFloat)adaptToWidth:(CGFloat)width minValueEnable:(BOOL)minValueEnable;
/**Fit height to screen height of 667 as standard, Whether to set the minimum value*/
+ (CGFloat)adaptToHeight:(CGFloat)height minValueEnable:(BOOL)minValueEnable;

/**Fit width to screen width of 375 as standard, Whether to set the maximum value*/
+ (CGFloat)adaptToHeight:(CGFloat)height maxValueEnable:(BOOL)maxValueEnable;
/**Fit height to screen height of 667 as standard, Whether to set the maximum value*/
+ (CGFloat)adaptToWidth:(CGFloat)width maxValueEnable:(BOOL)maxValueEnable;

@end
