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


@implementation NetworkRequestTools
#define AFLog(...) NSLog(__VA_ARGS__)


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

#pragma mark -- 数据请求
+ (AFHTTPRequestOperation *)requestWithURL:(NSString *)url params:(NSMutableDictionary *)params_MulDict httpMethod:(HttpMethod)httpMethod  isHaveFile:(BOOL)isHaveFileBool completionBlock:(CompletionLoad)completionBlock errorBlock:(RequestError)errorBlock {
    
    AFHTTPRequestOperation * operation = nil;
    
    //FIXME: 暂时不做baseURL
    NSString *requestURL = url;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 60.0;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
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
    
    
    NSLog(@"httpMethod  %@",@(httpMethod));
    if (httpMethod == GET) {
        operation = [manager GET:requestURL parameters:params_MulDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (isNeedLog) {
                AFLog(@"数据请求  responseObject  %@",responseObject);
            }
            
            [self didGetHeaders:operation.response.allHeaderFields];
            ResultModel *resultModel = [networkHandle networkHandleRecevieData:responseObject requestOperation:operation];
            
            if (resultModel.error) {
                if (errorBlock) {
                    errorBlock(resultModel.error);
                }
            } else {
                if (completionBlock) {
                    completionBlock(resultModel.result);
                }
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (errorBlock) {
                errorBlock(error);
            }
        }];
    } else if (httpMethod == POST) {
        operation = [manager POST:requestURL parameters:params_MulDict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            if (isHaveFileBool) {
                for (NSString *key in params_MulDict) {
                    
                    id value = params_MulDict[key];
                    
                    if ([value isKindOfClass:[NSData class]]) {
                        
                        [formData appendPartWithFileData:value
                         
                                                    name:key
                         
                                                fileName:key
                         
                                                mimeType:@"image/jpeg"];
                        
                    }
                }
            }
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (isNeedLog) {
                AFLog(@"数据请求  responseObject  %@",responseObject);
            }
            
            [self didGetHeaders:operation.response.allHeaderFields];
            ResultModel *resultModel = [networkHandle networkHandleRecevieData:responseObject requestOperation:operation];
            
            if (resultModel.error) {
                if (errorBlock) {
                    errorBlock(resultModel.error);
                }
            } else {
                if (completionBlock) {
                    completionBlock(resultModel.result);
                }
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if (errorBlock) {
                errorBlock(error);
            }
        }];
    }
    
    operation.responseSerializer =[AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableContainers];
    
#pragma mark 修复AFNetworking2.0的相关BUG的代码  http://blog.csdn.net/dengbin9009/article/details/43485617
    operation.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    return operation;
}

+ (AFHTTPRequestOperation *)requestWithURL:(NSString *)url params:(NSMutableDictionary *)params_MulDict httpMethod:(HttpMethod)httpMethod completionBlock:(CompletionLoad)completionBlock errorBlock:(RequestError)errorBlock {
    AFHTTPRequestOperation * operation = nil;
    
    operation = [NetworkRequestTools requestWithURL:url params:params_MulDict httpMethod:httpMethod isHaveFile:NO completionBlock:^(NSObject *result) {
        if (completionBlock) {
            completionBlock(result);
        }
    } errorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    }];
    
    return operation;
}

+ (AFHTTPRequestOperation *)requestWithURL:(NSString *)url httpMethod:(HttpMethod)httpMethod completionBlock:(CompletionLoad)completionBlock errorBlock:(RequestError)errorBlock {
    AFHTTPRequestOperation * operation = nil;
    operation = [NetworkRequestTools requestWithURL:url params:nil httpMethod:httpMethod isHaveFile:NO completionBlock:^(NSObject *result) {
        if (completionBlock) {
            completionBlock(result);
        }
    } errorBlock:^(NSError *error) {
        if (errorBlock) {
            errorBlock(error);
        }
    }];
    return operation;
}

#pragma mark 添加自定义的headers  并且设置需要从headers重获取相应的数据 以设置headers  基础网络连接地址
+ (void)afHTTPRequestSettingWithRequestHeader:(NSMutableDictionary *)headersMulDictionary GetHeaderForHeaderSetting:(NSArray *)getHeadersArray baseURL:(NSString *)baseURL {
    if (![headerMulDictionary isEqualToDictionary:headersMulDictionary]) {
        headerMulDictionary = headersMulDictionary;
    }
    
    if (![getHeadersFieldArray isEqualToArray:getHeadersArray]) {
        getHeadersFieldArray = getHeadersArray;
    }
    
    if (![baseURLString isEqualToString:baseURL]) {
        baseURLString = baseURL;
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
+ (void)afHTTPRequestSettingWithRequestHeader:(NSMutableDictionary *)headersMulDictionary baseURL:(NSString *)baseURL {
    
    if (![headerMulDictionary isEqualToDictionary:headersMulDictionary]) {
        headerMulDictionary = headersMulDictionary;
    }
    
    if (![baseURLString isEqualToString:baseURL]) {
        baseURLString = baseURL;
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

#pragma mark 删除存储的头信息
+ (void)removeGetHeaderData {
    if ([self CheckUserDefaultDataWithKey:getHeadersFieldCache]) {
        [self didRemoveUserDefaultsDataWithKey:getHeadersFieldCache];
    }
}

#pragma -mark 判断是否有网络
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
