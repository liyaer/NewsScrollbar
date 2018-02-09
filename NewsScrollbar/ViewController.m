//
//  ViewController.m
//  NewsScrollbar
//
//  Created by 杜文亮 on 2018/2/7.
//  Copyright © 2018年 杜文亮. All rights reserved.
//

#import "ViewController.h"
#import "SPNewsScrollVC.h"
#import "ParameterMode.h"
#import "SSNewsScrollVC.h"


@interface ViewController ()

@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)showSPVC:(id)sender
{
    //请确保参数设置准确无误
    ParameterMode *mode = [[ParameterMode alloc] initWithItemWidth:80 ItemHeight:40 ItemBGColor:[UIColor whiteColor] ItemUnSelColor:[UIColor grayColor] ItemSelColor:[UIColor redColor] ItemCounts:6 ItemNames:@[@"军事",@"科技",@"文化",@"内容",@"流感",@"哈哈"] VcNames:@[@"TabVC1",@"TabVC2",@"SameVC",@"SameVC",@"SameVC",@"SameVC"]];
    SPNewsScrollVC *vc = [[SPNewsScrollVC alloc] initWithParameter:mode];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)ShowSSVC:(id)sender
{
    SSNewsScrollVC *vc = [[SSNewsScrollVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
