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
        2，跨标签切换时，会看到中间标签对应的控制器。比如从1切换到4，会看到1->2->3->4对应VC的View。（当然了，只有[self.vcScroll setContentOffset:CGPointMake((btn.tag -100)*dScreenWidth, 0) animated:YES]参数设置为YES会这样，NO的话无动画效果肯定看不到）
 */

#import <UIKit/UIKit.h>

/*
    说明：
        0，1是必选效果设置项，内置的两种默认效果，无需额外提供参数（是根据用户指定的选中、未选中颜色决定的）。
        2，3，4是可选效果设置项，可以任选一种并且只能一种和上面1或2进行效果的叠加；如果设置了多项，那么只会展示默认的效果1或0。
    注意：
        如果标题长度差别较大，不建议使用缩放效果，会造成间距不等的效果；如果标题长度一样或者差别不大，可以使用这种效果
 */
typedef NS_ENUM(NSInteger, effectMode)
{
    titleColorSlideGradientMode,//0，标题颜色滑动渐变
    titleColorGradientMode,//1，标题颜色渐变
    scaleMode,//2，缩放效果
    underLineMode,//3，下标选中效果
    coverMode,//4，滑块选中效果
};


@interface SSNewsScrollVC : UIViewController

/*
    三种使用方法：
        1，直接实例化本类 --> 调用setBasicsParameter（必须）setOtherMode（可选）--> push / present
        2，实例化继承自该类的子类 --> 子类调用setBasicsParameter（必须）setOtherMode（可选）--> push / present
        3，实例化继承自该类的子类 --> push / present --> 在子类的viewDidLoad中，【super viewDidLoad】之前，调用setBasicsParameter（必须）setOtherMode（可选）-------------推荐这种方式
 
    注意：
        1，没有将初始化参数直接封装到自定义初始化方法中（这种写法经常写，会导致指定初始化方法太长，这次换个不一样的），而是额外封装了以下方法。
        2，标题名称和控制器名称是必传字段，其他可以选传
 
    使用场景：（不同场景下，vcNames参数传的内容可能不同，有时是VC对象，有时是VC名字）
        1，子VC数量确定：
            1.1，若子VC布局不同，需要创建不同的子VC，然后传VC名字（这样每个子VC内部布局自己的样式）
            1.2，若子VC布局相同，可以使用同一个VC，然后传VC对象，此时VC内部需要一个classId来帮助我们区分是哪个子VC（当然也可以创建多个不同名字的子VC，但是每个子VC内部代码几乎完全一致，肯定是冗余了）
        2，子VC数量不确定，需要从后台获取：
            2.1，子VC布局不同，目前无法实现，不知道如何动态创建VC并且完成布局
            2.2，子VC布局相同，和1.2一致（但是1.2括号中所述在此不适用，原因和2.1一致）
 */

//通用参数的设置，包含默认效果的设置，从1，0中任选一种，必须调用！
-(void)setBasicsParameter:(void(^)(CGRect *frame,NSArray **titles, CGFloat *title_space, UIFont **title_font, UIColor **title_bgColor, UIColor **title_sel_color, UIColor **title_deSel_color, CGFloat *title_scroll_h, UIColor **title_scroll_bgColor, NSArray **vcNames, NSInteger *selectIndex, effectMode *mode)) titlesBlock;

#warning 错误的写法，无法达到效果，必须传地址（或者叫引用、reference）才行。
//-(void)setScaleParameter:(void(^)(NSArray *titles)) titlesBlock;

//可选效果的设置，选择性调用，但是只能从2，3，4中选一种调用！
-(void)setOtherMode:(effectMode)mode parameter:(id)parameter;


@end
