//
//  NSNumber+LayoutAdaptation.m
//  YoubanAgent
//
//  Created by asance on 2017/5/10.
//  Copyright © 2017年 asance. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "NSNumber+LayoutAdaptation.h"
/**
 ------------------------
 机型     宽高      模式
 3/4    320x480     1x
 5      320x568     2x
 6/7    375x667     2x
 6/7+   414x736     3x
 ------------------------
 
 ------------------------
 机型     屏幕宽高比
 3/4        0.66
 5          0.56
 6/7        0.56
 6/7+       0.56
 ------------------------
 
 可以看出， 6跟 5虽然屏幕尺寸改变了，但是它们的比例是不变的。都是 9 ÷ 16 = 0.5625 的屏幕
 所以适配暂时只做4与5屏幕的适配，6以后的机型以5为基准，等比例缩放
 */

#define kCURRENT_SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define kCURRENT_SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define kIPHONE_6_SCREEN_WIDTH (375)
#define kIPHONE_6_SCREEN_HEIGHT (667)

@implementation NSNumber (LayoutAdaptation)

+ (CGFloat)adaptToWidth:(CGFloat)width{
    return (width/kIPHONE_6_SCREEN_WIDTH*kCURRENT_SCREEN_WIDTH);
}
+ (CGFloat)adaptToHeight:(CGFloat)height{
    return (height/kIPHONE_6_SCREEN_HEIGHT*kCURRENT_SCREEN_HEIGHT);
}

+ (CGFloat)adaptToWidth:(CGFloat)width minValueEnable:(BOOL)minValueEnable{
    CGFloat newWidth = [NSNumber adaptToWidth:width];
    if(minValueEnable){
        if(newWidth<width){
            newWidth = width;
        }
    }
    return newWidth;
}
+ (CGFloat)adaptToWidth:(CGFloat)width maxValueEnable:(BOOL)maxValueEnable{
    CGFloat newWidth = [NSNumber adaptToWidth:width];
    if(maxValueEnable){
        if(newWidth>width){
            newWidth = width;
        }
    }
    return newWidth;
}

+ (CGFloat)adaptToHeight:(CGFloat)height minValueEnable:(BOOL)minValueEnable{
    CGFloat newHeight = [NSNumber adaptToHeight:height];
    if(minValueEnable){
        if(newHeight<height){
            newHeight = height;
        }
    }
    return newHeight;
}

+ (CGFloat)adaptToHeight:(CGFloat)height maxValueEnable:(BOOL)maxValueEnable{
    CGFloat newHeight = [NSNumber adaptToHeight:height];
    if(maxValueEnable){
        if(newHeight>height){
            newHeight = height;
        }
    }
    return newHeight;
}

@end
