//
//  UserViewController.m
//  Artist
//
//  Created by 夏天乐 on 2018/12/9.
//  Copyright © 2018 HB. All rights reserved.
//

#import "UserViewController.h"
#import "UserTableViewCell.h"
#import "WorkDetailViewController.h"
#import "ArtistTableViewCell.h"
#import "HomeDetailViewController.h"
@interface UserViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *workTableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UISegmentedControl *UserSegment;
@property  int length;
@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //tableView代理
    _length = 10;
    _workTableView.delegate = self;
    _workTableView.dataSource = self;
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    //作品cell
        UserTableViewCell *workCell = [tableView dequeueReusableCellWithIdentifier:@"workCell" forIndexPath:indexPath];
        //设置圆角
        workCell.artistImage.layer.cornerRadius = workCell.artistImage.frame.size.width / 2;
        //将多余的部分切掉
        workCell.artistImage.layer.masksToBounds = YES;
        //对cell填写内容
        if(indexPath.row%2 ==0){
            workCell.workImage.image=[UIImage imageNamed:@"向日葵"];
            workCell.workLabel.text =@"向日葵";
        }
        else if(indexPath.row%3 ==0){
            workCell.workImage.image=[UIImage imageNamed:@"星夜"];
            workCell.workLabel.text =@"星夜";
        }
        else{
            workCell.workImage.image=[UIImage imageNamed:@"麦田群鸦"];
            workCell.workLabel.text =@"麦田群鸦";
        }
    //艺术家cell
    ArtistTableViewCell *artistCell = [tableView dequeueReusableCellWithIdentifier:@"artistCell" forIndexPath:indexPath];
    //隐藏滚动条
    artistCell.artistScrollView.showsHorizontalScrollIndicator = NO;
    //设置圆角
    artistCell.artistImage.layer.cornerRadius = artistCell.artistImage.frame.size.width / 2;
    //将多余的部分切掉
    artistCell.artistImage.layer.masksToBounds = YES;
    UIImageView *anthorImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,120, 120)];
    anthorImage1.image = [UIImage imageNamed:@"星夜"];
    [artistCell.artistScrollView addSubview:anthorImage1];
    UIImageView *anthorImage2 = [[UIImageView alloc]initWithFrame:CGRectMake(130, 0,120, 120)];
    anthorImage2.image = [UIImage imageNamed:@"向日葵"];
    [artistCell.artistScrollView addSubview:anthorImage2];
    UIImageView *anthorImage3 = [[UIImageView alloc]initWithFrame:CGRectMake(260,0,120, 120)];
    anthorImage3.image = [UIImage imageNamed:@"麦田群鸦"];
    [artistCell.artistScrollView addSubview:anthorImage3];
    
    //圆角
    anthorImage1.layer.cornerRadius=10;
    anthorImage2.layer.cornerRadius=10;
    anthorImage3.layer.cornerRadius=10;
    anthorImage1.layer.masksToBounds=YES;
    anthorImage2.layer.masksToBounds=YES;
    anthorImage3.layer.masksToBounds=YES;
    UILabel *anthorLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, 120, 20)];
    anthorLabel1.backgroundColor=[UIColor blackColor];
    anthorLabel1.textColor = [UIColor yellowColor];
    anthorLabel1.text=@"星夜";
    [anthorImage1 addSubview:anthorLabel1];
    //字体居中
    anthorLabel1.textAlignment = UITextAlignmentCenter;
    
    UILabel *anthorLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, 120, 20)];
    anthorLabel2.backgroundColor=[UIColor blackColor];
    anthorLabel2.textColor = [UIColor yellowColor];
    anthorLabel2.text=@"向日葵";
    [anthorImage2 addSubview:anthorLabel2];
    //字体居中
    anthorLabel2.textAlignment = UITextAlignmentCenter;
    
    UILabel *anthorLabel3 = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, 120, 20)];
    anthorLabel3.backgroundColor=[UIColor blackColor];
    anthorLabel3.textColor = [UIColor yellowColor];
    anthorLabel3.text=@"麦田群鸦";
    [anthorImage3 addSubview:anthorLabel3];
    //字体居中
    anthorLabel3.textAlignment = UITextAlignmentCenter;
    //字体和大小
    [anthorLabel1 setFont:[UIFont fontWithName:@"Helvetica" size:14]];
    [anthorLabel2 setFont:[UIFont fontWithName:@"Helvetica" size:14]];
    [anthorLabel3 setFont:[UIFont fontWithName:@"Helvetica" size:14]];
     if(_UserSegment.selectedSegmentIndex ==1){
         return artistCell;
     }
    return workCell;
}
#pragma  行数设置
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _length;
}
#pragma section数目设置
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
#pragma  tableCell跳转
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //storyboard跳转
    if(_UserSegment.selectedSegmentIndex ==1){
        HomeDetailViewController *detail=[self.storyboard instantiateViewControllerWithIdentifier:@"homeDetail"];
        [self.navigationController pushViewController:detail animated:YES];
    }else{
    WorkDetailViewController *detail=[self.storyboard instantiateViewControllerWithIdentifier:@"worksDetail"];
    [self.navigationController pushViewController:detail animated:YES];
    }
}
#pragma 删除行
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
#pragma 是否可编辑
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

#pragma 编辑模式
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //出现alterView隐藏删除按钮
    [tableView setEditing:NO animated:YES];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否取消关注？" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            //删除
            //必须先删除数据源
            self->_length=self->_length-1;
            [self->_dataArray removeObjectAtIndex:indexPath.row];
             [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}
#pragma 删除样式
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"取消关注";
}
#pragma segemnt点击
- (IBAction)changeSegment:(id)sender {
    [_workTableView reloadData];
}

@end
