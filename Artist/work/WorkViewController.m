//
//  WorksDetailViewController.m
//  Artist
//
//  Created by 夏天乐 on 2018/12/9.
//  Copyright © 2018 HB. All rights reserved.
//
#define screenHeight [[UIScreen mainScreen]bounds].size.height //屏幕高度
#define screenWidth [[UIScreen mainScreen]bounds].size.width   //屏幕宽度
#define colletionCell 2  //设置具体几列
#import "WorkViewController.h"
#import "WorkDetailViewController.h"
#import "AFNetworking.h"
@interface WorkViewController ()<UICollectionViewDataSource, UICollectionViewDelegate> {
    UICollectionView *collectionView;
    NSMutableArray  *hArr; //记录每个cell的高度
}
@property (strong, nonatomic) NSMutableArray *workList;
@end

@implementation WorkViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self getAllWorks];
    self.navigationItem.title=@"主要作品";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor blackColor]}];
    hArr = [[NSMutableArray alloc] init];
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc]init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical]; //设置横向还是竖向
    collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, screenWidth ,screenHeight) collectionViewLayout:flowLayout];
    collectionView.dataSource=self;
    collectionView.delegate=self;
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    [collectionView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:collectionView];
    
}
-(void)jumpToDeep{
    //storyboard跳转
    WorkViewController *detail=[self.storyboard instantiateViewControllerWithIdentifier:@"worksDetail"];
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma mark -- UICollectionViewDataSource

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
     return [_workList count];
//    return 10;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"UICollectionViewCell";
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    //    移除cell,不然则会出现错位问题
    for (id subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    cell.backgroundColor= [UIColor blueColor];
    NSInteger remainder=indexPath.row%colletionCell;
    NSInteger currentRow=indexPath.row/colletionCell;
//    NSLog(@"reminder:%ld,currentRow:%ld",(long)remainder,currentRow);
    CGFloat   currentHeight=[hArr[indexPath.row] floatValue];
    CGFloat positonX=(screenWidth/colletionCell-8)*remainder+5*(remainder+1);
    CGFloat positionY=(currentRow+1)*5;
    for (NSInteger i=0; i<currentRow; i++) {
        NSInteger position=remainder+i*colletionCell;
        positionY+=[hArr[position] floatValue];
    }
    cell.frame = CGRectMake(positonX, positionY,screenWidth/colletionCell-8,currentHeight) ;//重新定义cell位置、宽高
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, cell.frame.size.width, cell.frame.size.height)];
    img.image = [UIImage imageNamed:_workList[indexPath.row][@"work_img"]];
    [cell.contentView addSubview:img];

    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height=120+(arc4random()%120);
    [hArr addObject:[NSString stringWithFormat:@"%f",height]];
    return  CGSizeMake(screenWidth/colletionCell-8, height);  //设置cell宽高
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0,0, 0, 0);
}

#pragma mark --UICollectionViewDelegate

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //storyboard跳转
     WorkDetailViewController *detail=[self.storyboard instantiateViewControllerWithIdentifier:@"worksDetail"];
    detail.work_id =_workList[indexPath.row][@"work_id"];
    [self.navigationController pushViewController:detail animated:YES];
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
#pragma 所有作品调取
-(void)getAllWorks{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //设置请求数据格式自动转换为JSON
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSDictionary *paramDict = @{
                                @"artist_id":_artist_id
                                };
    [manager POST:@"http://127.0.0.1:3000/back/api/getAllWorks" parameters:paramDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                NSLog(@"%@---%@",[responseObject class],responseObject);
       //赋值给全局变量
        self->_workList = responseObject;
//         NSLog(@"%@",_workList);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->collectionView reloadData];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败--%@",error);
    }];
}

@end
