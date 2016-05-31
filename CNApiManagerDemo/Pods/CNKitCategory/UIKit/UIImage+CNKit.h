//
//  UIImage+CNKit.h
//  SalesAssistantApp
//
//  Created by haoju-congni on 15/1/13.
//  Copyright (c) 2015年 好居. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CNKit)

/**
 *  图片缩放
 *
 *  @param size 缩放大小
 *
 *  @return self
 */
- (UIImage *)scaleToSize:(CGSize)size;

/**
 *  view转换成Image
 *
 *  @param view 要添加阴影效果的view
 */
+(UIImage *)getImageFromView:(UIView *)view;

/**
 通用按钮
 */
+ (UIImage *)normalBtnBackgroudImgForStatue:(float)w height:(float)h color:(NSString *)colorStr;
+ (UIImage *)normalBtnBackgroudImgForStatue:(float)w height:(float)h color:(NSString *)colorStr alpha:(float)al;

/**
 *  创建UIImage
 *
 *  @param imageName 图片名
 *
 *  @return 拉伸好的图片
 */
+ (UIImage *)resizableImageWithName:(NSString *)imageName;
@end
