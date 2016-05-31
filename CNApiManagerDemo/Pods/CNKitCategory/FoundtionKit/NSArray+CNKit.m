#import "NSArray+CNKit.h"

@implementation NSArray (CNKit)

#pragma mark -  NSLog中文的时候，会显示unicode，英文正常，Xcode调试对本地化文字没有做处理 需要对象本身实现description方法才可以。
- (NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *strM = [NSMutableString stringWithString:@"(\n"];
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [strM appendFormat:@"\t%@,\n", obj];
    }];
    
    [strM appendString:@")"];
    
    return strM;
}

@end