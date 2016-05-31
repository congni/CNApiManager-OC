//
//  UIImage+CNKit.m
//  SalesAssistantApp
//
//  Created by haoju-congni on 15/1/13.
//  Copyright (c) 2015年 好居. All rights reserved.
//

#import "UIImage+CNKit.h"
#import "UIColor+CNKit.h"
#import "UIView+CNKit.h"

@implementation UIImage (CNKit)

#pragma mark 图片缩小
- (UIImage *)scaleToSize:(CGSize)size
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

#pragma mark view转换成Image
+(UIImage *)getImageFromView:(UIView *)view
{
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark 创建纯色UIImage
+ (UIImage *)normalBtnBackgroudImgForStatue:(float)w height:(float)h color:(NSString *)colorStr
{
    return [UIImage normalBtnBackgroudImgForStatue:w height:h color:colorStr alpha:1.0];
}

#pragma mark  创建纯色UIImage
+ (UIImage *)normalBtnBackgroudImgForStatue:(float)w height:(float)h color:(NSString *)colorStr alpha:(float)al
{
    UIView *imgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
    imgView.backgroundColor = [UIColor colorWithHexString:colorStr];
    imgView.alpha = al;
    
    UIImage *bgImg = [UIImage getImageFromView:imgView];
    
    return bgImg;
}

+ (UIImage *)resizableImageWithName:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
}

@end
