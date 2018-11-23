//
//  ScaleModeVC.m
//  NewsScrollbar
//
//  Created by 杜文亮 on 2018/2/26.
//  Copyright © 2018年 杜文亮. All rights reserved.
//

#import "ScaleModeVC.h"
#import "SameVC.h"


@interface ScaleModeVC ()

@end


@implementation ScaleModeVC

- (void)viewDidLoad
{
    [self setBasicsParameter:^(CGRect *frame, NSArray *__autoreleasing *titles, CGFloat *title_space, UIFont *__autoreleasing *title_font, UIColor *__autoreleasing *title_bgColor, UIColor *__autoreleasing *title_sel_color, UIColor *__autoreleasing *title_deSel_color, CGFloat *title_scroll_h, UIColor *__autoreleasing *title_scroll_bgColor, NSArray *__autoreleasing *vcNames, NSInteger *selectIndex, effectMode *mode)
     {
         //必须设置的参数
         *titles = @[@"军事",@"科技范",@"哈哈第三方士大夫"];
         //模拟使用场景一:
         *vcNames = @[@"TabVC1",@"SameVC",@"TabVC2"];
         //模拟使用场景二：
//         NSMutableArray *arr_m = [NSMutableArray arrayWithCapacity:3];
//         for (int i = 0; i < 3; i++)
//         {
//             SameVC *vc = [[SameVC alloc] init];
//             vc.classId = [NSNumber numberWithInt:i].stringValue;
//             [arr_m addObject:vc];
//         }
//         *vcNames = arr_m;
         
         //可选参数的设置
         *frame = CGRectMake(50, 100, 200, 300);
         *selectIndex = 2;
         *title_deSel_color = [UIColor blueColor];
         *title_sel_color = [UIColor orangeColor];
         *mode = titleColorSlideGradientMode;
     }];
    
//    [self setOtherMode:scaleMode parameter:nil];
//    [self setOtherMode:underLineMode parameter:@(2.0)];
    [self setOtherMode:coverMode parameter:[UIColor yellowColor]];
    
    [super viewDidLoad];
}


@end
