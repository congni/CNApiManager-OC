//
//  CNBaseApiManager.h
//  IOSFrameLibrary
//
//  Created by haoju-congni on 15/9/8.
//  Copyright (c) 2015年 Yu Biao. All rights reserved.
/**
 *    此类是NetworkRequestTools的延伸类，其目的在于更加简化、安全的调用网络数据
 *    使用此类需要注意一下几点：
 *    1、直接调用此类，需要设置相关参数，如requestURL、httpMethod；
 *    2、继承此类的子类，需要同时实现ApiLoadCallBackProtocol、ApiParamProtocol两个协议，用于数据回调和参数设定
 */

#import <Foundation/Foundation.h>
#import "NetworkRequestTools.h"


@class CNBaseApiManager;
@protocol ApiLoadCallBackProtocol <NSObject>
@optional
/**
 *    api加载成功回调
 */
- (void)apiLoadSuccess;

- (void)apiLoadSuccessByApiManager:(CNBaseApiManager *)apiManager;

/**
 *    api加载失败回调
 */
- (void)apiLoadFail;

- (void)apiLoadFailByApiManager:(CNBaseApiManager *)apiManager;

/**
 *    最后一页被调用了，当触发这个delegate的时候，UI层需要删除下一页的Refresh等相关操作
 */
- (void)lastPageLoaded;

@end

@protocol ApiParamProtocol <NSObject>
/**
 *    如果是集成此类的子类，必须重写此方法
 *    参数设置包括:requestURL、httpMethod
 *    如果支持分页则参数还要包括:firstPageIndex、pageParamKey、pageCountsKey、pageCount
 */
- (void)initData;
@end

@class NetworkRequestTools;

@interface CNBaseApiManager : NSObject {
    BOOL isSubClass;
}

@property (nonatomic, strong) NSMutableDictionary *apiParamMulDictionary;

/**
 *  api回调的Delegate
 */
@property (nonatomic, weak) id<ApiLoadCallBackProtocol>apiCallBackDelegate;
/**
 *  子类
 */
@property (nonatomic, weak) id child;
/**
 *  请求URL地址  NSString类型
 */
@property (nonatomic, strong) NSString *requestURL;
/**
 *  请求方法
 */
@property (nonatomic, assign) HttpMethod httpMethod;
/**
 *  apiManager 名称标示
 */
@property (nonatomic, strong) NSString *apiName;
/**
 *  api请求容器
 */
@property (nonatomic, strong) NSMutableArray *afOpertation_MulArr;
/**
 *  是否支持分页
 */
@property (nonatomic, assign) BOOL isSupportNextPage;
/**
 *  是否最后一页
 */
@property (nonatomic, assign) BOOL isLastPage;
/**
 *  当前分页数
 */
@property (nonatomic, assign) NSUInteger currentPage;
/**
 *  下一页
 */
@property (nonatomic, assign) NSUInteger nextPageIndex;
/**
 *  分页的key
 */
@property (nonatomic, strong) NSString *pageParamKey;
/**
 *  第一页
 */
@property (nonatomic, assign) NSUInteger firstPageIndex;
/**
 *  每页数量的key
 */
@property (nonatomic, strong) NSString *pageCountsKey;
/**
 *  总有多少条数据
 */
@property (nonatomic, assign) NSUInteger dataCount;
/**
 *  每页的数据
 */
@property (nonatomic, assign) NSUInteger dataCountForPage;
/**
 *  从api那获取的原始数据
 */
@property (nonatomic, strong) id rawData;
/**
 *  api错误
 */
@property (nonatomic, strong) NSError *apiError;
/**
 *  是否需要添加Header头
 */
@property (nonatomic, assign) BOOL isHeader;

/**
 *  开始请求api
 *
 *  @param paramDict 请求参数  如果是分页的，参数里面不带分页key
 */
- (void)loadApiDataByParam:(NSMutableDictionary *)paramDictionary;
/**
 *  下一页
 */
- (void)loadNextPage;
/**
 *  刷新
 */
- (void)refreshLoad;
/**
 *  停止被页面的API数据请求
 */
- (void)cancel;

@end
