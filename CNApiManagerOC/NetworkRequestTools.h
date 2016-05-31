//
//  NetworkRequestTools.h
//  cocoapodsTest
//
//  Created by 葱泥 on 15/4/2.
//  Copyright (c) 2015年 好居;. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>


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

- (NSString *)networkErrorDescription:(NSInteger)statueCode;
- (ResultModel *)networkHandleRecevieData:(id)responseObject requestOperation:(AFHTTPRequestOperation *)afRequestOperation;

@end

@interface ResultModel : NSObject

@property (nonatomic, strong) NSError *error;
@property (nonatomic, strong) NSObject *result;

@end

@interface NetworkRequestTools : NSObject

+ (id)instance;

/**
 *  网络请求  完整
 *
 *  @param url             url地址  后半部分
 *  @param params_MulDict  参数
 *  @param httpMethod      请求方式
 *  @param isHaveFileBool  是否有文件需要上传（文件会以NSData的方式存在params_MulDict参数字典中）
 *  @param completionBlock 成功回调
 *  @param errorBlock      错误回调
 *
 *  @return AFHTTPRequestOperation
 */
+ (AFHTTPRequestOperation *)requestWithURL:(NSString *)url params:(NSMutableDictionary *)params_MulDict httpMethod:(HttpMethod)httpMethod  isHaveFile:(BOOL)isHaveFileBool completionBlock:(CompletionLoad)completionBlock errorBlock:(RequestError)errorBlock;

/**
 *  网络请求  精简file  默认是没有文件上传的
 *
 *  @param url             url地址  后半部分
 *  @param params_MulDict  参数
 *  @param httpMethod      请求方式
 *  @param completionBlock 成功回调
 *  @param errorBlock      错误回调
 *
 *  @return AFHTTPRequestOperation
 */
+ (AFHTTPRequestOperation *)requestWithURL:(NSString *)url params:(NSMutableDictionary *)params_MulDict httpMethod:(HttpMethod)httpMethod completionBlock:(CompletionLoad)completionBlock errorBlock:(RequestError)errorBlock;

/**
 *  网络请求  精简file、参数 默认是没有文件上传的
 *
 *  @param url             url地址  后半部分
 *  @param httpMethod      请求方式
 *  @param completionBlock 成功回调
 *  @param errorBlock      错误回调
 *
 *  @return AFHTTPRequestOperation
 */
+ (AFHTTPRequestOperation *)requestWithURL:(NSString *)url httpMethod:(HttpMethod)httpMethod completionBlock:(CompletionLoad)completionBlock errorBlock:(RequestError)errorBlock;

/**
 *    没有头文件的并且值是直接返回的
 *
 *    @param url             url地址  后半部分
 *    @param params_MulDict  参数
 *    @param httpMethod      请求方式
 *    @param completionBlock 成功回调
 *    @param errorBlock      错误回调
 *
 *    @return AFHTTPRequestOperation
 */
+ (AFHTTPRequestOperation *)requestWithOutHeaderAndDataOprationWithURL:(NSString *)url params:(NSMutableDictionary *)params_MulDict httpMethod:(HttpMethod)httpMethod  completionBlock:(CompletionLoad)completionBlock errorBlock:(RequestError)errorBlock;

/**
 *  网络系统配置  完整
 *
 *  @param headers_MulDict 自定义的header
 *  @param getHeaders_Arr  需要从api中获取的headers关键词
 *  @param baseURL         基础URL
 */
+ (void)afHTTPRequestSettingWithRequestHeader:(NSMutableDictionary *)headers_MulDict GetHeaderForHeaderSetting:(NSArray *)getHeaders_Arr baseURL:(NSString *)baseURL;

/**
 *  网络系统配置  精简
 *
 *  @param headers_MulDict 自定义的header
 *  @param baseURL         基础URL
 */
+ (void)afHTTPRequestSettingWithRequestHeader:(NSMutableDictionary *)headers_MulDict baseURL:(NSString *)baseURL;

/**
 *    是否需要对数据进行Log操作  默认是不处理的
 *
 *    @param needLog YES 需要操作  NO不需要操作
 */
+ (void)afHttpRequestDataNeedLog:(BOOL)needLog;

/**
 *  错误处理机制
 *
 *  @param handle CNNetworkErrorDelegate 对象
 */
+ (void)afHttpRequestHandleDataSetting:(id<CNNetworkErrorDelegate>)handle;

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
 *  检查是否有网络
 *
 *  @return BOOL
 */
+ (BOOL)isExistenceNetWork;

@end
