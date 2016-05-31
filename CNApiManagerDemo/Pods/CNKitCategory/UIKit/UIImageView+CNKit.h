//
//  UIImageView+CNKit.h
//  SalesAssistantApp
//
//  Created by haoju-congni on 15/1/13.
//  Copyright (c) 2015年 好居. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (CNKit)


/**
 *  创建线条
 *
 *  @param frame    大小
 *  @param colorStr 颜色
 *  @param alpha    透明度
 *  @param isH      是否是横向的
 *
 *  @return UIImgaeView
 */
+ (instancetype)initWithFrameForLineImageView:(CGRect)frame Color:(NSString *)colorStr alpha:(float)alpha;

/**
 *  换色
 *
 *  @param colorStr 颜色
 *  @param alpha    透明度
 */
- (void)drawLineWithColor:(NSString *)colorStr alpha:(float)alpha;

@end
