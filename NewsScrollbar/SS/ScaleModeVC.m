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
    
    [self setBasicsParameter:^(NSArray *__autoreleasing *titles, CGFloat *title_space, UIFont *__autoreleasing *title_font, UIColor *__autoreleasing *title_bgColor, UIColor *__autoreleasing *title_sel_color, UIColor *__autoreleasing *title_deSel_color, CGFloat *title_scroll_h, UIColor *__autoreleasing *title_scroll_bgColor, NSArray *__autoreleasing *vcNames, NSInteger *selectIndex, effectMode *mode)
     {
         //必须设置的参数
         *titles = @[@"军事",@"科技范",@"哈哈第三方士大夫",@"OK",@"嘻嘻",@"德玛西亚万岁"];
         *vcNames = @[@"TabVC1",@"SameVC",@"TabVC2",@"SameVC",@"SameVC",@"SameVC"];
         //可选参数的设置
         *selectIndex = 2;
         *title_deSel_color = [UIColor blueColor];
         *title_sel_color = [UIColor orangeColor];
//         *mode = titleColorGradientMode;
     }];
//    [self setOtherMode:scaleMode parameter:nil];
    [self setOtherMode:underLineMode parameter:@(2.0)];
//    [self setOtherMode:coverMode parameter:[UIColor yellowColor]];
}


@end
