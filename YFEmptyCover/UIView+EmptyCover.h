//
//  UIView+EmptyCover.h
//  YFEmptyCoverDemo
//
//  Created by YANGFENG on 16/1/4.
//  Copyright © 2016年 杨峰. All rights reserved.
//


/**
 *  第一步：引用<UIScrollViewEmptyCoverSource>
 *  第二步：设置self.emptyCoverSource = self;
 *  第三步：实现emptyCoverViewFromInitializeEmptyCoverView：onView，该方法会自动生成一个emptyCoverView，自定义后return 即可。
 *
 */

#import <UIKit/UIKit.h>
#import "EmptyCoverView.h"

@protocol UIViewEmptyCoverSource <NSObject>
/**
 *  UIScrollViewEmptyCoverSource用于配置浮层view
 *
 *  @param emptyCoverView 初始化的emptyCoverView，直接return emptyCoverView同没有实现UIViewEmptyCoverSource同样效果。
 *  @param view     当前view
 *
 *  @return 返回一个view，可以是配置后的emptyCoverView的，也可以是自定义view，可以为nil；
 */
-(UIView*)emptyCoverViewFromInitializeEmptyCoverView:(EmptyCoverView*)emptyCoverView  onView:(UIView*)view ;

@end

@interface UIView (EmptyCover)

/**
 *  代理，需要显示浮层就必须设置，交换reloadData方法在这里执行。
 */
@property(weak,nonatomic)id <UIViewEmptyCoverSource> emptyCoverSource;
/**
 *  可以在配置EmptyCoverView时获取，用来传递一些信息，比如提示信息，或者判断是空还是网络问题。默认为nil；
 */
@property(strong,nonatomic)NSDictionary *userInfo;


@end
