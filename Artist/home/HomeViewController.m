//
//  HomeViewController.m
//  Artist
//
//  Created by 夏天乐 on 2018/12/7.
//  Copyright © 2018 HB. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeTableViewCell.h"
#import "HomeDetailViewController.h"
#import "AFNetworking.h"
@interface HomeViewController ()<UISearchBarDelegate, UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *homeImage;
@property (weak, nonatomic) IBOutlet UISearchBar *homeSearch;
@property (weak, nonatomic) IBOutlet UITableView *homeTableView;
@property (weak, nonatomic) IBOutlet UIScrollView *homeScrollView;
//获得请求结果
@property (strong, nonatomic) NSMutableArray *artistList;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //searchbar代理
    _homeSearch.delegate = self;
    _homeTableView.delegate = self;
    _homeTableView.dataSource = self;
    [self getArtistList];
}

//UIView子类结束编辑达到隐藏键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
#pragma 搜索按下search代理方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
}
#pragma mark -- 单元格填充
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"homeCell" forIndexPath:indexPath];
    cell.tag =100;
    //对cell填写内容
    cell.artistName.text = _artistList[indexPath.row][@"artist_name"];
    cell.artistImage.image = [UIImage imageNamed:_artistList[indexPath.row][@"artist_img"]];
    cell.artistContent.text = _artistList[indexPath.row][@"artist_title"];
    //长度自适应
    [cell.artistName sizeToFit];
    [cell.artistContent sizeToFit];
    //设置圆角
    cell.artistImage.layer.cornerRadius = cell.artistImage.frame.size.width / 2;
    //将多余的部分切掉
     cell.artistImage.layer.masksToBounds = YES;
    return cell;
}


#pragma section数目设置
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
#pragma 行数设置
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(_artistList){
        return [_artistList count];
    }else{
        return 1;
    }
}
#pragma  行高设置
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}
#pragma  tableCell跳转
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //storyboard跳转
    HomeDetailViewController *detail=[self.storyboard instantiateViewControllerWithIdentifier:@"homeDetail"];
    //跨页面传值
   detail.artist_id =_artistList[indexPath.row][@"artist_id"];
     detail.artist_genre =_artistList[indexPath.row][@"artist_genre"];
    [self.navigationController pushViewController:detail animated:YES];
}
#pragma 使用AFNetworking POST请求示例
-(void)getArtistList{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //设置请求数据格式自动转换为JSON
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    // manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain",@"text/html", nil];
    
    NSDictionary *paramDict = @{};
    [manager POST:@"http://127.0.0.1:3000/back/api/getArtistList" parameters:paramDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@---%@",[responseObject class],responseObject);
        //赋值给全局变量
        self->_artistList = responseObject;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->_homeTableView reloadData];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败--%@",error);
    }];
}
@end
