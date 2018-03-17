//
//  TabVC1.m
//  NewsScrollbar
//
//  Created by 杜文亮 on 2018/2/3.
//  Copyright © 2018年 杜文亮. All rights reserved.
//

#import "TabVC1.h"

@interface TabVC1 ()

@end

@implementation TabVC1

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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"one"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"one"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"TabOne 0-%ld",indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"TabOne 0-%ld",indexPath.row);
}



#pragma mark - deallc

-(void)dealloc
{
    NSLog(@"释放了：%@",[self class]);
}

@end
