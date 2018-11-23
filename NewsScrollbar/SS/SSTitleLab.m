//
//  TitleLab.m
//  NewsScrollbar
//
//  Created by 杜文亮 on 2018/3/2.
//  Copyright © 2018年 杜文亮. All rights reserved.
//

#import "SSTitleLab.h"

@implementation SSTitleLab

#pragma mark - 初始化

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleClickAction:)];
        [self addGestureRecognizer:tap];
        self.userInteractionEnabled = YES;
        self.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}




#pragma mark - 绘制相关

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    [_fillColor set];
    rect.size.width = rect.size.width * _progress;
    UIRectFillUsingBlendMode(rect, kCGBlendModeSourceIn);
    //    NSLog(@"%@------%.2f",_fillColor,rect.size.width);
}

//外界根据用户手势通过class.progress不断重设该属性，然后根据用户手势不断进行重绘
- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    
    [self setNeedsDisplay];//会立即调用drawRect方法，进行绘制
}




#pragma mark - 点击事件

-(void)titleClickAction:(UITapGestureRecognizer *)tap
{
    if (self.titleClick)
    {
        self.titleClick(tap.view.tag);
    }
}

@end
