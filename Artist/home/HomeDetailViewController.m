//
//  HomeDetailViewController.m
//  Artist
//
//  Created by 夏天乐 on 2018/12/8.
//  Copyright © 2018 HB. All rights reserved.
//

#import "HomeDetailViewController.h"
#import "WorkViewController.h"
#import "ARViewController.h"
#import "AFNetworking.h"
@interface HomeDetailViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *titleImage;
@property (weak, nonatomic) IBOutlet UIImageView *artistImage;
@property (weak, nonatomic) IBOutlet UIScrollView *detailScrollView;
@property (weak, nonatomic) IBOutlet UIScrollView *anthorScrollView;
@property (weak, nonatomic) IBOutlet UILabel *artistName;
@property (weak, nonatomic) IBOutlet UILabel *artist_alive;
@property (weak, nonatomic) IBOutlet UILabel *artist_location;

@end

@implementation HomeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //毛玻璃样式
    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = CGRectMake(0,0,_titleImage.frame.size.width, _titleImage.frame.size.height);
    [_titleImage addSubview:effectView];
    
    //设置圆角
    _artistImage.layer.cornerRadius = _artistImage.frame.size.width / 2;
    //将多余的部分切掉
    _artistImage.layer.masksToBounds = YES;
    //滚动代理
    _detailScrollView.delegate = self;
    //隐藏滚动条
    _anthorScrollView.showsHorizontalScrollIndicator = NO;
   
    [self getArtistDetail];
    [self getSameArtist];
}
#pragma  处理滚动函数
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //监听
    CGRect rect = [self.view convertRect:self.view.frame toView:_artistName];
    //-64是是由于navgationbar的原因
    if(rect.origin.y>-64){
        //设置title格式
                [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor blackColor]}];
                self.navigationItem.title=@"Van Gogh";
            }else{
                 self.navigationItem.title=@"";
    }
}
#pragma 添加关注
- (IBAction)addMind:(UIButton*)button {
    if(button.backgroundColor == [UIColor blackColor]){
        button.backgroundColor = [UIColor yellowColor];
        [button setTitle: @"关注" forState: UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    }else{
        button.backgroundColor = [UIColor blackColor];
        [button setTitle: @"已关注" forState: UIControlStateNormal];
        [button setTitleColor:[UIColor yellowColor]forState:UIControlStateNormal];
    }
}
- (IBAction)moreDetail:(id)sender {
    //storyboard跳转
    WorkViewController *detail=[self.storyboard instantiateViewControllerWithIdentifier:@"work"];
    //跨页面传值
    detail.artist_id =self.artist_id;
    [self.navigationController pushViewController:detail animated:YES];
}

#pragma 作家详情接口调取
-(void)getArtistDetail{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //设置请求数据格式自动转换为JSON
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    // manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain",@"text/html", nil];
    //
//    NSNumber *number = [NSNumber numberWithInt:_artist_id];
    
    NSDictionary *paramDict = @{
                                @"artist_id":_artist_id
                                };
    [manager POST:@"http://127.0.0.1:3000/back/api/getArtistDetail" parameters:paramDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@---%@",[responseObject class],responseObject);
        //赋值给全局变量
        if(responseObject){
            self->_artistName.text = responseObject[0][@"artist_name"];
            self->_artistImage.image = [UIImage imageNamed:responseObject[0][@"artist_img"]];
            self->_artist_alive.text = responseObject[0][@"artist_live"];
            self->_artist_location.text = responseObject[0][@"artist_location"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败--%@",error);
    }];
}
#pragma 相似作家调取
-(void)getSameArtist{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //设置请求数据格式自动转换为JSON
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSDictionary *paramDict = @{
                                @"artist_genre": _artist_genre,
                                @"artist_id": _artist_id
                                };
    //2.发送POST请求
    /*
     第一个参数:请求路径(不包含参数).NSString
     第二个参数:字典(发送给服务器的数据~参数)
     第三个参数:progress 进度回调
     第四个参数:success 成功回调
     task:请求任务
     responseObject:响应体信息(JSON--->OC对象)
     第五个参数:failure 失败回调
     error:错误信息
     响应头:task.response
     */
    [manager POST:@"http://127.0.0.1:3000/back/api/getSameArtist" parameters:paramDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@---%@",[responseObject class],responseObject);
        if([responseObject count]!=0){
            for (int i =0;i<3;i++){
                UIImageView *anthorImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(150*i,0,140, 140)];
                anthorImage1.image = [UIImage imageNamed:responseObject[0][@"artist_img"]];
                [_anthorScrollView addSubview:anthorImage1];
                
                anthorImage1.layer.cornerRadius=10;
                anthorImage1.layer.masksToBounds=YES;
                //添加作家名
                UILabel *anthorLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 110, 140, 30)];
                anthorLabel1.backgroundColor=[UIColor blackColor];
                anthorLabel1.textColor = [UIColor yellowColor];
                anthorLabel1.text=responseObject[0][@"artist_name"];
                [anthorImage1 addSubview:anthorLabel1];
                //字体加粗
                [anthorLabel1 setFont:[UIFont fontWithName:@"Helvetica" size:14]];
                //字体居中
                anthorLabel1.textAlignment = UITextAlignmentCenter;
                
            }
        }
        //赋值给全局变量
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败--%@",error);
    }];
}
@end
