//
//  UIColor+CNKit.h
//  SalesAssistantApp
//
//  Created by haoju-congni on 15/1/13.
//  Copyright (c) 2015年 好居. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (CNKit)

/**
 *  16进制颜色#e26562转UIColor
 *
 *  @param color 16进制颜色  不含#
 *  @param alp   透明度
 *
 *  @return UIColor
 */
+ (instancetype)colorWithHexString:(NSString *)color alp:(float)alp;

/**
 *  16进制颜色#e26562转UIColor
 *
 *  @param color 16进制颜色  不含#
 *
 *  @return UIColor
 */
+ (instancetype)colorWithHexString:(NSString *)color ;

/**
 *  RGB数字转颜色
 *
 *  @param r   red
 *  @param g   green
 *  @param b   blue
 *  @param flt 透明度
 *
 *  @return UIColor
 */
+(instancetype)colorWithR:(CGFloat)r g:(CGFloat)g b:(CGFloat)b flt:(CGFloat)flt;

/**
 *  RGB数字转颜色默认透明为1
 *
 *  @param r red
 *  @param g green
 *  @param b blue
 *
 *  @return UIColor
 */
+(instancetype)colorWithR:(CGFloat)r g:(CGFloat)g b:(CGFloat)b ;
@end
