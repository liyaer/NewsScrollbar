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
typedef enum : NSUInteger
{
    titleColorSlideGradientMode,//0，标题颜色滑动渐变
    titleColorGradientMode,//1，标题颜色渐变
    scaleMode,//2，缩放效果
    underLineMode,//3，下标选中效果
    coverMode,//4，滑块选中效果
}
effectMode;


@interface SSNewsScrollVC : UIViewController

/*
    两种使用方法：
        1，直接实例化本类，调用初始化方法
        2，实例化继承自该类的子类，调用初始化方法（推荐，因为初始化参数太多，建议在子类的viewDidLoad中调初始化方法）
 
    注意：
        1，没有将初始化参数直接封装到自定义初始化方法中（这种写法经常写，这次换个不一样的），而是额外封装了以下方法。
            如果采用用法1，需要在实例化后，push或者present前调用下面的几个初始化方法中的一种（因为push、present后会执行该类的viewDidLoad方法）
            如果采用用法二，需要在子类实例化后或者子类的ViewDidLoad中调用下面的几个初始化方法中的一种
        2，标题名称和控制器名称是必传字段，其他可以选传
 */

//通用参数的设置，包含默认效果的设置，从1，0中任选一种，必须调用！
-(void)setBasicsParameter:(void(^)(CGRect *frame,NSArray **titles, CGFloat *title_space, UIFont **title_font, UIColor **title_bgColor, UIColor **title_sel_color, UIColor **title_deSel_color, CGFloat *title_scroll_h, UIColor **title_scroll_bgColor, NSArray **vcNames, NSInteger *selectIndex, effectMode *mode)) titlesBlock;

//错误的写法，无法达到效果，必须传地址（或者叫引用、reference）才行
//-(void)setScaleParameter:(void(^)(NSArray *titles)) titlesBlock;

//可选效果的设置，选择性调用，但是只能从2，3，4中选一种调用！
-(void)setOtherMode:(effectMode)mode parameter:(id)parameter;


@end
