//
//  TitleLab.m
//  NewsScrollbar
//
//  Created by 杜文亮 on 2018/3/2.
//  Copyright © 2018年 杜文亮. All rights reserved.
//

#import "TitleLab.h"

@implementation TitleLab

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    [_fillColor set];
    rect.size.width = rect.size.width * _progress;
    UIRectFillUsingBlendMode(rect, kCGBlendModeSourceIn);
//    NSLog(@"%@------%.2f",_fillColor,rect.size.width);
}

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

-(void)titleClickAction:(UITapGestureRecognizer *)tap
{
    if (self.titleClick)
    {
        self.titleClick(tap.view.tag);
    }
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    
    [self setNeedsDisplay];
}

@end
