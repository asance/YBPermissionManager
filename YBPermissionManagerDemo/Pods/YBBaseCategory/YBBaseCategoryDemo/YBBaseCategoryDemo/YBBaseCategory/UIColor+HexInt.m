//
//  UIColor+HexInt.m
//  YBNetAgent
//
//  Created by asance on 2017/5/2.
//  Copyright © 2017年 asance. All rights reserved.
//

#import "UIColor+HexInt.h"

@implementation UIColor (HexInt)

+ (UIColor *)hexColor:(NSString *)hexStr{
    
    if (hexStr.length < 6)
        return nil;
    
    unsigned int red_, green_, blue_;
    NSRange exceptionRange;
    exceptionRange.length = 2;
    
    //red
    exceptionRange.location = 0;
    [[NSScanner scannerWithString:[hexStr substringWithRange:exceptionRange]] scanHexInt:&red_];
    
    //green
    exceptionRange.location = 2;
    [[NSScanner scannerWithString:[hexStr substringWithRange:exceptionRange]] scanHexInt:&green_];
    
    //blue
    exceptionRange.location = 4;
    [[NSScanner scannerWithString:[hexStr substringWithRange:exceptionRange]] scanHexInt:&blue_];
    
    UIColor *resultColor = [UIColor colorWithRed:red_/255.0 green:green_/255.0 blue:blue_/255.0 alpha:1.0];
    
    return resultColor;
}

+ (UIColor *)hexColor:(NSString *)hexStr alpha:(CGFloat)alpha{
    if (hexStr.length < 6)
        return nil;
    if(alpha>1){
        alpha = 1.0;
    }
    
    unsigned int red_, green_, blue_;
    NSRange exceptionRange;
    exceptionRange.length = 2;
    
    //red
    exceptionRange.location = 0;
    [[NSScanner scannerWithString:[hexStr substringWithRange:exceptionRange]] scanHexInt:&red_];
    
    //green
    exceptionRange.location = 2;
    [[NSScanner scannerWithString:[hexStr substringWithRange:exceptionRange]] scanHexInt:&green_];
    
    //blue
    exceptionRange.location = 4;
    [[NSScanner scannerWithString:[hexStr substringWithRange:exceptionRange]] scanHexInt:&blue_];
    
    UIColor *resultColor = [UIColor colorWithRed:red_/255.0 green:green_/255.0 blue:blue_/255.0 alpha:alpha];
    
    return resultColor;
}


@end
