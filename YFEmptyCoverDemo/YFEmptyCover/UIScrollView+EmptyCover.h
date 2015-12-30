//
//  UIScrollView+EmptyCover.h
//  NoData
//
//  Created by YANGFENG on 15/9/17.
//  Copyright (c) 2015年 杨峰. All rights reserved.
//
/**
 *  第一步：引用<UIScrollViewEmptyCoverSource>
 *  第二步：设置self.emptyCoverSource = self;
 *  第三步：实现emptyCoverViewFromInitializeEmptyCoverView：inScrollView，该方法会自动生成一个emptyCoverView，自定义后return 即可。
 *
 *  三步缺一都不会显示
 */
#import <UIKit/UIKit.h>
#import "EmptyCoverView.h"

@protocol UIScrollViewEmptyCoverSource <NSObject>
/**
 *  UIScrollViewEmptyCoverSource用于配置浮层view
 *
 *  @param emptyCoverView 初始化的emptyCoverView，需要赋值
 *  @param scrollView     当前scrollview
 *
 *  @return 返回一个view，可以是配置后的emptyCoverView的，也可以是自定义view，可以为nil；
 */
-(UIView*)emptyCoverViewFromInitializeEmptyCoverView:(EmptyCoverView*)emptyCoverView  inScrollView:(UIScrollView*)scrollView ;

@end

/**
 *  主逻辑在这里，方便通用于tableview和collectionview
 */
@interface UIScrollView (EmptyCover)
/**
 *  不需要赋值，若赋值，第一次有效，之后会置为nil；
 */
@property(strong,nonatomic)UIView* emptyCover;
/**
 *  代理，需要显示浮层就必须设置，交换reloadData方法在这里执行。
 */
@property(weak,nonatomic)id <UIScrollViewEmptyCoverSource> emptyCoverSource;
/**
 *  可以在配置EmptyCoverView时获取，用来传递一些信息，比如提示信息，或者判断是空还是网络问题。默认为nil；
 */
@property(strong,nonatomic)NSDictionary *userInfo;

@end


/**
 *  以下方法无用
 */
@interface UITableView (EmptyCover)

-(void)swizzled;
@end

@interface UICollectionView (EmptyCover)

-(void)swizzled;
@end