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
        1,主要是针对首次显示加载子控制器的View时
            点击标签：点击时才走子VC的viewDidLoad方法（完全得益于PVC的功劳，不需要我们手动写代码控制）
            滑动切换：PVC机制的问题（PVC中会加载当前显示VC、当前显示VC的前一个VC，当前显示VC的后一个VC，便于切换动画）导致会提前加载下一个VC（提前走下一个VC的viewDidLoad方法）。
        对比scroll + scroll方式（手动实现点击时、滑动切换完成才加载VC的View），点击切换时二者效果一致，滑动切换效果差异很明显。滑动切换过程中由于VC的View未加载，所以看到的是Scroll的底板颜色，为了美观，需要手动加一层loading图，滑动完成才会走VC的ViewDidLoad方法
 
        2,跨标签点击时，下面VC切换不显示中间VC，看起来就像两个紧挨着的VC的切换一样。比如从1切换到4，界面看起来就像1和4的VC紧挨着一样，切换时看不到2，3对应的VC的View
    缺点：
        1，交互动画这一块目前无法实现
        2，滑动切换，首页、末页还可以进行首页上翻、末页下翻的操作(意思就是有弹簧效果)
 */

#import <UIKit/UIKit.h>
#import "ParameterMode.h"


@interface SPNewsScrollVC : UIViewController

-(instancetype)initWithParameter:(ParameterMode *)mode;

@end

