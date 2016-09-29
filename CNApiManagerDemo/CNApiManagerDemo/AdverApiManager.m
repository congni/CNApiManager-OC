//
//  AdverApiManager.m
//  CNApiManagerDemo
//
//  Created by 葱泥 on 16/9/28.
//  Copyright © 2016年 葱泥. All rights reserved.
//

#import "AdverApiManager.h"
#import "URLProfileManager.h"


@implementation AdverApiManager


#pragma mark 初始化数据  子类必须要实现此方法
- (void)initData {
    self.requestURL = [URLProfileManager advertiseURL];
    self.httpMethod = GET;
}

#pragma mark 获取数据成功回调
- (void)apiLoadSuccess {
    NSLog(@"AdvertiseApiManager   %@", self.rawData);
    
    if (self.isSupportNextPage) {
        NSArray *arry = [self.rawData valueForKey:@""];
        [self.mulArray addObjectsFromArray:arry];
        
        if (self.mulArray.count == [[self.rawData valueForKey:@""] integerValue]) {
            if ([self.apiCallBackDelegate respondsToSelector:@selector(lastPageLoaded)]) {
                [self.apiCallBackDelegate lastPageLoaded];
            }
        }
    }
}

#pragma mark 获取数据失败回调
- (void)apiLoadFail {
    NSLog(@"apiLoadFail   %@", self.apiError.domain);
}

#pragma mark 数据请求
- (void)request {
    [self loadApiDataByParam:nil];
}


@end
