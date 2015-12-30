//
//  ViewController.m
//  YFEmptyCoverDemo
//
//  Created by YANGFENG on 15/12/30.
//  Copyright © 2015年 杨峰. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property(assign, nonatomic)int num;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.tableView.emptyCoverSource = self;
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.num;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    return cell;
}


- (IBAction)emprty:(id)sender {
    
    self.num = 0;
    
    [self.tableView reloadData];
}
- (IBAction)nomal:(id)sender {
    
    self.num = 10;
    
    [self.tableView reloadData];
    
}
#pragma mark UIScrollViewEmptyCoverSource

-(UIView *)emptyCoverViewFromInitializeEmptyCoverView:(EmptyCoverView *)emptyCoverView inScrollView:(UIScrollView *)scrollView
{
    //emptyCoverView.titleLbl.hidden = YES;
   
    emptyCoverView.titleLbl.text = @"title";
    emptyCoverView.detaileLbl.text=@"detaile";
    [emptyCoverView.actionBtn setTitle:@"Action" forState:UIControlStateNormal];
    [emptyCoverView.actionBtn addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    return emptyCoverView;
}
-(void)action:(UIButton*)btn
{
    
}
@end
