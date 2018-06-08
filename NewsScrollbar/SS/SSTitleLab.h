//
//  TitleLab.h
//  NewsScrollbar
//
//  Created by 杜文亮 on 2018/3/2.
//  Copyright © 2018年 杜文亮. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^titleClickBlcok)(NSInteger tag);

@interface SSTitleLab : UILabel

@property (nonatomic,copy) titleClickBlcok titleClick;

//颜色滑动渐变所需参数
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, strong) UIColor *fillColor;

@end
