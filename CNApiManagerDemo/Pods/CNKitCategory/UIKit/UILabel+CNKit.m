//
//  UILabel+CNKit.m
//  SalesAssistantApp
//
//  Created by haoju-congni on 15/1/13.
//  Copyright (c) 2015年 好居. All rights reserved.
//

#import "UILabel+CNKit.h"
#import "UIColor+CNKit.h"
#import "UIView+CNKit.h"

@implementation UILabel (CNKit)


#pragma mark 根据文字内容和字体大小，计算文字的size
-(CGSize )getContentSizeFromSize:(CGSize)size
{
    CGSize textSize;
    if ([[UIDevice currentDevice].systemVersion doubleValue] < 7.0) {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
        textSize = [self.text sizeWithFont:self.font
                         constrainedToSize:size
                             lineBreakMode:NSLineBreakByWordWrapping];
#endif
        
    } else{
        
        NSDictionary *attribute = @{NSFontAttributeName: self.font};
        
        textSize = [self.text boundingRectWithSize:size
                                                 options:
                          NSStringDrawingTruncatesLastVisibleLine |
                          NSStringDrawingUsesLineFragmentOrigin |
                          NSStringDrawingUsesFontLeading
                                              attributes:attribute
                                                 context:nil].size;
    }
    
    return textSize;
}

#pragma mark 根据内容大小 自动设置Label的高度
- (void)resizeHeightToFitTextContentsForAttributeText:(BOOL)isAttributeText
{
    self.numberOfLines = 0;
    if (isAttributeText) {
        if (self.attributedText.length < 1) {
            return;
        }
    } else {
        if (self.text.length < 1) {
            return;
        }
    }
    
    self.height = [self requiredHeightToFitContentsForAttributeText:isAttributeText];
}

#pragma mark 根据内容大小  自动设置Label的size大小
- (void)resizeToFitTextContentsForAttributeText:(BOOL)isAttributeText {
    self.numberOfLines = 0;
    if (isAttributeText) {
        if (self.attributedText.length < 1) {
            return;
        }
    } else {
        if (self.text.length < 1) {
            return;
        }
    }
    
    self.height = [self requiredHeightToFitContentsForAttributeText:isAttributeText];
    self.width = [self requiredWidthToFitContentsForAttributeText:isAttributeText];
}

#pragma mark 根据内容大小 自动设置Label的宽度
- (void)resizeWidthToFitTextContentsForAttributeText:(BOOL)isAttributeText
{
    self.numberOfLines = 0;
    if (self.attributedText.length < 1) {
        return;
    }
    self.width = [self requiredWidthToFitContentsForAttributeText:isAttributeText];
}

#pragma mark 根据内容大小  获取高度
- (CGFloat)requiredHeightToFitContentsForAttributeText:(BOOL)isAttributeText
{
    return [self fitContentsByWidth:NO ForAttributedText:isAttributeText];
}

#pragma mark 根据内容大小  获取宽度大小
- (CGFloat)requiredWidthToFitContentsForAttributeText:(BOOL)isAttributeText
{
    return [self fitContentsByWidth:YES ForAttributedText:isAttributeText];
}

#pragma mark 根据内容 获取宽度或者高度大小
- (CGFloat)fitContentsByWidth:(BOOL)isWidth ForAttributedText:(BOOL)isAttributeText {
    NSAttributedString *attributedText;
    
    if (isAttributeText) {
        if (self.attributedText.length < 1) {
            return 0.0f;
        }
        
        attributedText = self.attributedText;
    } else {
        if (self.text.length < 1) {
            return 0.0f;
        }
        
        attributedText = [[NSAttributedString alloc] initWithString:self.text attributes:@{NSFontAttributeName: self.font}];
    }
    
    if (isWidth) {
        CGRect rect = [attributedText boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, self.height) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        
        return ceil(rect.size.width);
    } else {
        CGRect rect = [attributedText boundingRectWithSize:CGSizeMake(self.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        return ceil(rect.size.height);
    }
}


#pragma mark 创建table
+(UILabel *)creatLabel:(CGRect)frame fontSize:(CGFloat)fontSize
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    return label;
    
}

#pragma mark 创建table 带透明度
+(UILabel *)creatLabel:(CGRect)frame fontSize:(CGFloat)fontSize alpha:(CGFloat)alp
{
    UILabel *label = [self creatLabel:frame fontSize:fontSize];
    label.alpha = alp;
    return label;
}

#pragma mark 创建table 带文本对齐方式
+(UILabel *)creatLabel:(CGRect)frame fontSize:(CGFloat)fontSize alignment:(NSTextAlignment)alignment
{
    UILabel *label = [self creatLabel:frame fontSize:fontSize];
    label.textAlignment = alignment;
    return label;
}

#pragma mark 创建table 带文本对齐方式 透明度
+(UILabel *)creatLabel:(CGRect)frame fontSize:(CGFloat)fontSize alignment:(NSTextAlignment)alignment alpha:(CGFloat)alp
{
    UILabel *label = [self creatLabel:frame fontSize:fontSize alignment:alignment];
    label.alpha = alp;
    return label;
}

#pragma mark 创建UILabel 带文本对齐方式 字体大小 及字体内容
+(UILabel *)creatLabel:(CGRect)frame fontSize:(CGFloat)fontSize  alignment:(NSTextAlignment)alignment textString:(NSString *)textString
{
    UILabel *label = [self creatLabel:frame fontSize:fontSize alignment:alignment];
    label.textColor = [UIColor colorWithHexString:@"999999"];
    label.text = textString;
    return label;
}

#pragma mark 创建Label
+(UILabel*)creatLabel:(CGRect)frame text:(NSString *)text hexString:(NSString *)hexString fontSize:(CGFloat)fontSize
{
    UILabel *label = [self creatLabel:frame fontSize:fontSize];
    label.text = text;
    label.textColor = [UIColor colorWithHexString:hexString];
    return label;
    
}

@end
