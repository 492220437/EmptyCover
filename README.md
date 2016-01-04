# YFEmptyCover
当页面／列表无数据时显示友好的提示并引导用户做出选择


# 用法
# 第一步 
    #import "UIView+EmptyCover.h"并设置<UIViewEmptyCoverSource>

# 第二步
    
    self.tableView.emptyCoverSource = self;
    或
    self.collectionView.emptyCoverSource = self;
    或
    self.view.emptyCoverSource = self;//暂时未开发

# 第三步（可选）
    
    #pragma mark UIScrollViewEmptyCoverSource

    -(UIView *)emptyCoverViewFromInitializeEmptyCoverView:(EmptyCoverView *)emptyCoverView onView:(UIView *)view
    {
        //不会有cover显示；
        return nil;

        //显示自定义view；
        return [UIView new];

        //显示默认EmptyCoverView，效果等同不实现emptyCoverViewFromInitializeEmptyCoverView：onView方法
        return emptyCoverView;

        //自定义emptyCoverView；
        emptyCoverView.imageView.image = nil;
        emptyCoverView.titleLbl.text = @"Cover";

        //可以通过给view.userinfo传值来判断是网络问题，还是无数据，还是其他，来修改coverview的显示
        if (view.userInfo) {
            emptyCoverView.actionBtn.hidden = YES;
        }
        else
        {
            emptyCoverView.actionBtn.hidden = NO;
        }
        return emptyCoverView;

    }
