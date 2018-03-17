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
#import "TitleLab.h"
#import "LoadingView.h"


//cover效果时扩宽尺寸需要
#define inset_t 5
#define inset_l 10


@interface SSNewsScrollVC ()<UIScrollViewDelegate>
{
    //---------------------通用设置-----------------------
    //标题
    NSArray *_titles;//标题数组
    CGFloat _title_space;//间距
    UIFont  *_title_font;//字体
    UIColor *_title_bgColor;//背景色
    UIColor *_title_sel_color;//选中时字体颜色
    UIColor *_title_deSel_color;//未选中时字体颜色
    //标题字体颜色渐变
    CGFloat startR, startG, startB;//开始颜色,取值范围0~1
    CGFloat endR, endG, endB;//完成颜色,取值范围0~1
    CGFloat r, g, b;//完成 - 开始
    //标题所在的scrollView
    CGFloat _title_scroll_h;//高
    UIColor *_title_scroll_bgColor;//背景颜色
    //内容控制器
    NSArray *_vcNames;
    //默认选中第几个标题、控制器
    NSInteger _selectIndex;
    //默认的颜色渐变效果
    effectMode _mode;

    //--------------------各种效果的参数设置----------------
    //缩放效果
    BOOL _isScale;
    CGFloat _scale;//放大效果的放大倍数
    //下标选中效果
    BOOL _isUnderLine;
    CGFloat _underLine_h;//下划线高度
    //滑块选中效果
    BOOL _isCover;
    UIColor *_cover_bgColor;//滑块的颜色
    CGFloat _title_h;//字体的高度
}
@property (nonatomic,strong) NSMutableArray *titleFrames;
@property (nonatomic,strong) UIScrollView *titleScroll;
@property (nonatomic,assign) NSInteger lastSelBtnTag;
@property (nonatomic,strong) UIView *underLine;
@property (nonatomic,strong) UIView *coverView;
@property (nonatomic,strong) UIScrollView *vcScroll;

@end


@implementation SSNewsScrollVC

#pragma mark - 懒加载

-(NSMutableArray *)titleFrames
{
    if (!_titleFrames)
    {
        _titleFrames = [NSMutableArray arrayWithCapacity:5];
        
        //向self.titleFrames中填充数据
        [self fillTitleFrames];
        //检查总长度是否小于屏幕宽度，小于的话重设title的frame，更新self.titleFrames
        [self inspectTotalWidth];
    }
    return _titleFrames;
}

-(UIView *)underLine
{
    if (!_underLine)
    {
        CGRect labFrame = [(NSNumber *)self.titleFrames[_selectIndex] CGRectValue];
        _underLine = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(labFrame), CGRectGetMaxY(labFrame) -_underLine_h, CGRectGetWidth(labFrame), _underLine_h)];
        _underLine.backgroundColor = _title_sel_color;
    }
    return _underLine;
}

-(UIView *)coverView
{
    if (!_coverView)
    {
        //根据btnFrame计算出文字的frame
        CGRect labFrame = [(NSNumber *)self.titleFrames[_selectIndex] CGRectValue];
        CGRect frame = labFrame;
        frame.size.height = _title_h;
        frame.origin.y = (labFrame.size.height - _title_h)/2;
        labFrame = frame;
        
        _coverView = [[UIView alloc] initWithFrame:CGRectInset(labFrame, -inset_l, -inset_t)];
        _coverView.layer.cornerRadius = _coverView.bounds.size.height/2;
        _coverView.backgroundColor = _cover_bgColor;
    }
    return _coverView;
}

-(UIScrollView *)titleScroll
{
    if (!_titleScroll)
    {
        _titleScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, dScreenWidth, _title_scroll_h)];
        _titleScroll.backgroundColor = _title_scroll_bgColor;
        _titleScroll.bounces = NO;
        _titleScroll.showsHorizontalScrollIndicator = NO;
        //添加子视图
        [self addTitleLabs];
        //一定写在子视图添加完成后，因为此时才能确定contentSize
        _titleScroll.contentSize = CGSizeMake(CGRectGetMaxX([(NSValue *)self.titleFrames.lastObject CGRectValue]) +_title_space, _title_scroll_h);
    }
    return _titleScroll;
}

-(UIScrollView *)vcScroll
{
    if (!_vcScroll)
    {
        _vcScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleScroll.frame), CGRectGetWidth(_titleScroll.frame), dScreenHeight -_title_scroll_h -(self.navigationController ? 64 : 0))];
        _vcScroll.contentSize = CGSizeMake(CGRectGetWidth(_vcScroll.frame) * _vcNames.count, _vcScroll.bounds.size.height);
        _vcScroll.showsHorizontalScrollIndicator = NO;
        _vcScroll.pagingEnabled = YES;
        _vcScroll.bounces = NO;
        _vcScroll.delegate = self;
        [self addChildVCs];
    }
    return _vcScroll;
}




#pragma mark - viewDidLoad

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //取消导航控制器默认的滑动返回（正常返回的话没问题，若中途取消返回会crash，所以禁用）
    if (self.navigationController)
    {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
}

-(void)setAnimationGradientColor
{
    if (_mode == titleColorGradientMode)
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
        //    NSLog(@"r:%.2f   g:%.2f   b:%.2f",r,g,b);
    }
}

//NSArray ** 是 NSArray *__autoreleasing *的缩写
-(void)setBasicsParameter:(void (^)(NSArray *__autoreleasing *, CGFloat *, UIFont *__autoreleasing *, UIColor *__autoreleasing *, UIColor *__autoreleasing *, UIColor *__autoreleasing *, CGFloat *, UIColor *__autoreleasing *, NSArray *__autoreleasing *, NSInteger *, effectMode *))titlesBlock
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
        titlesBlock(&titles,&_title_space,&titleFont,&titleBgColor,&titleSelColor,&titleDeselColor,&_title_scroll_h,&titleScrollBgColor,&vcNames,&_selectIndex,&_mode);
        
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
        _title_bgColor = titleBgColor ? : [UIColor clearColor];
        _title_sel_color = titleSelColor ? : [UIColor colorWithRed:1 green:0 blue:0 alpha:1.0];
        _title_deSel_color = titleDeselColor ? : [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0];
        
        _title_scroll_h = _title_scroll_h ? : 40;
        _title_scroll_bgColor = titleScrollBgColor ? : [UIColor whiteColor];
        
        _selectIndex = _selectIndex ? : 0;
        
        _mode = _mode ? : titleColorSlideGradientMode;
        [self setAnimationGradientColor];
    }
}

//错误的写法，无法达到效果，必须传地址（或者叫引用、reference）才行
//-(void)setScaleParameter:(void (^)(NSArray *))titlesBlock
//{
//    if (titlesBlock)
//    {
//        titlesBlock(_titles);
//    }
//}

-(void)setOtherMode:(effectMode)mode parameter:(id)parameter
{
    switch (mode)
    {
        case scaleMode:
        {
            _isScale = YES;
            _scale = [(NSNumber *)parameter floatValue] ? : 1.3;
        }
            break;
        case underLineMode:
        {
            _isUnderLine = YES;
            _underLine_h = [(NSNumber *)parameter floatValue] ? : 1.0;
        }
            break;
        default:
        {
            _isCover = YES;
            _cover_bgColor = (UIColor *)parameter ? : [UIColor grayColor];
        }
            break;
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.view addSubview:self.titleScroll];
    [self.view addSubview:self.vcScroll];
    //在懒加载完控件后，显示默认选中的标题和子控制器
    [self scroTitleItemCenter:_selectIndex +100];
    [self.vcScroll setContentOffset:CGPointMake(_selectIndex * CGRectGetWidth(_vcScroll.frame), 0) animated:NO];
    
    //KVO监听，简化代码
    [self addObserver:self forKeyPath:@"lastSelBtnTag" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}




#pragma mark - scrollView delegate

//叠加效果的设置-----动画过程中
-(void)setAnimation:(TitleLab *)leftLab rightLab:(TitleLab *)rightLab leftScale:(CGFloat)leftScale rightScale:(CGFloat)rightScale
{
    //缩放效果
    if (_isScale && !_isUnderLine && !_isCover)
    {
        leftLab.transform = CGAffineTransformMakeScale((_scale -1) *leftScale +1, (_scale -1) *leftScale +1);
        rightLab.transform = CGAffineTransformMakeScale((_scale -1) *rightScale +1, (_scale -1) *rightScale +1);
    }
    
    //下划线选中效果
    if (_isUnderLine && !_isScale && !_isCover)
    {
        CGFloat x = CGRectGetMinX(leftLab.frame)+((CGRectGetMinX(rightLab.frame)-CGRectGetMinX(leftLab.frame))*rightScale);
        CGFloat w = CGRectGetWidth(leftLab.frame) +((CGRectGetWidth(rightLab.frame)-CGRectGetWidth(leftLab.frame))*rightScale);
        self.underLine.frame = CGRectMake(x, CGRectGetMaxY(leftLab.frame)-_underLine_h, w, _underLine_h);
    }
    
    //滑块选中效果
    if (_isCover && !_isUnderLine && !_isScale)
    {
        CGRect frame = self.coverView.frame;
        frame.origin.x = (CGRectGetMinX(leftLab.frame) -inset_l)+((CGRectGetMinX(rightLab.frame)-CGRectGetMinX(leftLab.frame))*rightScale);
        frame.size.width = (CGRectGetWidth(leftLab.frame) +inset_l*2)+((CGRectGetWidth(rightLab.frame)-CGRectGetWidth(leftLab.frame))*rightScale);
        self.coverView.frame = frame;
    }
}

//滑动过程中一直调用 + 点击标签触发VC切换也会调用。交互动画效果在此完成！
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //手势滑动切换（点击切换不存在交互式动画，所以过滤掉）。手势拖拽时 || 手势离开后（开始减速），这两个过程加在一起构成了完整的滚动动画过程
    if (scrollView.dragging || scrollView.decelerating)
    {
        CGFloat offset_x = scrollView.contentOffset.x;
        
        //这里我们不区分方向（向左还是向右滑动），用相对方位左和右来进行操作
        NSInteger leftLabTag = offset_x / CGRectGetWidth(scrollView.bounds);
        NSInteger rightLabTag = leftLabTag +1;
        TitleLab *leftLab = (TitleLab *)[self.titleScroll viewWithTag:leftLabTag +100];
        TitleLab *rightLab = (TitleLab *)[self.titleScroll viewWithTag:rightLabTag +100];
        
        //向左滑动：scale逐渐变小 ；向右滑动：scale逐渐变大。这一点可以保证我们下面的操作就算不区分方向也可以完成想要的效果
        CGFloat scale = offset_x /CGRectGetWidth(scrollView.bounds)  -leftLabTag;
        CGFloat leftScale = 1 -scale;
        CGFloat rightScale = scale;
        //        NSLog(@"---L: %ld-%.2f---R: %ld-%.2f",leftBtnTag,leftScale,rightBtnTag,rightScale);
        
        //默认效果的设置
        if (_mode == titleColorGradientMode)//字体颜色渐变
        {
            leftLab.textColor = [UIColor colorWithRed:startR + r*leftScale green:startG + g*leftScale blue:startB + b*leftScale alpha:1.0];
            rightLab.textColor = [UIColor colorWithRed:startR + r*rightScale green:startG + g*rightScale blue:startB + b*rightScale alpha:1.0];
            //        NSLog(@" %.2f---%.2f---%.2f \n %.2f---%.2f---%.2f",startR + r*leftScale,startG + g*leftScale,startB + b*leftScale,startR + r*rightScale,startG + g*rightScale,startB + b*rightScale);
        }
        else//字体颜色滑动渐变
        {
            rightLab.textColor = _title_deSel_color;
            rightLab.fillColor = _title_sel_color;
            rightLab.progress = rightScale;
            
            leftLab.textColor = _title_sel_color;
            leftLab.fillColor = _title_deSel_color;
            leftLab.progress = rightScale;
        }
        
        //叠加效果的设置-----动画过程中
        [self setAnimation:leftLab rightLab:rightLab leftScale:leftScale rightScale:rightScale];
    }
}

//滑动结束时会走这里（点击标签触发VC切换不走）
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger currentPage = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
    
    //更新标识符。这里会存在切换成功和切换失败两种情况，无论那种情况都只需下面一句代码即可。切换成功触发KVO，切换失败不会触发，因为self.lastSelBtnTag前后值未变化
    self.lastSelBtnTag = currentPage +100;
}




#pragma mark - title的点击事件

-(void)titleClicked:(NSInteger)tag
{
    //默认效果的设置-----动画结束时
    TitleLab *lastSelLab = (TitleLab *)[self.titleScroll viewWithTag:self.lastSelBtnTag];
    lastSelLab.textColor = _title_deSel_color;
    TitleLab *selLab = (TitleLab *)[self.titleScroll viewWithTag:tag];
    selLab.textColor = _title_sel_color;
    //在titleColorSlideGradientMode模式下，如果之前进行过滑动切换，消除动画带来的影响
    if (_mode == titleColorSlideGradientMode)
    {
        lastSelLab.fillColor = nil;
        lastSelLab.progress = 0.0;
        selLab.fillColor = nil;
        selLab.progress = 0.0;
    }
    
    //叠加效果的设置-----动画结束时
    [self setModesEndValue:lastSelLab selBtn:selLab];
    
    //更新选中VC。YES：一直回调didscroll，NO：只回调一次
    [self.vcScroll setContentOffset:CGPointMake((tag -100)*CGRectGetWidth(_vcScroll.frame), 0) animated:NO];
    
    //更新标识符
    self.lastSelBtnTag = tag;
}

//叠加效果的设置-----动画结束时
-(void)setModesEndValue:(TitleLab *)lastSelLab selBtn:(TitleLab *)selLab
{
    //缩放
    if (_isScale && !_isUnderLine && !_isCover)
    {
        [UIView animateWithDuration:0.25 animations:^
        {
            lastSelLab.transform = CGAffineTransformIdentity;
            selLab.transform = CGAffineTransformMakeScale(_scale, _scale);
        }];
    }
    //下划线
    if (_isUnderLine && !_isScale && !_isCover)
    {
        [UIView animateWithDuration:0.25 animations:^
        {
            self.underLine.frame = CGRectMake(CGRectGetMinX(selLab.frame), CGRectGetMaxY(selLab.frame) -_underLine_h, CGRectGetWidth(selLab.frame), _underLine_h);
        }];
    }
    //滑块
    if (_isCover && !_isUnderLine && !_isScale)
    {
        //根据btnFrame计算出文字的frame
        CGRect labFrame = selLab.frame;
        CGRect frame = labFrame;
        frame.size.height = _title_h;
        frame.origin.y = (labFrame.size.height - _title_h)/2;
        labFrame = frame;
        [UIView animateWithDuration:0.25 animations:^
        {
            self.coverView.frame = CGRectInset(labFrame, -inset_l, -inset_t);
        }];
    }
}




#pragma mark - KVO监听

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    //self.lastSelBtnTag的最新值 = chang[@"new"]
    if ([keyPath isEqualToString:@"lastSelBtnTag"])
    {
        //居中显示当前选中的标签
        [self scroTitleItemCenter:self.lastSelBtnTag];
        
        //运行时才添加VC.view，并且保证只添加一次
        [self addChildVCView:self.lastSelBtnTag -100];
    }
}

//选中的标签居中显示（两侧边界标签除外）
-(void)scroTitleItemCenter:(NSInteger)tag
{
    TitleLab *lab = (TitleLab *)[self.titleScroll viewWithTag:tag];
    CGFloat offset_x = lab.center.x - CGRectGetWidth(_titleScroll.frame)/2;
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
    vc.view.frame = CGRectMake(CGRectGetWidth(_vcScroll.frame) * currentPage, 0, CGRectGetWidth(_vcScroll.frame), CGRectGetHeight(_vcScroll.frame));
    [self.vcScroll addSubview:vc.view];
}




#pragma mark - 封装调用集合

-(void)addTitleLabs
{
    __weak typeof(self) weakSelf = self;

    for (int i = 0; i < _titles.count; i++)
    {
        TitleLab *lab = [[TitleLab alloc] initWithFrame:[(NSValue *)self.titleFrames[i] CGRectValue]];
        lab.backgroundColor = _title_bgColor;
        lab.text = _titles[i];
        lab.font = _title_font;
        lab.textColor = _title_deSel_color;
        lab.tag = i +100;
        if (i == _selectIndex)
        {
            lab.textColor = _title_sel_color;
            self.lastSelBtnTag = lab.tag;
        }
        lab.titleClick = ^(NSInteger tag)
        {
            [weakSelf titleClicked:tag];
        };
        [_titleScroll addSubview:lab];
    }
    //叠加效果的设置-----初始化
    [self setModesStartValue];
}

//向self.titleFrames中填充数据
-(void)fillTitleFrames
{
    //计算标题的长度，并设置titleLab的frame
    CGFloat x = 0.0;
    for (NSString *title in _titles)
    {
        CGRect title_rect = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:_title_font} context:nil];
        CGRect title_rect_N = [(NSValue *)_titleFrames.lastObject CGRectValue];
        //x += title_rect_N.size.width + item_space;或者
        x = CGRectGetMaxX(title_rect_N) + _title_space;
        
        [_titleFrames addObject:[NSValue valueWithCGRect:CGRectMake(x, 0, title_rect.size.width, _title_scroll_h)]];
        
        //记录字体的高度，cover方式需要此参数
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^
          {
              _title_h = title_rect.size.height;
              NSLog(@"字体大小一致，高度只需设置一次即可！");
          });
    }
}

//检查总长度是否小于屏幕宽度，小于的话重设title的frame
-(void)inspectTotalWidth
{
    CGFloat totalWidth = CGRectGetMaxX([(NSValue *)_titleFrames.lastObject CGRectValue]) +_title_space;
    if (totalWidth < CGRectGetWidth(_titleScroll.frame))
    {
        CGFloat addSpace = (CGRectGetWidth(_titleScroll.frame) -totalWidth)/(_titles.count +1);
        _title_space += addSpace;
        for (int i = 0; i < _titleFrames.count; i++)
        {
            CGRect newFrame = [(NSValue *)_titleFrames[i] CGRectValue];
            newFrame.origin.x += addSpace * (i + 1);
            [_titleFrames replaceObjectAtIndex:i withObject:[NSValue valueWithCGRect:newFrame]];
        }
    }
}

//叠加效果的设置-----初始化
-(void)setModesStartValue
{
    //缩放
    if (_isScale && !_isUnderLine && !_isCover)
    {
        TitleLab *lab = (TitleLab *)[_titleScroll viewWithTag:_selectIndex +100];
        lab.transform = CGAffineTransformMakeScale(_scale, _scale);
    }
    
    //下划线
    if (_isUnderLine && !_isScale && !_isCover)
    {
        [_titleScroll addSubview:self.underLine];
    }
    
    //滑块
    if (_isCover && !_isScale && !_isUnderLine)
    {
        [_titleScroll insertSubview:self.coverView atIndex:0];
    }
}

-(void)addChildVCs
{
    //添加背景视图
    LoadingView *loading = [[LoadingView alloc] initWithFrame:CGRectMake(0, 0, _vcScroll.contentSize.width, _vcScroll.contentSize.height) count:_vcNames.count];
    [_vcScroll addSubview:loading];
    
    //添加内容控制器
    for (int i = 0; i < _vcNames.count; i++)
    {
        //注意：我们childVC模拟网络请求写在了viewDidLoad中，而不是初始化方法中。因此，虽然我们此处初始化了VC，但是由于未将VC添加至父试图，因此不会走VC中的viewDidLoad（viewDidLoad即将显示时调用）
        UIViewController *vc = [NSClassFromString(_vcNames[i]) new];
        [self addChildViewController:vc];
    }
    
    //加载默认子控制器
    UIViewController *vc = self.childViewControllers[_selectIndex];
    vc.view.frame = CGRectMake(_selectIndex * CGRectGetWidth(_vcScroll.frame), 0, CGRectGetWidth(_vcScroll.frame), CGRectGetHeight(_vcScroll.frame));
    [_vcScroll addSubview:vc.view];
}




#pragma mark - dealloc

-(void)dealloc
{
    [self removeObserver:self forKeyPath:@"lastSelBtnTag"];
    NSLog(@"释放了：%@",[self class]);
}


@end
