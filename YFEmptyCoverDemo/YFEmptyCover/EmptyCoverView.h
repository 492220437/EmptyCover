//
//  EmptyCoverView.h
//  NoData
//
//  Created by YANGFENG on 15/9/18.
//  Copyright (c) 2015年 杨峰. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmptyCoverView : UIView

@property (weak, nonatomic) IBOutlet UIView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *detaileLbl;
@property (weak, nonatomic) IBOutlet UIButton *actionBtn;

@end
