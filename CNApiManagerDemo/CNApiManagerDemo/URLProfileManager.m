//
//  URLProfileManager.m
//  CNApiManagerDemo
//
//  Created by 葱泥 on 16/9/28.
//  Copyright © 2016年 葱泥. All rights reserved.
//

#import "URLProfileManager.h"

@implementation URLProfileManager

#pragma mark 数据字典
+ (NSString *)dataMapURL {
    return [self mosaicURL:@"当前接口地址"];
}

#pragma mark 广告位
+ (NSString *)advertiseURL {
    return [self mosaicURL:@"当前接口地址"];
}


#pragma mark -Private Method
#pragma mark 拼接
+ (NSString *)mosaicURL:(NSString *)url {
    NSString *baseURL;
    
#if DEVELOPMENT
    baseURL = @"你的测试服务器地址";
#else
    baseURL = @"线上服务器地址";
#endif
    
    return [NSString stringWithFormat:@"%@%@", baseURL, url];
}

@end
