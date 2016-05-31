//
//  NSDictionary+CNKit.m
//  SalesAssistantApp
//
//  Created by haoju-congni on 15/1/15.
//  Copyright (c) 2015年 好居. All rights reserved.
//

#import "NSDictionary+CNKit.h"

@implementation NSDictionary (CNKit)


#pragma mark -  NSLog中文的时候，会显示unicode，英文正常，Xcode调试对本地化文字没有做处理 需要对象本身实现description方法才可以。
- (NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *strM = [NSMutableString stringWithString:@"{\n"];
    
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [strM appendFormat:@"\t%@ = %@;\n", key, obj];
    }];
    
    [strM appendString:@"}\n"];
    
    return strM;
}
@end
