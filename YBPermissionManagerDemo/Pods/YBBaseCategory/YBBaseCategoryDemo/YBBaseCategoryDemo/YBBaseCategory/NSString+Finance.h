//
//  NSString+Finance.h
//  YoubanAgent
//
//  Created by asance on 2017/5/11.
//  Copyright © 2017年 asance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Finance)

/**
 * 去掉小数
 */
- (NSString *)onlyKeepValidNumbersWithoutTheDecimalPoint;

/**
 * 仅保留小数点后一位有效数字
 */
- (NSString *)onlyKeepSingleValidNumbersBehindTheDecimalPoint;

/**
 * 仅保留小数点后两位有效数字
 */
- (NSString *)onlyKeepTwoValidNumbersBehindTheDecimalPoint;

/**
 * 仅保留小数点后有效数字
 * @param number 要求保留多少位
 */
- (NSString *)onlyKeepValidNumbersBehindTheDecimalPoint:(NSInteger)number;

/**Class method: Returns the financial format string, which holds two valid decimals*/
+ (NSString *)financeStringForObject:(id)obj;

@end
