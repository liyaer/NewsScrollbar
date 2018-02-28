//
//  ViewController.m
//  NewsScrollbar
//
//  Created by 杜文亮 on 2018/2/3.
//  Copyright © 2018年 杜文亮. All rights reserved.
//

#import "SPNewsScrollVC.h"
#import "MacroDefinition.h"


@interface SPNewsScrollVC ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>

//标签工具栏
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,assign) NSInteger lastSelectBtnTag;
//VC集合
@property (nonatomic,strong) UIPageViewController *pageVC;
@property (nonatomic,strong) NSMutableArray *VCs;
@property (nonatomic,assign) NSInteger index;

@end


@implementation SPNewsScrollVC
{
    ParameterMode *_mode;
}
#pragma mark - 懒加载

-(UIPageViewController *)pageVC
{
    if (!_pageVC)
    {
        _pageVC = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        _pageVC.view.frame = CGRectOffset(self.view.bounds, 0, _mode.item_height);
        _pageVC.delegate = self;
        _pageVC.dataSource = self;
        //为PVC初始化子VC
        [_pageVC setViewControllers:@[self.VCs.firstObject] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished)
         {
             NSLog(@"只打印一次！");
         }];
    }
    return _pageVC;
}

-(NSMutableArray *)VCs
{
    if (!_VCs)
    {
        _VCs = [NSMutableArray arrayWithCapacity:_mode.vc_names.count];
        for (int i = 0; i < _mode.vc_names.count; i++)
        {
            [_VCs addObject:[NSClassFromString(_mode.vc_names[i]) new]];
        }
    }
    return _VCs;
}

-(UIScrollView *)scrollView
{
    if (!_scrollView)
    {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, dScreenWidth, _mode.item_height)];
        _scrollView.contentSize = CGSizeMake(_mode.item_counts*_mode.item_width, 40);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
        //解决btn覆盖后的scrollView滑动不灵敏问题
        _scrollView.panGestureRecognizer.delaysTouchesBegan = YES;
        
        //添加子视图
        for (int i = 0; i < _mode.item_counts; i++)
        {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(i*_mode.item_width, 0, _mode.item_width, 40);
            btn.backgroundColor = _mode.item_bg_color;
            [btn setTitle:_mode.item_names[i] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
            [btn setTitleColor:_mode.item_unSel_color forState:UIControlStateNormal];
            [btn setTitleColor:_mode.item_sel_color forState:UIControlStateSelected];
            btn.tag = i+100;
            if (i == 0)
            {
                btn.selected = YES;
                btn.titleLabel.font = [UIFont systemFontOfSize:20];
//                btn.transform = CGAffineTransformMakeScale(1.3, 1.3);
                self.lastSelectBtnTag = btn.tag;
            }
            [btn addTarget:self action:@selector(changeVC:) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:btn];
        }
    }
    return _scrollView;
}

-(void)changeVC:(UIButton *)sender
{
    if (self.lastSelectBtnTag == sender.tag)
    {
        NSLog(@"do nothing");
    }
    else
    {
        //标签栏的设置
        UIButton *lastSelecteBtn = (UIButton *)[self.scrollView viewWithTag:self.lastSelectBtnTag];
        lastSelecteBtn.selected = NO;
        lastSelecteBtn.titleLabel.font = [UIFont systemFontOfSize:15];
//        lastSelecteBtn.transform = CGAffineTransformIdentity;
        sender.selected = YES;
        sender.titleLabel.font = [UIFont systemFontOfSize:20];
//        sender.transform = CGAffineTransformMakeScale(1.3, 1.3);
        [self scroTitleItemCenter:sender.tag];
        
        //VC的设置
        [self.pageVC setViewControllers:@[self.VCs[sender.tag -100]] direction:(self.lastSelectBtnTag > sender.tag ? UIPageViewControllerNavigationDirectionReverse : UIPageViewControllerNavigationDirectionForward) animated:YES completion:nil];
        
        //更新标识符
        self.lastSelectBtnTag = sender.tag;
    }
}

//标签跟随用户选择自动滚动（主要是针对多标签，只有中间部分的标签居中显示，两侧附近的标签在屏幕上都能看到，就不居中了，同时也为了不出现空余不美观）
-(void)scroTitleItemCenter:(NSInteger)tag
{
    UIButton *selectBtn = (UIButton *)[self.scrollView viewWithTag:tag];
    //计算当前选中标签到我们的目标点（此处我们想让标签在scroView的中心显示）的距离
    /*
        一般都是居中显示，不仅仅是因为美观。更是为了用户体验：
        1，如果选择居左、居右显示，势必会导致左侧（居左）、右侧（居右）还有标签未出现在屏幕上，用户无法点击，只能手动滑动
        2，为什么不能是scroView的1/3等等处显示呢？这个相比1是可以的，但是标签过大的话（注意，过大也不是任意大，我们只讨论有意义的情况，一般最大不会超过scroView的宽度），可能（注意是可能）会导致当前选中的标签显示不全，显示不美观。1/2处就不会产生此问题
     */
    CGFloat offset_x = selectBtn.center.x -self.scrollView.frame.size.width/2;
    //防止最左边滚动出现空余 到最左边就不在滚动
    offset_x = offset_x < 0 ? 0 : offset_x;
    //获取最大的滚动范围
    CGFloat maxOffsetX = self.scrollView.contentSize.width - self.scrollView.frame.size.width;
    //防止最右边出现空余  到最右边就不在滚动
    offset_x = offset_x > maxOffsetX ? maxOffsetX : offset_x;
    //触发滚动效果
    [self.scrollView setContentOffset:CGPointMake(offset_x, 0) animated:YES];
}




#pragma mark - viewDidLoad

-(instancetype)initWithParameter:(ParameterMode *)mode;
{
    if (self = [super init])
    {
        _mode = mode;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    // Do any additional setup after loading the view, typically from a nib.
    
    //添加标签集合
    [self.view addSubview:self.scrollView];
    
    //添加VC集合
    [self addChildViewController:self.pageVC];
    [self.view addSubview:self.pageVC.view];
    //KVO监听self.index
    [self addObserver:self forKeyPath:@"index" options:NSKeyValueObservingOptionNew context:nil];
}

//KVO监测值得变化(不用KVO也行，但是要分别在before和after方法中设置，KVO更方便一点)
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"index"])
    {
        //这两个值是一样的，用哪个都行
        NSLog(@"-------%@-----%ld",change[@"new"],self.index);

        //标签栏的设置
        UIButton *lastSelecteBtn = (UIButton *)[self.scrollView viewWithTag:self.lastSelectBtnTag];
        lastSelecteBtn.selected = NO;
        lastSelecteBtn.titleLabel.font = [UIFont systemFontOfSize:15];
//        lastSelecteBtn.transform = CGAffineTransformIdentity;
        UIButton *selectBtn = (UIButton *)[self.scrollView viewWithTag:self.index +100];
        selectBtn.selected = YES;
        selectBtn.titleLabel.font = [UIFont systemFontOfSize:20];
//        selectBtn.transform = CGAffineTransformMakeScale(1.3, 1.3);
        [self scroTitleItemCenter:self.index +100];
        
        //更新标识符
        self.lastSelectBtnTag = self.index +100;
    }
}




#pragma mark - UIPageViewController Delegate And DataSource

-(void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers
{
    //保证同时只能响应一个手势操作
    pageViewController.view.userInteractionEnabled = NO;
}

-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (finished)
    {
        pageViewController.view.userInteractionEnabled = YES;
    }
    
    if (!completed)
    {
        NSLog(@"fail!");
    }
    else
    {
        NSLog(@"sucess!");
    }
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSInteger index = [self.VCs indexOfObject:viewController];
    self.index = index;
//    NSLog(@"后后后后（翻页完成）后后后后:%ld",index);
    if (index == (self.VCs.count -1) || index == NSNotFound)
    {
        NSLog(@"-----------末尾");
        return nil;
    }
    index++;
    return self.VCs[index];
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSInteger index = [self.VCs indexOfObject:viewController];
    self.index = index;
//    NSLog(@"前前前前（翻页完成）前前前前:%ld",index);
    if (index == 0 || index == NSNotFound)
    {
        NSLog(@"-----------开头");
        return nil;
    }
    index--;
    return self.VCs[index];
}




#pragma mark - deallc

-(void)dealloc
{
    [self removeObserver:self forKeyPath:@"index"];
    NSLog(@"释放了：%@",[self class]);
}


@end
