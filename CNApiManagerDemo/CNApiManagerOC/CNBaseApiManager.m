//
//  CNBaseApiManager.m
//  IOSFrameLibrary
//
//  Created by haoju-congni on 15/9/8.
//  Copyright (c) 2015年 Yu Biao. All rights reserved.
//

#import "CNBaseApiManager.h"
#import <objc/runtime.h>
#import "AFNetworking/AFNetworking.h"


@implementation CNBaseApiManager
@synthesize isSupportNextPage = _isSupportNextPage;
@synthesize firstPageIndex = _firstPageIndex;


#pragma mark - LifeCycle
#pragma mark init
- (instancetype)init {
    self = [super init];
    if (self) {
        NSString *className = [[NSString alloc] initWithUTF8String:class_getName([self class])];
        NSString *superClassName = [[NSString alloc] initWithUTF8String:class_getName([CNBaseApiManager class])];
        self.sessionDataTaskMulArray = [NSMutableArray new];
        
        if ([className isEqualToString:superClassName]) {
            isSubClass = NO;
            [self initDataForSelf];
        } else {
            //当前是子类  一定要子类继承protocol
            isSubClass = YES;
            self.child = self;
            [self.child initData];
        }
    }
    return self;
}

#pragma mark dealloc
- (void)dealloc {
    [self cancel];
}

#pragma mark - Public Method
#pragma mark 开始请求api
- (void)loadApiDataByParam:(NSDictionary *)paramDictionary {
    if (!self.requestURL) {
        NSAssert(NO, @"url地址没有填写");
    }
    
    if (paramDictionary == nil) {
        self.apiParamMulDictionary = [[NSMutableDictionary alloc] init];
        paramDictionary = [[NSMutableDictionary alloc] init];
    } else {
        self.apiParamMulDictionary = [NSMutableDictionary dictionaryWithDictionary:paramDictionary];
    }
    
   __block NSURLSessionDataTask *sessionDataTask = [NetworkRequestTools requestWithURL:self.requestURL params:[self judgeNeedPage:[NSMutableDictionary dictionaryWithDictionary:paramDictionary]] httpMethod:self.httpMethod completionBlock:^(NSObject *result) {
        self.rawData = result;
       
       if (isSubClass && self.apiCallBackDelegate) {
           if ([self.child respondsToSelector:@selector(apiLoadSuccess)]) {
               [self.child apiLoadSuccess];
           }
       }
       
       if ([self.apiCallBackDelegate respondsToSelector:@selector(apiLoadSuccess)]) {
           [self.apiCallBackDelegate apiLoadSuccess];
       } else if ([self.apiCallBackDelegate respondsToSelector:@selector(apiLoadSuccessByApiManager:)]) {
           [self.apiCallBackDelegate apiLoadSuccessByApiManager:self];
       }
       
       if (self.isSupportNextPage) {
           self.currentPage = self.nextPageIndex;
           self.nextPageIndex = self.currentPage + 1;
       }
       
       [self.sessionDataTaskMulArray removeObject:sessionDataTask];
    } errorBlock:^(NSError *error) {
        if (sessionDataTask.state == NSURLSessionTaskStateCanceling) {
            return;
        }
        
        self.apiError = error;
        
        if (isSubClass && self.apiCallBackDelegate) {
            if ([self.child respondsToSelector:@selector(apiLoadFail)]) {
                [self.child apiLoadFail];
            }
        }

        if ([self.apiCallBackDelegate respondsToSelector:@selector(apiLoadFail)]) {
            [self.apiCallBackDelegate apiLoadFail];
        } else if ([self.apiCallBackDelegate respondsToSelector:@selector(apiLoadFailByApiManager:)]) {
            [self.apiCallBackDelegate apiLoadFailByApiManager:self];
        }
        
        [self.sessionDataTaskMulArray removeObject:sessionDataTask];
    }];
    
    if (sessionDataTask) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            // 取消之前的数据请求
            [self.sessionDataTaskMulArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSURLSessionDataTask *preSessionDataTask = obj;
                if ([preSessionDataTask.currentRequest.URL.absoluteString isEqual:sessionDataTask.currentRequest.URL.absoluteString]) {
                    [preSessionDataTask cancel];
                    [self.sessionDataTaskMulArray removeObject:preSessionDataTask];
                }
            }];
            
            [self.sessionDataTaskMulArray addObject:sessionDataTask];
        });
    }
}

#pragma mark 下一页
- (void)loadNextPage {
    if (self.isSupportNextPage) {
        if (!self.isLastPage) {
            [self loadApiDataByParam:self.apiParamMulDictionary];
        }
    } else {
        NSAssert(NO, @"你不设置isSupportNextPage，还加载毛下一页啊");
    }
}

#pragma mark 刷新
- (void)refreshLoad {
    if (self.isSupportNextPage) {
        self.currentPage = self.nextPageIndex = self.firstPageIndex;
    }
    
    [self loadApiDataByParam:self.apiParamMulDictionary];
}

#pragma mark 停止被页面的API数据请求
- (void)cancel {
    while (self.sessionDataTaskMulArray.count > 0) {
        NSURLSessionDataTask *sessionDataTask = self.sessionDataTaskMulArray[0];
        [sessionDataTask cancel];
        [self.sessionDataTaskMulArray removeObject:sessionDataTask];
    }
}

#pragma mark - Private Method
#pragma mark 数据初始化
- (void)initDataForSelf {
    self.httpMethod = POST;
    self.currentPage = self.firstPageIndex = 1;
    self.dataCountForPage = 10;
    self.isSupportNextPage = NO;
}

#pragma mark 分页判断操作
- (NSMutableDictionary *)judgeNeedPage:(NSMutableDictionary *)params {
    if (self.isSupportNextPage) {
        [params setObject:@(self.nextPageIndex) forKey:self.pageParamKey];
        [params setObject:@(self.dataCountForPage) forKey:self.pageCountsKey];
    }
    
    return params;
}

#pragma mark - Setter/Getter firstPageIndex
- (void)setFirstPageIndex:(NSUInteger)firstPageIndex {
    _firstPageIndex = firstPageIndex;
    self.currentPage = firstPageIndex;
    self.nextPageIndex = firstPageIndex;
}

- (NSUInteger)firstPageIndex {
    return _firstPageIndex;
}

@end
