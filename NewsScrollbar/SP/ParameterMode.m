//
//  ParameterMode.m
//  NewsScrollbar
//
//  Created by 杜文亮 on 2018/2/7.
//  Copyright © 2018年 杜文亮. All rights reserved.
//


#import "ParameterMode.h"
#import "MacroDefinition.h"


@implementation ParameterMode

-(instancetype)initWithItemWidth:(CGFloat)item_width ItemHeight:(CGFloat)item_height ItemBGColor:(UIColor *)item_bg_color ItemUnSelColor:(UIColor *)item_unSel_color ItemSelColor:(UIColor *)item_sel_color ItemCounts:(NSInteger)item_counts ItemNames:(NSArray *)item_names VcNames:(NSArray *)vc_names
{
    if (self = [super init])
    {
        _item_width = item_width * item_counts > dScreenWidth ? item_width : dScreenWidth / item_counts;
        _item_height = item_height;
        _item_bg_color = item_bg_color;
        _item_unSel_color = item_unSel_color;
        _item_sel_color = item_sel_color;
        _item_counts = item_counts;
        _item_names = item_names;
        _vc_names = vc_names;
    }
    return self;
}

@end
