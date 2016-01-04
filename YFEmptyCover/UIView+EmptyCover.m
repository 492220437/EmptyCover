//
//  UIView+EmptyCover.m
//  YFEmptyCoverDemo
//
//  Created by YANGFENG on 16/1/4.
//  Copyright © 2016年 杨峰. All rights reserved.
//

#import "UIView+EmptyCover.h"
#import <objc/runtime.h>

NSString const *EmptyCover = @"EmptyCover";
NSString const *EmptyCoverSource = @"EmptyCoverSource";
NSString const *EmptyCoverUserInfo = @"EmptyCoverUserInfo";
NSString const *EmptyCoverBounce = @"EmptyCoverBounce";


@interface UIView ()

@property(strong,nonatomic)UIView* emptyCover; //覆盖viewCover

@end

@interface UITableView (EmptyCover)

-(void)swizzled;
@end

@interface UICollectionView (EmptyCover)

-(void)swizzled;
@end



@implementation UIView (EmptyCover)
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
//存储table原本的bounce
-(void)setEmptyCoverBounce:(NSNumber* )separatorStyle
{
    objc_setAssociatedObject(self, &EmptyCoverBounce, separatorStyle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(NSNumber* )EmptyCoverBounce
{
    return  objc_getAssociatedObject(self, &EmptyCoverBounce);
}
//代理
-(void)setEmptyCoverSource:(id<UIViewEmptyCoverSource>)emptyCoverSource
{
    if ([self isKindOfClass:[UITableView class]]) {
        
        [(UITableView*)self swizzled];
    }
    else if ([self isKindOfClass:[UICollectionView class]]) {
        
        [(UICollectionView*)self swizzled];
    }
    else
    {
        //view
    }
    objc_setAssociatedObject(self, &EmptyCoverSource, emptyCoverSource, OBJC_ASSOCIATION_ASSIGN);
}

-(id<UIViewEmptyCoverSource>)emptyCoverSource
{
    return  objc_getAssociatedObject(self, &EmptyCoverSource);
}


-(void)reloadEmptyCover
{
    if (!self.emptyCoverSource) {
        
        return;
    }
    
    if ([self itemCount]>0) {
        
        if ([self isKindOfClass:[UIScrollView class]])
        {
            if ([self EmptyCoverBounce]) {
                
                [(UIScrollView*)self setBounces:[[self EmptyCoverBounce] boolValue]];
            }
        }
        [self.emptyCover removeFromSuperview];
        
        self.emptyCover = nil;
        
    }
    else
    {
        if (self.emptyCover) {
            
            [self.emptyCover removeFromSuperview];
            
            self.emptyCover = nil;
        }
        
        if ([self.emptyCoverSource conformsToProtocol:@protocol(UIViewEmptyCoverSource)]&&[self.emptyCoverSource respondsToSelector:@selector(emptyCoverViewFromInitializeEmptyCoverView:onView:)]) {
            
            EmptyCoverView *emptyCoverView = [[[UINib nibWithNibName:@"EmptyCoverView" bundle:nil] instantiateWithOwner:nil options:nil]firstObject];
            
            self.emptyCover = [self.emptyCoverSource emptyCoverViewFromInitializeEmptyCoverView:emptyCoverView onView :self];
        }
        else
        {
            self.emptyCover = [[[UINib nibWithNibName:@"EmptyCoverView" bundle:nil] instantiateWithOwner:nil options:nil]firstObject];
        }
        
        if (self.emptyCover) {
            
            if (([self isKindOfClass:[UITableView class]]||[self isKindOfClass:[UICollectionView class]])&&self.subviews.count>1) {
                
                //只有当bounces为yes的时候才存储，可以防止多次请求为空，将用NO将yes覆盖导致scrollView不能弹跳
                if ([(UIScrollView*)self bounces]) {
                    
                    [self setEmptyCoverBounce:[NSNumber numberWithBool:YES]];
                }

                [(UIScrollView*)self setBounces:NO];
                
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

