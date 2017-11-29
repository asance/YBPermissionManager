//
//  NSString+Finance.m
//  YoubanAgent
//
//  Created by asance on 2017/5/11.
//  Copyright © 2017年 asance. All rights reserved.
//

#import "NSString+Finance.h"

@implementation NSString (Finance)

- (NSString *)onlyKeepValidNumbersWithoutTheDecimalPoint{
    return [self onlyKeepValidNumbersBehindTheDecimalPoint:0];
}

- (NSString *)onlyKeepSingleValidNumbersBehindTheDecimalPoint{
    return [self onlyKeepValidNumbersBehindTheDecimalPoint:1];
}

- (NSString *)onlyKeepTwoValidNumbersBehindTheDecimalPoint{
    return [self onlyKeepValidNumbersBehindTheDecimalPoint:2];
}

- (NSString *)onlyKeepValidNumbersBehindTheDecimalPoint:(NSInteger)number{
    
    if(0==number){
        NSRange range = [self rangeOfString:@"."];
        if(NSNotFound==range.location){
            return [NSString stringWithFormat:@"%@",self];;
        }
        else{
            return [self substringWithRange:NSMakeRange(0, range.location)];
        }
    }
    
    if(0==self.length){
        NSString *ext = @"";
        for(NSInteger i=0;i<number;i++){
            ext = [NSString stringWithFormat:@"%@0",ext];
        }
        return [NSString stringWithFormat:@"0.%@",ext];
    }
    
    NSArray *comArray = [self componentsSeparatedByString:@"."];
    if(1==comArray.count){
        NSString *ext = @"";
        for(NSInteger i=0;i<number;i++){
            ext = [NSString stringWithFormat:@"%@0",ext];
        }
        return [NSString stringWithFormat:@"%@.%@",comArray[0],ext];
    }
    
    NSString *decimalValue = [comArray objectAtIndex:1];
    if(number>decimalValue.length){
        NSString *ext = @"";
        for(NSInteger i=0;i<(number-(decimalValue.length));i++){
            ext = [NSString stringWithFormat:@"%@0",ext];
        }
        return [NSString stringWithFormat:@"%@.%@%@",comArray[0],decimalValue,ext];
    }
    if(number==decimalValue.length){
        return [NSString stringWithFormat:@"%@.%@",comArray[0],decimalValue];
    }
    if(number<decimalValue.length){
       NSString *newDecimalValue = [decimalValue substringWithRange:NSMakeRange(0, number)];
        return [NSString stringWithFormat:@"%@.%@",comArray[0],newDecimalValue];
    }
    
    return self;
}

+ (NSString *)financeStringForObject:(id)obj{
    
    id newObj = obj;
    if(obj==nil) {
        newObj = @"";
    }
    if([obj isKindOfClass:[NSNull class]]) {
        newObj = @"";
    }
    
    NSString *newObjString = [NSString stringWithFormat:@"%@",newObj];
    
    if(0==newObjString.length){
        newObjString = @"0.00";
        return newObjString;
    }
    else{
        NSDecimalNumberHandler *roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundBankers scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
        
        NSDecimalNumber *roundDecimal = [NSDecimalNumber decimalNumberWithString:newObjString];
        NSString *financeStr =[[roundDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior] stringValue];
        
        return [financeStr onlyKeepTwoValidNumbersBehindTheDecimalPoint];
    }
}
@end
