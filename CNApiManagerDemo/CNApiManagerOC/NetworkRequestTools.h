//
//  NetworkRequestTools.h
//  cocoapodsTest
//
//  Created by 葱泥 on 15/4/2.
//  Copyright (c) 2015年 好居;. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking/AFNetworking.h"
#import "ResultModel.h"


/**
 *  使用须知
 *  1、使用前，需先做网络请求配置
 */


typedef void(^CompletionLoad)(NSObject *result);
typedef void(^RequestError)(NSError *error);


typedef enum : NSUInteger {
    GET = 1,
    POST
} HttpMethod;


@class ResultModel;

@protocol CNNetworkErrorDelegate <NSObject>

/**
 根据错误 code, 获取问题描述

 @param statueCode 错误码

 @return 问题描述
 */
- (NSString *)networkErrorDescription:(NSInteger)statueCode;


/**
 数据处理

 @param responseObject   api 返回收
 @param sessionDataTask  NSURLSessionDataTask对象
 @param error           错误

 @return ResultModel
 */
- (ResultModel *)networkHandleRecevieData:(id)responseObject requestOperation:(NSURLSessionDataTask *)sessionDataTask error: (NSError *)error;


/**
 获取无网络的ResultModel数据

 @return ResultModel
 */
- (ResultModel *)noNetwork;

@end


@interface NetworkRequestTools : NSObject

+ (id)instance;

/**
 数据请求

 @param url              url地址  后半部分
 @param paramsDictionary 参数
 @param httpMethod       请求方式
 @param completionBlock  成功回调
 @param errorBlock       错误回调

 @return NSURLSessionDataTask
 */
+ (NSURLSessionDataTask *)requestWithURL:(NSString *)url params:(NSDictionary *)paramsDictionary httpMethod:(HttpMethod)httpMethod  completionBlock:(CompletionLoad)completionBlock errorBlock:(RequestError)errorBlock ;

/**
 *  网络系统配置  完整
 *
 *  @param headers_MulDict 自定义的header
 *  @param getHeaders_Arr  需要从api中获取的headers关键词
 */
+ (void)afHTTPRequestSettingWithRequestHeader:(NSMutableDictionary *)headersMulDictionary GetHeaderForHeaderSetting:(NSArray *)getHeadersArray;

/**
 *  网络系统配置  精简
 *
 *  @param headers_MulDict 自定义的header
 */
+ (void)afHTTPRequestSettingWithRequestHeader:(NSMutableDictionary *)headersMulDictionary;

/**
 *    是否需要对数据进行Log操作  默认是不处理的
 *
 *    @param needLog YES 需要操作  NO不需要操作
 */
+ (void)afHttpRequestDataNeedLog:(BOOL)needLog;

/**
 *  错误处理机制(注: 必须设置)
 *
 *  @param handle CNNetworkErrorDelegate 对象
 */
+ (void)afHttpRequestHandleDataSetting:(id<CNNetworkErrorDelegate>)handle;

/**
 基础参数配置(此参数和业务参数是分离的, 只作为基础请求参数, 发送给服务端)

 @param baseParamsDictionary 基础参数
 */
+ (void)afHttpRequestBaseParamsSetting:(NSDictionary *)baseParamsDictionary;

/**
 超时时间设置(注: 可不设置, 默认为60s)

 @param timeoutInterval 超时时间设置
 */
+ (void)afHttpRequestTimeoutInterval:(CGFloat)timeoutInterval;

/**
 *  isStoreHeadersForGet
 *
 *  @return 存在就YES 不存在就NO
 */
+ (BOOL)isStoreHeadersForGet;

/**
 *  删除存储的头信息
 */
+ (void)removeGetHeaderData;

/**
 *  获取错误处理文件
 *
 *  @return 错误处理文件
 */
+ (id<CNNetworkErrorDelegate>)networkErrorHandle;

/**
 *  检查是否有网络
 *
 *  @return BOOL
 */
+ (BOOL)isExistenceNetWork;

@end
