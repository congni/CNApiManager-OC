//
//  NSString+CNKit.m
//  SalesAssistantApp
//
//  Created by haoju-congni on 15/1/13.
//  Copyright (c) 2015年 好居. All rights reserved.
//

#import "NSString+CNKit.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (CNKit)


#pragma mark 获取字符串长度
- (CGSize)getStringSize:(UIFont *)font {
    return [self getStringSize:font contentSize:CGSizeMake(1000.0, 1000.0)];
}

- (CGSize)getStringSize:(UIFont *)font contentSize:(CGSize)contentSize {
    CGSize textSize;
    if ([[UIDevice currentDevice].systemVersion doubleValue] < 7.0) {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
        textSize = [self sizeWithFont:font
                    constrainedToSize:contentSize
                        lineBreakMode:NSLineBreakByWordWrapping];
#endif
        
    }else{
        
        NSDictionary *attribute = @{NSFontAttributeName: font};
        
        textSize = [self boundingRectWithSize:contentSize
                                      options:
                    NSStringDrawingTruncatesLastVisibleLine |
                    NSStringDrawingUsesLineFragmentOrigin |
                    NSStringDrawingUsesFontLeading
                                   attributes:attribute
                                      context:nil].size;
    }
    return textSize;
}

#pragma mark 是否空字符串 没有任何字符
- (BOOL)isBlank {
    return ([[self removeAllSpace] isEqualToString:@""]) ? YES : NO;
}

#pragma mark 是否是有效的字符串  包括空字符串
- (BOOL)isValid {
    return ([[self removeAllSpace] isEqualToString:@""] || self == nil || [self isEqualToString:@"(null)"]) ? NO :YES;
}

#pragma mark 是否只包含字母
- (BOOL)isOnlyLetters
{
    NSCharacterSet *letterCharacterset = [[NSCharacterSet letterCharacterSet] invertedSet];
    return ([self rangeOfCharacterFromSet:letterCharacterset].location == NSNotFound);
}

#pragma mark 是否只包含数字
- (BOOL)isOnlyNumbers
{
    NSCharacterSet *numbersCharacterSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
    return ([self rangeOfCharacterFromSet:numbersCharacterSet].location == NSNotFound);
}

#pragma mark 按指定字符串分割为数组
- (NSArray *)divisionForArrayByString:(NSString *)separatedStr {
    return [self componentsSeparatedByString:separatedStr];
}

#pragma mark 是否是有效的Email
- (BOOL)isEffectiveEmail {
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTestPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [emailTestPredicate evaluateWithObject:self];
}

#pragma mark 判断是否是URL
- (BOOL)isEffectiveUrl {
    NSString *regex =@"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [urlTest evaluateWithObject:self];
}

#pragma mark 删除所有空格
- (NSString *)removeAllSpace {
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}

#pragma mark 按指定字符数量 插入指定字符
- (NSString *)insertStr:(NSString *)insertStr  cutCount:(int)count {
    NSMutableString *insert_MulStr = [[NSMutableString alloc] init];

    NSUInteger length = [self length];
    if (length <= count) {
        return self;
    } else {
        NSUInteger insertCount = length / count;
        for (int i = 0; i <= insertCount; i++) {
            int fromIndex = i * count;
            if ( (fromIndex + count) > length) {
                NSString *str = [self substringFromIndex:fromIndex];
                [insert_MulStr appendString:[NSString stringWithFormat:@"%@",str]];
            } else {
                NSString *str = [self substringWithRange:NSMakeRange(fromIndex, count)];
                if ((fromIndex + count) == length) {
                    [insert_MulStr appendString:[NSString stringWithFormat:@"%@",str]];
                } else {
                    [insert_MulStr appendString:[NSString stringWithFormat:@"%@%@",str,insertStr]];
                }
            }
        }
    }
    
    return insert_MulStr;
}

#pragma mark md5加密
- (NSString *)md5Encrypt {
    const char *cStr = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}

@end
