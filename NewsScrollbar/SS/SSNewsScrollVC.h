//
//  SSNewsScrollVC.h
//  NewsScrollbar
//
//  Created by 杜文亮 on 2018/2/7.
//  Copyright © 2018年 杜文亮. All rights reserved.
//


/*
    Scroll + Scroll
    优点：
        可以实现交互动画效果
    缺点：
        1，主要针对首次显示加载子控制器：如果想实现当子控制器显示时才走viewDidLoad方法，需要手动代码控制；如果不需要，直接在初始化vcScroll时全部添加子控制器的View即可
        2，跨标签切换时，会看到中间标签对应的控制器。比如从1切换到4，会看到1->2->3->4对应VC的View
 */

#import <UIKit/UIKit.h>

@interface SSNewsScrollVC : UIViewController

@end
