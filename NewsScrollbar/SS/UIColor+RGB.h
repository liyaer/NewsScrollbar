//
//  UIColor+RGB.h
//  NewsScrollbar
//
//  Created by 杜文亮 on 2018/2/28.
//  Copyright © 2018年 杜文亮. All rights reserved.
//

#import <UIKit/UIKit.h>
/*
 *   得到颜色RGB值
 */
@interface UIColor (RGB)

//可以是RGB创建的颜色，也可以是[UIColor blackColor]这种创建的颜色
+(NSArray *)getRGBFromColor1:(UIColor *)color;
+(NSArray *)getRGBFromColor2:(UIColor *)color;

//只能是RGB创建的颜色
+(NSArray *)getRGBFromRgbColor1:(UIColor *)rgbColor;
+(NSMutableArray *)getRGBFromRgbColor2:(UIColor *)rgbColor;

@end
