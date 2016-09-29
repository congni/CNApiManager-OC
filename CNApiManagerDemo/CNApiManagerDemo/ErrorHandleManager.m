//
//  ErrorHandleManager.m
//  CNApiManagerDemo
//
//  Created by 葱泥 on 16/9/28.
//  Copyright © 2016年 quanXiang. All rights reserved.
//

#import "ErrorHandleManager.h"


static NSInteger SUCCESS_CODE = 0;


@implementation ErrorHandleManager


#pragma mark -- CNNetworkErrorDelegate
#pragma mark 错误处理
- (ResultModel *)networkHandleRecevieData:(id)responseObject requestOperation:(NSURLSessionDataTask *)sessionDataTask error:(NSError *)error {
    ResultModel *resultModel = [[ResultModel alloc] init];
    
    if (error) {
        NSString *msg = [self networkErrorDescription:error.code];
        resultModel.error = [NSError errorWithDomain:msg code:error.code userInfo:nil];
        
        return resultModel;
    }
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)sessionDataTask.response;

    if (httpResponse.statusCode != 200 || responseObject == nil) {
        // 操作失败
        NSString *msg = [self networkErrorDescription:1000000];
        NSError *error = [[NSError alloc] initWithDomain:msg code:1000000 userInfo:nil];
        resultModel.error = error;
        
        return resultModel;
    }
    
    NSInteger resultStatueCode = [[[responseObject valueForKey:@"result"] valueForKey:@"code"] integerValue];
    
    if (resultStatueCode == SUCCESS_CODE) {
        // 操作成功
        resultModel.result = [responseObject valueForKey:@"data"];
    } else if (resultStatueCode == 112) {
        // 操作失败
        NSString *msg = [self networkErrorDescription:resultStatueCode];
        NSError *error = [[NSError alloc] initWithDomain:msg code:resultStatueCode userInfo:nil];
        resultModel.error = error;
    } else {
        // 操作失败
        NSString *msg = [self networkErrorDescription:resultStatueCode];
        NSError *error = [[NSError alloc] initWithDomain:msg code:resultStatueCode userInfo:nil];
        resultModel.error = error;
    }
    
    return resultModel;
}

#pragma mark 无网络操作
- (ResultModel *)noNetwork {
    ResultModel *resultModel = [[ResultModel alloc] init];
    resultModel.error = [[NSError alloc] initWithDomain:@"无网络" code:1000 userInfo:nil];
    
    //    [CNToastView toastWithText:@"无网络"];
    
    return resultModel;
}

#pragma mark 错误提示
- (NSString *)networkErrorDescription:(NSInteger)statueCode {
    NSString *statueCodeString = [NSString stringWithFormat:@"%@", @(statueCode)];
    
    if (!_errorMsgDictionary) {
        _errorMsgDictionary = @{@"10000": @"姓名必须填写",
                                @"10001": @"手机号码格式不正确",
                                @"10003": @"该手机已被注册",
                                @"10004": @"电话号码格式不正确",
                                @"10005": @"邮箱格式不正确",
                                @"10006": @"身份证格式不正确"};
    }
    
    if ([[_errorMsgDictionary allKeys] containsObject:statueCodeString]) {
        return [_errorMsgDictionary objectForKey:statueCodeString];
    }
    
    return @"服务器异常";
}

@end
