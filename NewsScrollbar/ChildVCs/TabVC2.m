//
//  TabVC2.m
//  NewsScrollbar
//
//  Created by 杜文亮 on 2018/2/3.
//  Copyright © 2018年 杜文亮. All rights reserved.
//

#import "TabVC2.h"

@interface TabVC2 ()

@end

@implementation TabVC2

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSLog(@"%@ --- 开始网络请求！",[self class]);
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"two"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"two"];
    }
    cell.textLabel.text = @"OK Everybody 跟我一起 hai hai hai~";
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Are You Keading?");
}




#pragma mark - deallc

-(void)dealloc
{
    NSLog(@"释放了：%@",[self class]);
}

@end
