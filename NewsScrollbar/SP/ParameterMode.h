//
//  ParameterMode.h
//  NewsScrollbar
//
//  Created by 杜文亮 on 2018/2/7.
//  Copyright © 2018年 杜文亮. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ParameterMode : NSObject

@property (nonatomic,assign) CGFloat item_width;
@property (nonatomic,assign) CGFloat item_height;
@property (nonatomic,strong) UIColor *item_bg_color;
@property (nonatomic,strong) UIColor *item_unSel_color;
@property (nonatomic,strong) UIColor *item_sel_color;
@property (nonatomic,assign) NSInteger item_counts;
@property (nonatomic,strong) NSArray *item_names;
@property (nonatomic,strong) NSArray *vc_names;


-(instancetype)initWithItemWidth:(CGFloat)item_width ItemHeight:(CGFloat)item_height ItemBGColor:(UIColor *)item_bg_color ItemUnSelColor:(UIColor *)item_unSel_color ItemSelColor:(UIColor *)item_sel_color ItemCounts:(NSInteger)item_counts ItemNames:(NSArray *)item_names VcNames:(NSArray *)vc_names;

@end
