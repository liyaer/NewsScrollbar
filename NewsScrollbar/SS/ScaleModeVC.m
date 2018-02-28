//
//  ScaleModeVC.m
//  NewsScrollbar
//
//  Created by 杜文亮 on 2018/2/26.
//  Copyright © 2018年 杜文亮. All rights reserved.
//

#import "ScaleModeVC.h"

@interface ScaleModeVC ()

@end

@implementation ScaleModeVC

- (void)viewDidLoad
{
    //子类先调用父类的viewDidLoad，这里的父类是：SSNewsScrollVC。SSNewsScrollVC将初始化工作放在了viewWillAppear，因为初始化需要这里提供的参数，保证一个先后顺序
    [super viewDidLoad];
    
    [self setScaleModeParameter:^(NSArray *__autoreleasing *titles, CGFloat *title_space, UIFont *__autoreleasing *title_font, UIColor *__autoreleasing *title_bgColor, UIColor *__autoreleasing *title_sel_color, UIColor *__autoreleasing *title_deSel_color, CGFloat *title_scroll_h, UIColor *__autoreleasing *title_scroll_bgColor, NSArray *__autoreleasing *vcNames, NSInteger *selectIndex, CGFloat *scale)
    {
        *titles = @[@"军事",@"科技范",@"哈哈第三方士大夫",@"OK",@"嘻嘻",@"德玛西亚万岁"];
        *vcNames = @[@"TabVC1",@"SameVC",@"TabVC2",@"SameVC",@"SameVC",@"SameVC"];
        *selectIndex = 2;
    }];
    
    //错误的写法，无法达到效果，必须传地址（或者叫引用、reference）才行
//    [self setScaleParameter:^(NSArray *titles)
//    {
//        titles = @[@"军事",@"科技范",@"哈哈第三方士大夫",@"OK",@"嘻嘻"];
//    }];
}


@end
