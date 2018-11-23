//
//  LoadingView.m
//  NewsScrollbar
//
//  Created by 杜文亮 on 2018/3/3.
//  Copyright © 2018年 杜文亮. All rights reserved.
//

#import "SSLoadingView.h"

@implementation SSLoadingView

-(instancetype)initWithFrame:(CGRect)frame count:(NSInteger)count
{
    if (self = [super initWithFrame:frame])
    {
        CGFloat width = frame.size.width / count;
        for (int i = 0; i < count; i++)
        {
            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 60)];
            lab.center = CGPointMake(i*width + width/2, frame.size.height/2);
            lab.text = @"加载中。。。";
            lab.textAlignment = NSTextAlignmentCenter;
            [self addSubview:lab];
        }
    }
    return self;
}

@end
