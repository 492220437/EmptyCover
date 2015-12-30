//
//  UIScrollView+EmptyCover.m
//  NoData
//
//  Created by YANGFENG on 15/9/17.
//  Copyright (c) 2015年 杨峰. All rights reserved.
//

#import "UIScrollView+EmptyCover.h"
#import <objc/runtime.h>
#import "EmptyCoverView.h"
NSString const *EmptyCover = @"EmptyCover";
NSString const *EmptyCoverSource = @"EmptyCoverSource";
NSString const *EmptyCoverUserInfo = @"EmptyCoverUserInfo";
NSString const *EmptyCoverSeparatorStyle = @"EmptyCoverSeparatorStyle";


@implementation UIScrollView (EmptyCover)
//浮层
-(void)setEmptyCover:(UIView *)emptyCover
{
     objc_setAssociatedObject(self, &EmptyCover, emptyCover, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(UIView *)emptyCover
{
    return  objc_getAssociatedObject(self, &EmptyCover);
}
//传递用户信息
-(void)setUserInfo:(NSDictionary *)userInfo
{
    objc_setAssociatedObject(self, &EmptyCoverUserInfo, userInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(NSDictionary *)userInfo
{
    return  objc_getAssociatedObject(self, &EmptyCoverUserInfo);
}
//存储table原本的separatorStyle
-(void)setEmptyCoverSeparatorStyle:(NSNumber* )separatorStyle
{
    objc_setAssociatedObject(self, &EmptyCoverSeparatorStyle, separatorStyle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(NSNumber* )EmptyCoverSeparatorStyle
{
    return  objc_getAssociatedObject(self, &EmptyCoverSeparatorStyle);
}


//代理
-(void)setEmptyCoverSource:(id<UIScrollViewEmptyCoverSource>)emptyCoverSource
{
     if ([self isKindOfClass:[UITableView class]]) {
         
         [(UITableView*)self swizzled];
     }
     else if ([self isKindOfClass:[UICollectionView class]]) {
         
         [(UICollectionView*)self swizzled];
     }
    objc_setAssociatedObject(self, &EmptyCoverSource, emptyCoverSource, OBJC_ASSOCIATION_ASSIGN);
}

-(id<UIScrollViewEmptyCoverSource>)emptyCoverSource
{
    return  objc_getAssociatedObject(self, &EmptyCoverSource);
}


-(void)reloadEmptyCover
{
    if (!self.emptyCoverSource||![self.emptyCoverSource conformsToProtocol:@protocol(UIScrollViewEmptyCoverSource) ]) {
        
        return;
    }
    
    if ([self itemCount]>0) {
        
        if ([self isKindOfClass:[UITableView class]])
        {
            if ([self EmptyCoverSeparatorStyle]) {
                
                [(UITableView*)self setSeparatorStyle:[[self EmptyCoverSeparatorStyle] intValue]];
            }
        }
        [self.emptyCover removeFromSuperview];
        
        self.emptyCover = nil;
        
    }
    else
    {
        if (!self.emptyCover) {

            EmptyCoverView *emptyCoverView = [[[UINib nibWithNibName:@"EmptyCoverView" bundle:nil] instantiateWithOwner:nil options:nil]firstObject];
            
            self.emptyCover = [self.emptyCoverSource emptyCoverViewFromInitializeEmptyCoverView:emptyCoverView inScrollView :self];
            
        }
        if (!self.emptyCover.superview) {

            if (([self isKindOfClass:[UITableView class]]||[self isKindOfClass:[UICollectionView class]])&&self.subviews.count>1) {

                if ([self isKindOfClass:[UITableView class]])
                {
                    [self setEmptyCoverSeparatorStyle:[NSNumber numberWithInt:[(UITableView*)self separatorStyle]]];
                    [(UITableView*)self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
                }
                
                [self insertSubview:self.emptyCover atIndex:1];
            }
            else
            {
                [self addSubview:self.emptyCover];
            }
            
            self.emptyCover.frame = self.emptyCover.superview.bounds;
            
            self.emptyCover.backgroundColor = self.emptyCover.superview.backgroundColor;
        }
    }
    
}
-(NSInteger)itemCount
{
    NSInteger items = 0;
    
    if ([self isKindOfClass:[UITableView class]]) {
        
        UITableView *view = (UITableView*)self;
        
        if (view.dataSource) {
            
            if ([view.dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
                
                NSInteger section = [view.dataSource numberOfSectionsInTableView:view];
                
                for (int i = 0; i < section; i++) {
                    
                    items += [view.dataSource tableView:view numberOfRowsInSection:i];
                }
                
            }
            else
            {
                items = [view.dataSource tableView:view numberOfRowsInSection:0];
            }
        }
 
    }
    else if ([self isKindOfClass:[UICollectionView class]]) {
        
        UICollectionView *view = (UICollectionView*)self;
        
        if (view.dataSource) {
            
            if ([view.dataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)]) {
                
                NSInteger section = [view.dataSource numberOfSectionsInCollectionView:view];
                
                for (int i = 0; i < section; i++) {
                    
                    items += [view.dataSource collectionView:view numberOfItemsInSection:i];
                }
                
            }
            else
            {
                items = [view.dataSource collectionView:view numberOfItemsInSection:0];
            }
        }
        
    }
    return items;
}
@end



@implementation UITableView (EmptyCover)

-(void)swizzled
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originalSelector = @selector(reloadData);
        
        SEL swizzledSelector = @selector(yf_reloadData);
        
        Method originalMethod = class_getInstanceMethod(self.class, originalSelector);
        
        Method swizzledMethod = class_getInstanceMethod(self.class, swizzledSelector);
        
        method_exchangeImplementations(originalMethod, swizzledMethod);
        
    });
    
}

-(void)yf_reloadData
{
    [self yf_reloadData];
    [self reloadEmptyCover];
}
@end


@implementation UICollectionView (EmptyCover)
-(void)swizzled
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originalSelector = @selector(reloadData);
        
        SEL swizzledSelector = @selector(yf_reloadData);
        
        Method originalMethod = class_getInstanceMethod(self.class, originalSelector);
        
        Method swizzledMethod = class_getInstanceMethod(self.class, swizzledSelector);
        
        method_exchangeImplementations(originalMethod, swizzledMethod);
        
    });
    
}
-(void)yf_reloadData
{
    [self yf_reloadData];
    [self reloadEmptyCover];
}

@end

