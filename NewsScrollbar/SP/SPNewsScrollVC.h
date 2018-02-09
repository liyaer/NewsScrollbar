//
//  ViewController.h
//  NewsScrollbar
//
//  Created by 杜文亮 on 2018/2/3.
//  Copyright © 2018年 杜文亮. All rights reserved.
//


/*
    Scroll + PVC
    优点：
        1,可以做到子控制器显示时才初始化，主要是针对首次显示加载子控制器时。（完全得益于PVC的功劳，不需要我们手动写代码控制）达到的界面效果就是，滑动切换过程中会显示下个VC的页面，但是不会走下个VC的viewDidLoad方法，当切换完毕才走viewDidLoad
        2,跨标签点击时，下面VC切换不显示中间VC，看起来就像两个紧挨着的VC的切换一样。比如从1切换到4，界面看起来就像1和4的VC紧挨着一样，切换时看不到2，3对应的VC的View
    缺点：
        1，交互动画这一块目前无法实现
 */

#import <UIKit/UIKit.h>
#import "ParameterMode.h"


@interface SPNewsScrollVC : UIViewController

-(instancetype)initWithParameter:(ParameterMode *)mode;

@end

