//
//  UILabel+CNKit.h
//  SalesAssistantApp
//
//  Created by 葱泥 on 15/1/13.
//  Copyright (c) 2015年 好居. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (CNKit)

/**
 *  根据Label文字内容和字体大小，计算文字的size
 */
-(CGSize )getContentSizeFromSize:(CGSize)size;

/**
 *  根据内容大小 自动设置Label的高度
 *
 *  @param isAttributeText 是否是AttributeText
 */
- (void)resizeHeightToFitTextContentsForAttributeText:(BOOL)isAttributeText;

/**
 *  根据内容大小 自动设置Label的宽度
 *
 *  @param isAttributeText 是否是AttributeText
 */
- (void)resizeWidthToFitTextContentsForAttributeText:(BOOL)isAttributeText;

/**
 *  根据内容大小  自动设置Label的size大小
 *
 *  @param isAttributeText 是否是AttributeText
 */
- (void)resizeToFitTextContentsForAttributeText:(BOOL)isAttributeText;

/**
 *  根据内容大小  获取高度
 *
 *  @param isAttributeText 是否是AttributeText
 *
 *  @return CGFloat 高度
 */
- (CGFloat)requiredHeightToFitContentsForAttributeText:(BOOL)isAttributeText;

/**
 *  根据内容大小  获取宽度大小
 *
 *  @param isAttributeText 是否是AttributeText
 *
 *  @return CGFloat 宽度
 */
- (CGFloat)requiredWidthToFitContentsForAttributeText:(BOOL)isAttributeText;

/**
 * 创建UILabel
 *
 *  @param frame    位置宽高
 *  @param fontSize 字体大小
 *  @return UILabel
 */

+(UILabel *)creatLabel:(CGRect)frame fontSize:(CGFloat)fontSize;

/**
 * 创建UILabel
 *
 *  @param frame    位置宽高
 *  @param fontSize 字体大小
 *  @param alp      透明度
 *
 *  @return UILabel
 */
+(UILabel *)creatLabel:(CGRect)frame fontSize:(CGFloat)fontSize alpha:(CGFloat)alp;

/**
 *  创建UILabel
 *
 *  @param frame     位置宽高
 *  @param fontSize   字体大小
 *  @param alignment 文本对齐方式
 *
 *  @return  UILabel
 */
+(UILabel *)creatLabel:(CGRect)frame fontSize:(CGFloat)fontSize  alignment:(NSTextAlignment)alignment;

/**
 *  创建UILabel
 *
 *  @param frame     位置宽高
 *  @param fontSize  字体大小
 *  @param alignment 文本对齐方式
 *  @param alp       透明度
 *
 *  @return 创建UILabel
 */
+(UILabel *)creatLabel:(CGRect)frame fontSize:(CGFloat)fontSize alignment:(NSTextAlignment)alignment alpha:(CGFloat)alp;

/**
 *  创建UILabel 带文本对齐方式 字体大小 及字体内容
 */
+(UILabel *)creatLabel:(CGRect)frame fontSize:(CGFloat)fontSize  alignment:(NSTextAlignment)alignment textString:(NSString *)textString;

/**
 *  创建UILabel
 *
 *  @param frame     位置宽高
 *  @param text      label的内容
 *  @param hexString 16进制颜色数
 *  @param fontSize  字体大小
 *  @return 创建UILabel
 */
+(UILabel*)creatLabel:(CGRect)frame text:(NSString *)text hexString:(NSString *)hexString fontSize:(CGFloat)fontSize;

@end
