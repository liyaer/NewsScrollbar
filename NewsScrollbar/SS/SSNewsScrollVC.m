//
//  SSNewsScrollVC.m
//  NewsScrollbar
//
//  Created by 杜文亮 on 2018/2/7.
//  Copyright © 2018年 杜文亮. All rights reserved.
//

#import "SSNewsScrollVC.h"
#import "MacroDefinition.h"
#import "UIColor+RGB.h"


@interface SSNewsScrollVC ()<UIScrollViewDelegate>
{
    //标题
    NSArray *_titles;//标题数组
    CGFloat _title_space;//间距
    UIFont  *_title_font;//字体
    UIColor *_title_bgColor;//背景色
    UIColor *_title_sel_color;//选中时字体颜色
    UIColor *_title_deSel_color;//未选中时字体颜色
    //开始颜色,取值范围0~1
    CGFloat startR, startG, startB;
    //完成颜色,取值范围0~1
    CGFloat endR, endG, endB;
    //完成 - 开始
    CGFloat r, g, b;
    //标题所在的scrollView
    CGFloat _title_scroll_h;//高
    UIColor *_title_scroll_bgColor;//背景颜色
    //内容控制器
    NSArray *_vcNames;
    //默认选中第几个标题、控制器
    NSInteger _selectIndex;

    //各种效果的参数设置
    CGFloat _scale;//放大效果的放大倍数
}
@property (nonatomic,strong) NSMutableArray *titleFrames;
@property (nonatomic,strong) UIScrollView *titleScroll;
@property (nonatomic,assign) NSInteger lastSelBtnTag;
@property (nonatomic,strong) UIScrollView *vcScroll;

@end


@implementation SSNewsScrollVC

#pragma mark - 懒加载

-(NSMutableArray *)titleFrames
{
    if (!_titleFrames)
    {
        _titleFrames = [NSMutableArray arrayWithCapacity:5];
        
        CGFloat x = 0.0;
        for (NSString *title in _titles)
        {
            CGRect title_rect = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_title_font} context:nil];
            CGRect title_rect_N = [(NSValue *)_titleFrames.lastObject CGRectValue];
            //x += title_rect_N.size.width + item_space;或者
            x = CGRectGetMaxX(title_rect_N) + _title_space;
            
            [_titleFrames addObject:[NSValue valueWithCGRect:CGRectMake(x, 0, title_rect.size.width+10, _title_scroll_h)]];
        }
    }
    return _titleFrames;
}

-(UIScrollView *)titleScroll
{
    if (!_titleScroll)
    {
        _titleScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, dScreenWidth, _title_scroll_h)];
        _titleScroll.backgroundColor = _title_scroll_bgColor;
        _titleScroll.bounces = NO;
        _titleScroll.showsHorizontalScrollIndicator = NO;
        //解决btn的点击事件和scrollView的滑动相互影响导致不灵敏问题
        _titleScroll.panGestureRecognizer.delaysTouchesBegan = YES;
        for (int i = 0; i < _titles.count; i++)
        {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = [(NSValue *)self.titleFrames[i] CGRectValue];
            btn.backgroundColor = _title_bgColor;
            [btn setTitle:_titles[i] forState:UIControlStateNormal];
            btn.titleLabel.font = _title_font;
            [btn setTitleColor:_title_deSel_color forState:UIControlStateNormal];
            btn.tag = i +100;
            if (i == _selectIndex)
            {
                [btn setTitleColor:_title_sel_color forState:UIControlStateNormal];
                btn.transform = CGAffineTransformMakeScale(_scale, _scale);
                self.lastSelBtnTag = btn.tag;
            }
            [btn addTarget:self action:@selector(changeVC:) forControlEvents:UIControlEventTouchUpInside];
            [_titleScroll addSubview:btn];
        }
        _titleScroll.contentSize = CGSizeMake(CGRectGetMaxX([(NSValue *)self.titleFrames.lastObject CGRectValue]) +_title_space, _title_scroll_h);
    }
    return _titleScroll;
}

-(void)changeVC:(UIButton *)btn
{
    //更新选中VC。YES：一直回调didscroll，NO：只回调一次
    [self.vcScroll setContentOffset:CGPointMake((btn.tag -100)*dScreenWidth, 0) animated:NO];
    
    //更新标识符
    self.lastSelBtnTag = btn.tag;
}

-(UIScrollView *)vcScroll
{
    if (!_vcScroll)
    {
        _vcScroll = [[UIScrollView alloc] initWithFrame:CGRectOffset(self.view.bounds, 0, _title_scroll_h)];
        _vcScroll.contentSize = CGSizeMake(dScreenWidth * _vcNames.count, _vcScroll.bounds.size.height);
        _vcScroll.showsHorizontalScrollIndicator = NO;
        _vcScroll.pagingEnabled = YES;
        _vcScroll.bounces = NO;
        _vcScroll.delegate = self;
        
        for (int i = 0; i < _vcNames.count; i++)
        {
            //注意：我们childVC模拟网络请求写在了viewDidLoad中，而不是初始化方法中。因此，虽然我们此处初始化了VC，但是由于未将VC添加至父试图，因此不会走VC中的viewDidLoad（viewDidLoad即将显示时调用）
            UIViewController *vc = [NSClassFromString(_vcNames[i]) new];
            [self addChildViewController:vc];
        }
        
        //加载默认子控制器
        UIViewController *vc = self.childViewControllers[_selectIndex];
        vc.view.frame = CGRectOffset(vc.view.bounds, _selectIndex * dScreenWidth, 0);
        [self.vcScroll addSubview:vc.view];
    }
    return _vcScroll;
}

#pragma mark -scrollView delegate

//滑动过程中一直调用 + 点击标签触发VC切换也会调用。交互动画效果在此完成！
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //手势滑动切换（点击切换不存在交互式动画，所以过滤掉）。手势拖拽时 || 手势离开后（开始减速），这两个过程加在一起构成了完整的滚动动画过程
    if (scrollView.dragging || scrollView.decelerating)
    {
        CGFloat offset_x = scrollView.contentOffset.x;
        
        NSInteger leftBtnTag = offset_x / CGRectGetWidth(scrollView.bounds);
        NSInteger rightBtnTag = leftBtnTag +1;
        UIButton *leftBtn = (UIButton *)[self.titleScroll viewWithTag:leftBtnTag +100];
        UIButton *rightBtn = (UIButton *)[self.titleScroll viewWithTag:rightBtnTag +100];
        
        CGFloat scale = offset_x /CGRectGetWidth(scrollView.bounds)  -leftBtnTag;
        CGFloat leftScale = 1 -scale;
        CGFloat rightScale = scale;
//        NSLog(@"---L: %ld-%.2f---R: %ld-%.2f",leftBtnTag,leftScale,rightBtnTag,rightScale);

        //缩放效果
        leftBtn.transform = CGAffineTransformMakeScale((_scale -1) *leftScale +1, (_scale -1) *leftScale +1);
        rightBtn.transform = CGAffineTransformMakeScale((_scale -1) *rightScale +1, (_scale -1) *rightScale +1);
        
        //字体颜色渐变效果
        [leftBtn setTitleColor:[UIColor colorWithRed:startR + r*leftScale green:startG + g*leftScale blue:startB + b*leftScale alpha:1.0] forState:UIControlStateNormal];
        [rightBtn setTitleColor:[UIColor colorWithRed:startR + r*rightScale green:startG + g*rightScale blue:startB + b*rightScale alpha:1.0] forState:UIControlStateNormal];
//        NSLog(@" %.2f---%.2f---%.2f \n %.2f---%.2f---%.2f",startR + r*leftScale,startG + g*leftScale,startB + b*leftScale,startR + r*rightScale,startG + g*rightScale,startB + b*rightScale);
    }
}

//滑动结束时会走这里（点击标签触发VC切换不走）
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    NSInteger currentPage = offset.x / dScreenWidth;
    
    //更新标识符。这里会存在切换成功和切换失败两种情况，无论那种情况都只需下面一句代码即可。切换成功触发KVO，切换失败不会触发，因为self.lastSelBtnTag前后值未变化
    self.lastSelBtnTag = currentPage +100;
}




#pragma mark - viewDidLoad

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

//NSArray ** 是 NSArray *__autoreleasing *的缩写
-(void)setScaleModeParameter:(void (^)(NSArray *__autoreleasing *, CGFloat *, UIFont *__autoreleasing *, UIColor *__autoreleasing *, UIColor *__autoreleasing *, UIColor *__autoreleasing *, CGFloat *, UIColor *__autoreleasing *, NSArray *__autoreleasing *, NSInteger *, CGFloat *))titlesBlock
{
    if (titlesBlock)
    {
        NSArray *titles;
        UIFont  *titleFont;
        UIColor *titleBgColor;
        UIColor *titleSelColor;
        UIColor *titleDeselColor;
        NSArray *vcNames;
        UIColor *titleScrollBgColor;
        
        /*
            总结发现：
                如果是OC对象类型的全局变量，需要传局部变量的引用代替（传全局变量会报错），调用完后将结果转接到全局变量；
                如果是简单数据类型的全局变量，直接传全局变量的引用即可
         */
        titlesBlock(&titles,&_title_space,&titleFont,&titleBgColor,&titleSelColor,&titleDeselColor,&_title_scroll_h,&titleScrollBgColor,&vcNames,&_selectIndex,&_scale);
        
        if (titles.count != 0  && vcNames.count != 0 && titles.count == vcNames.count)
        {
            _titles = titles;
            _vcNames = vcNames;
        }
        else
        {
            @throw [NSException exceptionWithName:@"DWL_Error" reason:@"1，标题名称和内容控制器名称为必传参数 2，二者数量上保持一致，并且数量不能为0" userInfo:nil];
        }
        _title_space = _title_space ? : 20;
        _title_font = titleFont ? : [UIFont systemFontOfSize:15.0];
        _title_bgColor = titleBgColor ? : [UIColor whiteColor];
        _title_sel_color = titleSelColor ? : [UIColor colorWithRed:1 green:0 blue:0 alpha:1.0];
        _title_deSel_color = titleDeselColor ? : [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0];
        [self setAnimationGradientColor];
        
        _title_scroll_h = _title_scroll_h ? : 40;
        _title_scroll_bgColor = titleScrollBgColor ? : [UIColor whiteColor];
        
        _selectIndex = _selectIndex ? : 0;
        
        _scale = _scale ? : 1.3;
    }
}

-(void)setAnimationGradientColor
{
    /*
        注意：滑动切换的目的是为了展示即将显示的标签、控制器，因此即将显示的标签是主体，在这一过程中，即将显示的标签从为选中态变为选中态。所以startRGB是_title_deSel_color，endRGB是_title_sel_color，千万别弄反了，这一点很重要！！！
     */
    NSArray *RGB = [UIColor getRGBFromColor1:_title_deSel_color];
    startR = [RGB[0] floatValue];
    startG = [RGB[1] floatValue];
    startB = [RGB[2] floatValue];
    RGB = [UIColor getRGBFromColor1:_title_sel_color];
    endR = [RGB[0] floatValue];
    endG = [RGB[1] floatValue];
    endB = [RGB[2] floatValue];
    r = endR - startR;
    g = endG - startG;
    b = endB - startB;
    NSLog(@"r:%.2f   g:%.2f   b:%.2f",r,g,b);
}

//错误的写法，无法达到效果，必须传地址（或者叫引用、reference）才行
//-(void)setScaleParameter:(void (^)(NSArray *))titlesBlock
//{
//    if (titlesBlock)
//    {
//        titlesBlock(_titles);
//    }
//}

-(void)viewWillAppear:(BOOL)animated
{
    [self.view addSubview:self.titleScroll];
    [self.view addSubview:self.vcScroll];
    //在懒加载完控件后，显示默认选中的标题和子控制器
    [self scroTitleItemCenter:_selectIndex +100];
    [self.vcScroll setContentOffset:CGPointMake(_selectIndex * dScreenWidth, 0) animated:NO];
    
    //KVO监听，简化代码
    [self addObserver:self forKeyPath:@"lastSelBtnTag" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    //self.lastSelBtnTag的最新值 = chang[@"new"];
    if ([keyPath isEqualToString:@"lastSelBtnTag"])
    {
        NSInteger newValue = [(NSNumber *)change[@"new"] integerValue];
        NSInteger oldValue = [(NSNumber *)change[@"old"] integerValue];
        
        //更新标签状态
        UIButton *lastSelBtn = (UIButton *)[self.titleScroll viewWithTag:oldValue];
        [lastSelBtn setTitleColor:_title_deSel_color forState:UIControlStateNormal];
        lastSelBtn.transform = CGAffineTransformIdentity;//点击切换需要（滑动切换动画最终值就是这里设置的值，所以滑动切换不会受影响）
        UIButton *selBtn = (UIButton *)[self.titleScroll viewWithTag:newValue];
        [selBtn setTitleColor:_title_sel_color forState:UIControlStateNormal];
        selBtn.transform = CGAffineTransformMakeScale(_scale, _scale);//点击切换需要（滑动切换动画最终值就是这里设置的值，所以滑动切换不会受影响）
        
        //居中显示当前选中的标签
        [self scroTitleItemCenter:self.lastSelBtnTag];
        
        //运行时才添加VC.view，并且保证只添加一次
        [self addChildVCView:self.lastSelBtnTag -100];
    }
}

//选中的标签居中显示（两侧边界标签除外）
-(void)scroTitleItemCenter:(NSInteger)tag
{
    UIButton *btn = (UIButton *)[self.titleScroll viewWithTag:tag];
    CGFloat offset_x = btn.center.x - dScreenWidth/2;
    offset_x = offset_x > 0 ? offset_x : 0;
    CGFloat offset_x_max = self.titleScroll.contentSize.width - self.titleScroll.frame.size.width;
    offset_x = offset_x > offset_x_max ? offset_x_max : offset_x;
    [self.titleScroll setContentOffset:CGPointMake(offset_x, 0) animated:YES];
}

//未添加过子控制器的View，就添加；添加过，什么也不做
-(void)addChildVCView:(NSInteger)currentPage
{
    //获取对应的子控制器
    UIViewController *vc = self.childViewControllers[currentPage];
    //添加子控制器View(保证只添加一次)
    if(vc.isViewLoaded)return;
    vc.view.frame = CGRectOffset(vc.view.bounds, dScreenWidth * currentPage, 0);
    [self.vcScroll addSubview:vc.view];
}




#pragma mark - dealloc

-(void)dealloc
{
    [self removeObserver:self forKeyPath:@"lastSelBtnTag"];
    NSLog(@"释放了：%@",[self class]);
}


@end
