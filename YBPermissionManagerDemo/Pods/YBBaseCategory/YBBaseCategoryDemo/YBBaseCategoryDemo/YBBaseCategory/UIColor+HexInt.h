//
//  UIColor+HexInt.h
//  YBNetAgent
//
//  Created by asance on 2017/5/2.
//  Copyright © 2017年 asance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (HexInt)
/**Get color based on hexadecimal value*/
+ (UIColor *)hexColor:(NSString *)hexStr;
/**Get the color based on the hexadecimal value and set the transparency*/
+ (UIColor *)hexColor:(NSString *)hexStr alpha:(CGFloat)alpha;

@end
