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

#pragma mark init
- (instancetype)init {
    self = [super init];
    if (self) {
        NSString *className = [[NSString alloc] initWithUTF8String:class_getName([self class])];
        NSString *superClassName = [[NSString alloc] initWithUTF8String:class_getName([CNBaseApiManager class])];
        self.afOpertation_MulArr = [NSMutableArray new];
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

#pragma mark 数据初始化
- (void)initDataForSelf {
    self.httpMethod = POST;
    self.currentPage = self.firstPageIndex = 1;
    self.dataCountForPage = 10;
    self.isSupportNextPage = NO;
}

#pragma mark 开始请求api
- (void)loadApiDataByParam:(NSMutableDictionary *)paramDictionary {
    if (!self.requestURL) {
        NSAssert(NO, @"url地址没有填写");
    }
    
    if (paramDictionary == nil) {
        self.apiParamMulDictionary = [[NSMutableDictionary alloc] init];
        paramDictionary = [[NSMutableDictionary alloc] init];
    } else {
        self.apiParamMulDictionary = paramDictionary;
    }
    
   __block AFHTTPRequestOperation *aff = [NetworkRequestTools requestWithURL:self.requestURL params:[self judgeNeedPage:paramDictionary] httpMethod:self.httpMethod completionBlock:^(NSObject *result) {
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
       
       [self.afOpertation_MulArr removeObject:aff];
    } errorBlock:^(NSError *error) {
        if (aff.cancelled) {
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
        
        [self.afOpertation_MulArr removeObject:aff];
    }];
    
    if (aff) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            // 取消之前的数据请求
            [self.afOpertation_MulArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                AFHTTPRequestOperation *preAffRequestOperation = obj;
                if ([preAffRequestOperation.request.URL.absoluteString isEqual:aff.request.URL.absoluteString]) {
                    [preAffRequestOperation cancel];
                    [self.afOpertation_MulArr removeObject:preAffRequestOperation];
                }
            }];
            
            [self.afOpertation_MulArr addObject:aff];
        });
    }
}

#pragma mark 下一页
- (void)loadNextPage {
    if (self.isSupportNextPage) {
        if (!self.isLastPage) {
            [self loadApiDataByParam:self.apiParamMulDictionary];
        } else {
//            NSLog(@"已经最后一行");
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

#pragma mark 分页判断操作
- (NSMutableDictionary *)judgeNeedPage:(NSMutableDictionary *)params {
    if (self.isSupportNextPage) {
        [params setObject:@(self.nextPageIndex) forKey:self.pageParamKey];
        [params setObject:@(self.dataCountForPage) forKey:self.pageCountsKey];
    }
    return params;
}

#pragma mark -- firstPageIndex设置
- (void)setFirstPageIndex:(NSUInteger)firstPageIndex {
    _firstPageIndex = firstPageIndex;
    self.currentPage = firstPageIndex;
    self.nextPageIndex = firstPageIndex;
}

- (NSUInteger)firstPageIndex {
    return _firstPageIndex;
}

#pragma mark -- 停止被页面的API数据请求
- (void)cancel {
    while (self.afOpertation_MulArr.count > 0) {
        AFHTTPRequestOperation *aff = self.afOpertation_MulArr[0];
        [aff cancel];
        [self.afOpertation_MulArr removeObject:aff];
    }
}

#pragma mark -- dealloc
- (void)dealloc {
    [self cancel];
}

@end
