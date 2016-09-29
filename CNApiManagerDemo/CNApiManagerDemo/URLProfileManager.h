//
//  URLProfileManager.h
//  CNApiManagerDemo
//
//  Created by 葱泥 on 16/9/28.
//  Copyright © 2016年 葱泥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLProfileManager : NSObject

/**
 数据字典 URL

 @return URL地址
 */
+ (NSString *)dataMapURL;


/**
 广告地址

 @return  URL 地址
 */
+ (NSString *)advertiseURL;

@end
