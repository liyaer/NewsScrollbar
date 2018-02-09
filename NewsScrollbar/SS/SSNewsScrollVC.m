//
//  SSNewsScrollVC.m
//  NewsScrollbar
//
//  Created by 杜文亮 on 2018/2/7.
//  Copyright © 2018年 杜文亮. All rights reserved.
//

#import "SSNewsScrollVC.h"
#import "MacroDefinition.h"
#import "TabVC1.h"
#import "TabVC2.h"
#import "SameVC.h"


#define item_w 100
#define item_scroll_h 40


@interface SSNewsScrollVC ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *itemScroll;
@property (nonatomic,assign) NSInteger lastSelBtnTag;
@property (nonatomic,strong) UIScrollView *vcScroll;
@property (nonatomic,strong) NSArray *vcNames;

@end


@implementation SSNewsScrollVC

#pragma mark - 懒加载

-(UIScrollView *)itemScroll
{
    if (!_itemScroll)
    {
        _itemScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, dScreenWidth, item_scroll_h)];
        _itemScroll.contentSize = CGSizeMake(item_w * self.vcNames.count, item_scroll_h);
        _itemScroll.bounces = NO;
        _itemScroll.showsHorizontalScrollIndicator = NO;
        _itemScroll.panGestureRecognizer.delaysTouchesBegan = YES;
        for (int i = 0; i < self.vcNames.count; i++)
        {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(i * item_w, 0, item_w, item_scroll_h);
            btn.backgroundColor = DRandomColor;
            [btn setTitle:[NSString stringWithFormat:@"item - %d",i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
            btn.tag = i +100;
            if (!i)
            {
                btn.selected = YES;
                self.lastSelBtnTag = btn.tag;
            }
            [btn addTarget:self action:@selector(changeVC:) forControlEvents:UIControlEventTouchUpInside];
            [_itemScroll addSubview:btn];
        }
    }
    return _itemScroll;
}

-(void)changeVC:(UIButton *)btn
{
    //更新标签状态
    UIButton *lastSelBtn = (UIButton *)[self.itemScroll viewWithTag:self.lastSelBtnTag];
    lastSelBtn.selected = NO;
    btn.selected = YES;
    
    //更新选中VC
    [self.vcScroll setContentOffset:CGPointMake((btn.tag -100)*dScreenWidth, 0) animated:YES];
    
    //更新标识符
    self.lastSelBtnTag = btn.tag;
}

-(UIScrollView *)vcScroll
{
    if (!_vcScroll)
    {
        _vcScroll = [[UIScrollView alloc] initWithFrame:CGRectOffset(self.view.bounds, 0, item_scroll_h)];
        _vcScroll.contentSize = CGSizeMake(dScreenWidth *self.vcNames.count, _vcScroll.bounds.size.height);
        _vcScroll.showsHorizontalScrollIndicator = NO;
        _vcScroll.pagingEnabled = YES;
        _vcScroll.bounces = NO;
        _vcScroll.delegate = self;
        
        //默认加载第一个子控制器
        UIViewController *vc = self.childViewControllers[0];
        vc.view.frame = vc.view.bounds;
        [self.vcScroll addSubview:vc.view];
    }
    return _vcScroll;
}

-(NSArray *)vcNames
{
    if (!_vcNames)
    {
        _vcNames = @[@"TabVC1",@"TabVC2",@"SameVC",@"SameVC",@"SameVC",@"SameVC"];
        for (int i = 0; i < _vcNames.count; i++)
        {
            //注意：我们childVC模拟网络请求写在了viewDidLoad中，而不是初始化方法中。因此，虽然我们此处初始化了VC，但是由于未将VC添加至父试图，因此不会走VC中的viewDidLoad（viewDidLoad即将显示时调用）
            UIViewController *vc = [NSClassFromString(_vcNames[i]) new];
            [self addChildViewController:vc];
        }
    }
    return _vcNames;
}

#pragma mark -scrollView delegate

//滑动过程中一直调用 + 点击标签触发VC切换也会一直调用
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{

}

//滑动结束时会走这里（点击标签触发VC切换不走）
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    NSInteger currentPage = offset.x / dScreenWidth;
    
    //更新标签状态
    UIButton *lastSelBtn = (UIButton *)[self.itemScroll viewWithTag:self.lastSelBtnTag];
    lastSelBtn.selected = NO;
    UIButton *selBtn = (UIButton *)[self.itemScroll viewWithTag:currentPage +100];
    selBtn.selected = YES;
    
    //更新标识符
    self.lastSelBtnTag = currentPage +100;
}




#pragma mark - viewDidLoad

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    
    [self.view addSubview:self.itemScroll];
    [self.view addSubview:self.vcScroll];
    
    //KVO监听，简化代码
    [self addObserver:self forKeyPath:@"lastSelBtnTag" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"lastSelBtnTag"])
    {
        [self scroTitleItemCenter:self.lastSelBtnTag];
        [self addChildVCView:self.lastSelBtnTag -100];
    }
}

//选中的标签居中显示（两侧边界标签除外）
-(void)scroTitleItemCenter:(NSInteger)tag
{
    UIButton *btn = (UIButton *)[self.itemScroll viewWithTag:tag];
    CGFloat offset_x = btn.center.x - dScreenWidth/2;
    offset_x = offset_x > 0 ? offset_x : 0;
    CGFloat offset_x_max = self.itemScroll.contentSize.width - self.itemScroll.frame.size.width;
    offset_x = offset_x > offset_x_max ? offset_x_max : offset_x;
    [self.itemScroll setContentOffset:CGPointMake(offset_x, 0) animated:YES];
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
