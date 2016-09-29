//
//  NetworkRequestTools.m
//  cocoapodsTest
//
//  Created by 葱泥 on 15/4/2.
//  Copyright (c) 2015年 好居;. All rights reserved.
//

#import "NetworkRequestTools.h"
#import <netdb.h>


static NSUserDefaults *userDefaults = nil;
static id<CNNetworkErrorDelegate> networkHandle = nil;
static NetworkRequestTools *sharedTool = nil;
static NSString *baseURLString;
static NSMutableDictionary *headerMulDictionary = nil;
static NSArray *getHeadersFieldArray = nil;
static NSMutableDictionary *getHeadersFieldMulDictionary = nil;
static NSString *getHeadersFieldCache = @"NetworkRequestTools-getHeadersFieldCache";
static BOOL isNeedLog = NO;
static CGFloat kTimeoutInterval = 60.0;
static NSDictionary *kBaseParamsDictionary = nil;


#ifdef DEBUG
#define CALog(fmt,...) NSLog((@"网络库打印\n" "[函数名]%s\n" "[日志]"fmt"\n"),__FUNCTION__,##__VA_ARGS__);
#else
#define CALog(fmt,...);
#endif


@implementation NetworkRequestTools


#pragma mark - Public Method
#pragma mark 数据请求
+ (NSURLSessionDataTask *)requestWithURL:(NSString *)url params:(NSDictionary *)paramsDictionary httpMethod:(HttpMethod)httpMethod  completionBlock:(CompletionLoad)completionBlock errorBlock:(RequestError)errorBlock {
    if (![NetworkRequestTools isExistenceNetWork]) {
        ResultModel *noNetworkResultModel = [networkHandle noNetwork];
        
        if (noNetworkResultModel.error) {
            if (errorBlock) {
                errorBlock(noNetworkResultModel.error);
            }
        }
        
        return nil;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 超时时间
    manager.requestSerializer.timeoutInterval = kTimeoutInterval;
    // 声明上传的是json格式的参数，需要你和后台约定好，不然会出现后台无法获取到你上传的参数问题
    manager.requestSerializer = [AFJSONRequestSerializer serializer]; // 上传JSON格式
    // 声明获取到的数据格式
    manager.responseSerializer = [AFJSONResponseSerializer serializer]; // AFN会JSON解析返回的数据
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    NSURLSessionDataTask *sessionDataTask = nil;
    //FIXME: 暂时不做baseURL
    NSString *requestURL = url;
    
    if (headerMulDictionary) {
        [headerMulDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [manager.requestSerializer setValue:obj forHTTPHeaderField:key];
        }];
    }
    
    if (getHeadersFieldArray) {
        if (getHeadersFieldMulDictionary) {
            [getHeadersFieldMulDictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                [manager.requestSerializer setValue:obj forHTTPHeaderField:key];
            }];
        } else if ([self CheckUserDefaultDataWithKey:getHeadersFieldCache]) {
            getHeadersFieldMulDictionary = [[NSMutableDictionary alloc] init];
            NSData *cacheData = [self didGeteUserDefaultsDataWithKey:getHeadersFieldCache];
            NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:cacheData];
            getHeadersFieldMulDictionary = [unarchiver decodeObjectForKey:getHeadersFieldCache];
            [unarchiver finishDecoding];
        }
    }
    
    NSLog(@"paramsDictionary  %@", paramsDictionary);
    
    NSMutableDictionary *paramsMulDictionary = [NSMutableDictionary dictionaryWithDictionary:paramsDictionary];
    
    if (kBaseParamsDictionary) {
        [paramsMulDictionary addEntriesFromDictionary:kBaseParamsDictionary];
    }
    
    NSLog(@"paramsMulDictionary  %@", paramsMulDictionary);
    
    if (httpMethod == GET) {
        sessionDataTask = [manager GET:requestURL parameters:paramsMulDictionary progress:^(NSProgress * _Nonnull downloadProgress) {
            // 进度
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self successOpration:task response:responseObject completionBlock:completionBlock errorBlock:errorBlock];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self failOpration:task errorBlock:errorBlock error:error];
        }];
    } else if (httpMethod == POST) {
        sessionDataTask = [manager POST:requestURL parameters:paramsDictionary progress:^(NSProgress * _Nonnull uploadProgress) {
            // 进度
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self successOpration:task response:responseObject completionBlock:completionBlock errorBlock:errorBlock];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [self failOpration:task errorBlock:errorBlock error:error];
        }];
    }
    
    return sessionDataTask;
}

#pragma mark 添加自定义的headers  并且设置需要从headers重获取相应的数据 以设置headers  基础网络连接地址
+ (void)afHTTPRequestSettingWithRequestHeader:(NSMutableDictionary *)headersMulDictionary GetHeaderForHeaderSetting:(NSArray *)getHeadersArray {
    if (![headerMulDictionary isEqualToDictionary:headersMulDictionary]) {
        headerMulDictionary = headersMulDictionary;
    }
    
    if (![getHeadersFieldArray isEqualToArray:getHeadersArray]) {
        getHeadersFieldArray = getHeadersArray;
    }
}

#pragma mark 错误处理机制
+ (void)afHttpRequestHandleDataSetting:(id<CNNetworkErrorDelegate>)handle {
    networkHandle = handle;
}

#pragma mark 是否需要打印数据
+ (void)afHttpRequestDataNeedLog:(BOOL)needLog {
    isNeedLog = needLog;
}

#pragma mark 添加自定义的headers
+ (void)afHTTPRequestSettingWithRequestHeader:(NSMutableDictionary *)headersMulDictionary {
    if (![headerMulDictionary isEqualToDictionary:headersMulDictionary]) {
        headerMulDictionary = headersMulDictionary;
    }
}

#pragma mark 检查是否获取到了Headers的相关数据
+ (BOOL)isStoreHeadersForGet {
    BOOL isStoreHeadersForGet = NO;
    
    if (getHeadersFieldArray) {
        if (getHeadersFieldMulDictionary) {
            isStoreHeadersForGet = YES;
        } else if ([self CheckUserDefaultDataWithKey:getHeadersFieldCache]) {
            getHeadersFieldMulDictionary = [[NSMutableDictionary alloc] init];
            NSData *cacheData = [self didGeteUserDefaultsDataWithKey:getHeadersFieldCache];
            NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:cacheData];
            getHeadersFieldMulDictionary = [unarchiver decodeObjectForKey:getHeadersFieldCache];
            [unarchiver finishDecoding];
            
            isStoreHeadersForGet = YES;
        }
    }
    
    return isStoreHeadersForGet;
}

#pragma mark 超时设定
+ (void)afHttpRequestTimeoutInterval:(CGFloat)timeoutInterval {
    kTimeoutInterval = timeoutInterval;
}

#pragma mark 获取错误处理文件
+ (id<CNNetworkErrorDelegate>)networkErrorHandle {
    return networkHandle;
}

#pragma mark 基础参数设定
+ (void)afHttpRequestBaseParamsSetting:(NSDictionary *)baseParamsDictionary {
    kBaseParamsDictionary = baseParamsDictionary;
}

#pragma mark 删除存储的头信息
+ (void)removeGetHeaderData {
    if ([self CheckUserDefaultDataWithKey:getHeadersFieldCache]) {
        [self didRemoveUserDefaultsDataWithKey:getHeadersFieldCache];
    }
}

#pragma mark 判断是否有网络
+ (BOOL)isExistenceNetWork {
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags) {
        return NO;
    }
    
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    
    return (isReachable && !needsConnection) ? YES : NO;
}

#pragma mark 自己
+ (id)instance {
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        if (sharedTool==nil)
        {
            sharedTool = [[super alloc] init];
        }
    });
    
    return sharedTool;
}


#pragma mark - Private Method
#pragma mark 获取headers
+ (void)didGetHeaders:(NSDictionary *)allHeaderFieldsDictionary {
    if (getHeadersFieldArray) {
        if (!getHeadersFieldMulDictionary) {
            getHeadersFieldMulDictionary = [[NSMutableDictionary alloc] init];
        }
        
        NSMutableDictionary *copyGetHeaderFieldMulDictionary = [getHeadersFieldMulDictionary copy];
        
        [getHeadersFieldArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([[allHeaderFieldsDictionary allKeys] containsObject:obj]) {
                [getHeadersFieldMulDictionary setObject:[allHeaderFieldsDictionary objectForKey:obj] forKey:obj];
            }
        }];
        
        if (![copyGetHeaderFieldMulDictionary isEqualToDictionary:getHeadersFieldMulDictionary]) {
            if ([getHeadersFieldMulDictionary allKeys] > 0) {
                NSMutableData *errorMsg_Data = [[NSMutableData alloc] init];
                NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:errorMsg_Data];
                [archiver encodeObject:getHeadersFieldArray forKey:getHeadersFieldCache];
                [archiver finishEncoding];
                [NetworkRequestTools didSaveUserDefaultsDataWithKey:getHeadersFieldCache value:getHeadersFieldMulDictionary];
            }
        }
    }
}

#pragma mark 成功数据处理
+ (void)successOpration:(NSURLSessionDataTask *)sesionDataTask response:(id)responseObject completionBlock:(CompletionLoad)completionBlock errorBlock:(RequestError)errorBlock {
    if (isNeedLog) {
        CALog(@"数据请求  responseObject  %@",responseObject);
    }
    
    if ([sesionDataTask.response isKindOfClass:[NSHTTPURLResponse class]]) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)sesionDataTask.response;
        [self didGetHeaders:httpResponse.allHeaderFields];
    }
    
    ResultModel *resultModel = [networkHandle networkHandleRecevieData:responseObject requestOperation:sesionDataTask error:nil];
    
    if (resultModel.error) {
        if (errorBlock) {
            errorBlock(resultModel.error);
        }
    } else {
        if (completionBlock) {
            completionBlock(resultModel.result);
        }
    }
}

#pragma mark 失败处理
+ (void)failOpration:(NSURLSessionDataTask *)sesionDataTask errorBlock:(RequestError)errorBlock error:(NSError *)err {
    ResultModel *resultModel = [networkHandle networkHandleRecevieData:nil requestOperation:sesionDataTask error:err];
    
    if (errorBlock) {
        errorBlock(resultModel.error);
    }
}

#pragma mark -- 数据存储
#pragma mark NSUserDefaults本地数据存储 key/value 为nil 则不存储
+ (void)didSaveUserDefaultsDataWithKey:(NSString *)key value:(id)obj
{
    if (key && obj) {
        [NetworkRequestTools initUserDefaults];
        [userDefaults setObject:obj forKey:key];
    }
}

#pragma mark NSUserDefaults本地数据获取 传入的key为nil  则返回nil
+ (id)didGeteUserDefaultsDataWithKey:(NSString *)key {
    if (key) {
        [NetworkRequestTools initUserDefaults];
        id obj = [userDefaults objectForKey:key];
        
        return obj;
    }
    return nil;
}

#pragma mark NSUserDefaults 删除数据
+ (void)didRemoveUserDefaultsDataWithKey:(NSString *)key {
    if (key && [self CheckUserDefaultDataWithKey:key]) {
        [NetworkRequestTools initUserDefaults];
        [userDefaults removeObjectForKey:key];
    }
}

#pragma mark 检查NSUserDefaults 是否有相关的值
+ (BOOL)CheckUserDefaultDataWithKey:(NSString *)key {
    [NetworkRequestTools initUserDefaults];
    BOOL isHaveValue_Bool = NO;
    if (key && [userDefaults objectForKey:key]) {
        isHaveValue_Bool = YES;
    }
    return isHaveValue_Bool;
}

#pragma mark NSUserDefaults一次初始化
+ (void)initUserDefaults {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @autoreleasepool {
            if (userDefaults == nil) {
                userDefaults =[NSUserDefaults standardUserDefaults];
            }
        }
    });
}

@end
