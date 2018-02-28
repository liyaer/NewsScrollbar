//
//  UIColor+RGB.m
//  NewsScrollbar
//
//  Created by 杜文亮 on 2018/2/28.
//  Copyright © 2018年 杜文亮. All rights reserved.
//

#import "UIColor+RGB.h"

@implementation UIColor (RGB)

+(NSArray *)getRGBFromColor1:(UIColor *)color
{
    CGFloat red = 0.0;
    CGFloat green = 0.0;
    CGFloat blue = 0.0;
    CGFloat alpha = 0.0;
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    NSLog(@"Red: %.2f  Green: %.2f  Blue: %.2f  Alpha: %.2f", red,green,blue,alpha);
    return @[@(red), @(green), @(blue), @(alpha)];
}

+(NSArray *)getRGBFromColor2:(UIColor *)color
{
    CGFloat components[4];
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char resultingPixel[4];
    CGContextRef context = CGBitmapContextCreate(&resultingPixel,
                                                 1,
                                                 1,
                                                 8,
                                                 4,
                                                 rgbColorSpace,
                                                 kCGImageAlphaNoneSkipLast);
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    CGContextRelease(context);
    CGColorSpaceRelease(rgbColorSpace);
    
    for (int component = 0; component < 4; component++)
    {
        components[component] = resultingPixel[component] / 255.0f;
    }
    
    NSLog(@"Red: %.2f  Green: %.2f  Blue: %.2f  Alpha: %.2f", components[0],components[1],components[2],components[3]);
    return @[@(components[0]),@(components[1]),@(components[2]),@(components[3])];
}

+(NSArray *)getRGBFromRgbColor1:(UIColor *)rgbColor
{
    NSArray *rgb;
    //类似[UIColor redColor]这种非RGB方式设置的颜色，无法通过CGColorGetComponents获取颜色空间值（获取的值不准确，所以通过CGColorGetNumberOfComponents过滤掉）！
    NSInteger numComponents = CGColorGetNumberOfComponents(rgbColor.CGColor);
    if (numComponents == 4)
    {
        const CGFloat *components = CGColorGetComponents(rgbColor.CGColor);
        NSLog(@"Red: %.2f  Green: %.2f  Blue: %.2f  Alpha: %.2f", components[0],components[1],components[2],components[3]);
        rgb = @[@(components[0]),@(components[1]),@(components[2]),@(components[3])];
    }
    else
    {
        NSLog(@"本次传的参数是非RGB创建的，该方法无法获取RGB值！");
    }
    return rgb;
}

+(NSMutableArray *)getRGBFromRgbColor2:(UIColor *)rgbColor
{
    NSMutableArray *RGBStrValueArr = [[NSMutableArray alloc] init];
    //获得RGB值描述
    NSString *RGBValue = [NSString stringWithFormat:@"%@", rgbColor];
    //将RGB值描述分隔成字符串
    NSArray *RGBArr = [RGBValue componentsSeparatedByString:@" "];
    if (RGBArr.count == 5)
    {
        for (NSString *str in RGBArr)
        {
            NSString *value = [NSString stringWithFormat:@"%.2f", str.floatValue];
            [RGBStrValueArr addObject:value];
        }
        NSLog(@"Red: %@  Green: %.@  Blue: %.@  Alpha: %@", RGBStrValueArr[1],RGBStrValueArr[2],RGBStrValueArr[3],RGBStrValueArr[4]);
    }
    else
    {
        NSLog(@"本次传的参数是非RGB创建的，该方法无法获取RGB值！");
    }

    //返回保存RGB值的数组
    return RGBStrValueArr;
}

@end
