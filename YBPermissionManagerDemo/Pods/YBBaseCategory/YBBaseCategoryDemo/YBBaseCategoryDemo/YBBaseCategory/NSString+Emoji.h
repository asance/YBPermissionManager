//
//  NSString+Emoji.h
//  DDKuaiqian
//
//  Created by asance on 2017/11/11.
//  Copyright © 2017年 asance. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Emoji)
/**wheater contain emoji*/
- (BOOL)containEmoji;
/**remove all emoji*/
- (NSString *)removeEmoji;

@end
