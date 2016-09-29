//
//  AdverApiManager.h
//  CNApiManagerDemo
//
//  Created by 葱泥 on 16/9/28.
//  Copyright © 2016年 葱泥. All rights reserved.
//

#import "CNBaseApiManager.h"

static NSString *kApiManagerNameAdver = @"kApiManagerNameAdver";

@interface AdverApiManager : CNBaseApiManager<ApiParamProtocol>

@property (nonatomic, strong) NSMutableArray *mulArray;

/**
 数据请求
 */
- (void)request;

@end
