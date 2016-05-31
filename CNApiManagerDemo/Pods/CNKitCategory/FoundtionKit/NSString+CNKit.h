//
//  NSString+CNKit.h
//  SalesAssistantApp
//
//  Created by haoju-congni on 15/1/13.
//  Copyright (c) 2015年 好居. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CNKit)

/**
 *  是否空字符串 没有任何字符
 *
 *  @return BOOL
 */
- (BOOL)isBlank;

/**
 *  是否是有效的字符串  包括空字符串
 *
 *  @return BOOL
 */
- (BOOL)isValid;

/**
 *  按指定字符串分割为数组
 *
 *  @param separatedStr 指定的字符串
 *
 *  @return NSArray
 */
- (NSArray *)divisionForArrayByString:(NSString *)separatedStr;

/**
 *  是否是有效的Email
 *
 *  @return BOOL
 */
- (BOOL)isEffectiveEmail;

/**
 *  判断是否是URL
 *
 *  @return BOOL
 */
- (BOOL)isEffectiveUrl;

/**
 *  是否只包含数字
 *
 *  @return BOOL
 */
- (BOOL)isOnlyNumbers;

/**
 *  是否只包含字母
 *
 *  @return BOOL
 */
- (BOOL)isOnlyLetters;

/**
 *  删除所有空格
 *
 *  @return NSString
 */
- (NSString *)removeAllSpace;

/**
 *  按指定字符数量 插入指定字符  当后面的字符串不足count值时 直接添加
 *
 *  @param insertStr 需要插入的字符串
 *  @param cutCount  每隔多少字符插入
 *
 *  @return NSString
 */
- (NSString *)insertStr:(NSString *)insertStr  cutCount:(int)count;

/**
 *  获取字符串长度
 *
 *  @param font 字体大小
 *
 *  @return CGSize
 */
- (CGSize)getStringSize:(UIFont *)font;

- (CGSize)getStringSize:(UIFont *)font contentSize:(CGSize)contentSize;

/**
 *  md5 加密
 *
 *  @return self
 */
- (NSString *)md5Encrypt;

@end
