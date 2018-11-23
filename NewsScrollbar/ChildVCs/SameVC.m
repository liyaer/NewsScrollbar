//
//  SameVC.m
//  NewsScrollbar
//
//  Created by 杜文亮 on 2018/2/7.
//  Copyright © 2018年 杜文亮. All rights reserved.
//


#import "SameVC.h"
#import "MacroDefinition.h"

@interface SameVC ()

@end

@implementation SameVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = DRandomColor;
    
    NSLog(@"%@ --- 开始网络请求！",[self class]);
    
    if (self.classId)
    {
        NSLog(@"子VC用同一个，通过classId:%@区分",self.classId);
    }
}

#pragma mark - deallc

-(void)dealloc
{
    NSLog(@"释放了：%@",[self class]);
}

@end
