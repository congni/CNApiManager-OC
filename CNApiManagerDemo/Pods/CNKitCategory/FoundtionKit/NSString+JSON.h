//
//  NSString+JSON.h
//  SocketRocketTest
//
//  Created by 余彪 on 16/5/27.
//  Copyright © 2016年 quanXiang. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (JSON)

/**
 *  字典转json
 *
 *  @param dictionary 字典
 *
 *  @return json
 */
+ (NSString *)jsonStringWithDictionary:(NSDictionary *)dictionary;

/**
 *  数组转json
 *
 *  @param array 数组
 *
 *  @return json
 */
+ (NSString *)jsonStringWithArray:(NSArray *)array;

/**
 *  字符串转json
 *
 *  @param string 字符串
 *
 *  @return json
 */
+ (NSString *)jsonStringWithString:(NSString *)string;

@end
