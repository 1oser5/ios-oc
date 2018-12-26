//
//  CategoryViewController.m
//  Artist
//
//  Created by 夏天乐 on 2018/12/10.
//  Copyright © 2018 HB. All rights reserved.
//

#import "CategoryViewController.h"
#import "CategoryTableViewCell.h"
@interface CategoryViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *categoryTableView;

@end

@implementation CategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _categoryTableView.delegate  = self;
    _categoryTableView.dataSource = self;
}

#pragma  行数设置
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}
#pragma section数目设置
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma 单元格填充
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
     CategoryTableViewCell *categoryCell = [tableView dequeueReusableCellWithIdentifier:@"categoryCell" forIndexPath:indexPath];
    return categoryCell;
}
#pragma 高度设置
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 340;
}
//#pragma  tableCell跳转
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    //storyboard跳转
//        HomeDetailViewController *detail=[self.storyboard instantiateViewControllerWithIdentifier:@"homeDetail"];
//        [self.navigationController pushViewController:detail animated:YES];
//}
@end
