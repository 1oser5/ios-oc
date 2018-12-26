//
//  WorkDetailViewController.m
//  Artist
//
//  Created by 夏天乐 on 2018/12/9.
//  Copyright © 2018 HB. All rights reserved.
//

#import "WorkDetailViewController.h"
#import "AFNetworking.h"
@interface WorkDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *artistImage;
@property (weak, nonatomic) IBOutlet UIScrollView *anthorScrollView;
@property (weak, nonatomic) IBOutlet UITextView *readTextView;
@property (weak, nonatomic) IBOutlet UIImageView *detailImage;
@property (weak, nonatomic) IBOutlet UILabel *artistName;
@property (weak, nonatomic) IBOutlet UILabel *work_name;
@property (weak, nonatomic) UIView *background;
@property (weak, nonatomic) IBOutlet UILabel *crate_time;
@property (weak, nonatomic) IBOutlet UILabel *create_medium;
@property (weak, nonatomic) IBOutlet UILabel *work_size;
//大图
@property (strong, nonatomic) UIImageView *image;
@property (strong , nonatomic) NSMutableArray *checkAry;
@property (strong, nonatomic) NSMutableArray *greatAry;

@end

@implementation WorkDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getWorkDetail];
    [self getSameWork];
    self.navigationItem.title = @"作品详情";
     [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor blackColor]}];
    //设置圆角
    _artistImage.layer.cornerRadius = _artistImage.frame.size.width / 2;
    //将多余的部分切掉
    _artistImage.layer.masksToBounds = YES;
    //textView不可编辑
    [_readTextView setEditable:NO];
    //禁止滚动
    _readTextView.scrollEnabled = NO;
    //禁止选择
    _readTextView.selectable = NO;
    //隐藏滚动条
    _anthorScrollView.showsHorizontalScrollIndicator = NO;
     //开启用户交互
    UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showBigPhoto)];
    _detailImage.userInteractionEnabled=YES;
    [_detailImage addGestureRecognizer:tapGesturRecognizer];
    //创建初始化可变数组
    _greatAry = [[NSMutableArray alloc] initWithObjects:@0, @3, @4, @1, @5, @7, @2, @6, @8, nil];
}
-(void)showBigPhoto{
    UIView *photoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 375, 812)];
    photoView.backgroundColor = [UIColor blackColor];
   _image = [[UIImageView alloc]initWithFrame:CGRectMake(0, (812-_detailImage.frame.size.height)/2,  _detailImage.frame.size.width, _detailImage.frame.size.height)];
    _image.image = _detailImage.image;
    //赋给全局变量background
    _background = photoView;
    [_background addSubview:_image];
    [self.view addSubview:_background];
    _image.userInteractionEnabled = YES;
    //位置数组
    NSArray *locationAry = @[@[@0,@0],@[@0,@1],@[@0,@2],@[@1,@0],@[@2,@0],@[@1,@1],@[@1,@2],@[@2,@1],@[@2,@2]];
    NSArray *randomAry = @[@(0),@(1),@(2),@(3),@(4),@(5),@(6),@(7),@(8)];
    randomAry = [self randomAry:randomAry];
    _checkAry = [randomAry mutableCopy];
    //puzzle
    int flag = 0;
    for(int i = 0 ; i < 3;i++){
        for(int j = 0; j < 3; j++){
            UIImageView *subImg = [[UIImageView alloc]initWithFrame:CGRectMake((_image.frame.size.width/3)*i, (_image.frame.size.height/3)*j,_image.frame.size.width/3, _image.frame.size.height/3)];
            subImg.tag=100+(10*i)+j;
            //获得随机数index
            int index = [randomAry[flag] integerValue];
            //获得随机坐标
            int postionX = [locationAry[index][0] integerValue];
            int postionY = [locationAry[index][1] integerValue];
            //分割UIImage对象
            //CGImageCreateWithImageInRect将UIImge图片按照规定的大小进行分割，由于是3倍图，不需h除3，又因为要把宽高比转化为3/2,所以要除
            CGRect rest = CGRectMake(_image.frame.size.width/3*2*postionY, _image.frame.size.height*postionX,_image.frame.size.width/3*2, _image.frame.size.height);
            CGImageRef imageRef = CGImageCreateWithImageInRect(_image.image.CGImage, rest);
            //将CGImage转化成UIImage
            UIImage *imageNew = [UIImage imageWithCGImage:imageRef];
            //将新获得的小图片 添加在UIImageView上
            subImg.image = imageNew;
            //为所有的imageView视图添加手势
            subImg.userInteractionEnabled = YES;
            //添加拖拽手势
            UIPanGestureRecognizer *tapGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panView:)];
            [subImg addGestureRecognizer:tapGesture];
            //加入主视图
            [_image addSubview:subImg];
            //随机数组加1
            flag++;
        }
        
    }
    //添加点击手势（即点击图片后退出全屏）
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeView)];
    [_image addGestureRecognizer:tapGesture];
    //将大图归零
    _image.image = nil;
    
}
#pragma 随机函数
-(NSArray*)randomAry:(NSArray*)ary{
    NSArray *randomAry = [ary sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        if (arc4random_uniform(2) == 0) { // arc4random_uniform会随机返回一个0到上界之间（不含上界）的整数。以2为上界会得到0或1，像投硬币一样
            return [obj2 compare:obj1];// descending
        } else {
            return [obj1 compare:obj2];// ascending
        }
    }];
    //计算逆序总数
    int count = 0;
    for (int i=0;i<8;i++){
        for(int j = i+1;j<9;j++){
            if(randomAry[i]>randomAry[j]){
                count++;
            }
        }
    }
    //判断0的位置
    int zero_position = 0;
    for(int i = 0; i < 9; i++)
    {
        if(randomAry[i] == 0){
            zero_position = i;
        }
    }
    //如果0和总逆序数奇偶不同，则递归
    if(zero_position%2 != count%2){
        [self randomAry:randomAry];
    }
    return randomAry;
}
-(void)panView:(UIPanGestureRecognizer *)sender{
    //手势偏移量
    CGPoint point=[sender translationInView:_image];
    UIImageView *moveImg =  (UIImageView *)[self.view viewWithTag:sender.view.tag];
    UIImageView *leftImg = (UIImageView *)[self.view viewWithTag:sender.view.tag-10];
    UIImageView *rightImg = (UIImageView *)[self.view viewWithTag:sender.view.tag+10];
    UIImageView *topImg = (UIImageView *)[self.view viewWithTag:sender.view.tag-1];
    UIImageView *buttomImg = (UIImageView *)[self.view viewWithTag:sender.view.tag+1];
    //向右移动交换
    if(point.x>75){
        //位置信息交换
        if(rightImg){
            [UIView animateWithDuration:0.3  animations:^{
                CGRect rect = moveImg.frame;
                moveImg.frame = rightImg.frame;
                rightImg.frame = rect;
            } completion:nil];
            //tag交换
            NSInteger index = moveImg.tag;
            moveImg.tag = rightImg.tag;
            rightImg.tag = index;
            //清空移动距离
            [sender setTranslation:CGPointZero inView:_image];
            int j = sender.view.tag%10;
            int i = (sender.view.tag/10%10);
            NSLog(@"%d,%d",i,j);
            NSObject *item = _checkAry[j+3*i];
            _checkAry[j+3*i] = _checkAry[j+i*3-3];
            _checkAry[j+i*3-3] = item;
            if([_checkAry isEqual:_greatAry]){
                UIView *successView= [[UIView alloc]initWithFrame:CGRectMake(-100, 200, 150, 30)];
                successView.backgroundColor = [UIColor whiteColor];
                UILabel *Congratulation = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, 150, 30)];
                Congratulation.text = @"拼图成功!";
                [successView addSubview:Congratulation];
                [_background addSubview:successView];
                [UIView animateWithDuration:0.3  animations:^{
                    CGRect rect = CGRectMake(-40, 200, 150,30);
                    successView.frame = rect;
                }];
            }
        }
    }
    //向左移动交换
    if(point.x<-75){
        //位置信息交换
        if(leftImg){
            [UIView animateWithDuration:0.3  animations:^{
                CGRect rect = moveImg.frame;
                moveImg.frame = leftImg.frame;
                leftImg.frame = rect;
            } completion:nil];
            //tag交换
            NSInteger index = moveImg.tag;
            moveImg.tag = leftImg.tag;
            leftImg.tag = index;
            //清空移动距离
            [sender setTranslation:CGPointZero inView:_image];
            int j = sender.view.tag%10;
            int i = (sender.view.tag/10%10);
            NSLog(@"%d,%d",i,j);
            NSObject *item = _checkAry[j+3*i];
            _checkAry[j+3*i] = _checkAry[j+i*3+3];
            _checkAry[j+i*3+3] = item;
            if([_checkAry isEqual:_greatAry]){
                UIView *successView= [[UIView alloc]initWithFrame:CGRectMake(-100, 200, 150, 30)];
                successView.backgroundColor = [UIColor whiteColor];
                UILabel *Congratulation = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, 150, 30)];
                Congratulation.text = @"拼图成功!";
                [successView addSubview:Congratulation];
                [_background addSubview:successView];
                [UIView animateWithDuration:0.3  animations:^{
                    CGRect rect = CGRectMake(-40, 200, 150,30);
                    successView.frame = rect;
                }];
            }
        }
    }
    //向上移动交换
    if(point.y<-50){
        //位置信息交换
        if(topImg){
            [UIView animateWithDuration:0.3  animations:^{
                CGRect rect = moveImg.frame;
                moveImg.frame = topImg.frame;
                topImg.frame = rect;
            } completion:nil];
            //tag交换
            NSInteger index = moveImg.tag;
            moveImg.tag = topImg.tag;
            topImg.tag = index;
            //清空移动距离
            [sender setTranslation:CGPointZero inView:_image];
            int j = sender.view.tag%10;
            int i = (sender.view.tag/10%10);
            NSObject *item = _checkAry[j+3*i];
            _checkAry[j+3*i] = _checkAry[j+i*3+1];
            _checkAry[j+i*3+1] = item;
            if([_checkAry isEqual:_greatAry]){
                UIView *successView= [[UIView alloc]initWithFrame:CGRectMake(-100, 200, 150, 30)];
                successView.backgroundColor = [UIColor whiteColor];
                UILabel *Congratulation = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, 150, 30)];
                Congratulation.text = @"拼图成功!";
                [successView addSubview:Congratulation];
                [_background addSubview:successView];
                [UIView animateWithDuration:0.3  animations:^{
                    CGRect rect = CGRectMake(-40, 200, 150,30);
                    successView.frame = rect;
                }];
            }
        }
    }
    //向下移动交换
    if(point.y>50){
        //位置信息交换
        if(buttomImg){
            [UIView animateWithDuration:0.3  animations:^{
                CGRect rect = moveImg.frame;
                moveImg.frame = buttomImg.frame;
                buttomImg.frame = rect;
            } completion:nil];
            //tag交换
            NSInteger index = moveImg.tag;
            moveImg.tag = buttomImg.tag;
            buttomImg.tag = index;
            //清空移动距离
            [sender setTranslation:CGPointZero inView:_image];
            int j = sender.view.tag%10;
            int i = (sender.view.tag/10%10);
            NSObject *item = _checkAry[j+3*i];
            _checkAry[j+3*i] = _checkAry[j+i*3-1];
            _checkAry[j+i*3-1] = item;
            if([_checkAry isEqual:_greatAry]){
                UIView *successView= [[UIView alloc]initWithFrame:CGRectMake(-100, 200, 150, 30)];
                successView.backgroundColor = [UIColor whiteColor];
                UILabel *Congratulation = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, 150, 30)];
                Congratulation.text = @"拼图成功!";
                [successView addSubview:Congratulation];
                [_background addSubview:successView];
                [UIView animateWithDuration:0.3  animations:^{
                    CGRect rect = CGRectMake(-40, 200, 150,30);
                    successView.frame = rect;
                }];
            }
            }
        }
}
#pragma  关闭图片
-(void)closeView{
    [_background removeFromSuperview];
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

#pragma 获得作品详情
-(void)getWorkDetail{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置请求数据格式自动转换为JSON
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSDictionary *paramDict = @{
                                @"work_id":_work_id
                                };
    [manager POST:@"http://127.0.0.1:3000/back/api/getWorkDetail" parameters:paramDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                        NSLog(@"%@---%@",[responseObject class],responseObject);
        self->_detailImage.image = [UIImage imageNamed:responseObject[0][@"work_img"]];
        self->_work_name.text = responseObject[0][@"work_name"];
        self->_crate_time.text = responseObject[0][@"create_time"];
        self->_create_medium.text = responseObject[0][@"create_medium"];
        self->_work_size.text = responseObject[0][@"work_size"];
        self->_readTextView.text = responseObject[0][@"work_detail"];
        //赋值给全局变量
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败--%@",error);
    }];
}

#pragma 获得类似作品
-(void)getSameWork{
    //1.创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置请求数据格式自动转换为JSON
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSDictionary *paramDict = @{
                                @"work_id":_work_id,
                                @"artist_id":@1
                                };
    [manager POST:@"http://127.0.0.1:3000/back/api/getSameWork" parameters:paramDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                NSLog(@"%@---%@",[responseObject class],responseObject);
        //赋值给全局变量
        int index = arc4random()%15;
        NSLog(@"%d",index);
        int j =0;
        for(int i = index;i<index+3;i++){
            UIImageView *anthorImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(160*j, 0,150, 140)];
            anthorImage1.image = [UIImage imageNamed:responseObject[i][@"work_img"]];
            [_anthorScrollView addSubview:anthorImage1];
            //圆角
            anthorImage1.layer.cornerRadius=10;
            anthorImage1.layer.masksToBounds=YES;
            //添加作家名
            UILabel *anthorLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 110, 150, 30)];
            anthorLabel1.backgroundColor=[UIColor blackColor];
            anthorLabel1.textColor = [UIColor yellowColor];
            anthorLabel1.text=responseObject[i][@"work_name"];
            [anthorImage1 addSubview:anthorLabel1];
            //字体加粗
            [anthorLabel1 setFont:[UIFont fontWithName:@"Helvetica" size:14]];
            //字体居中
            anthorLabel1.textAlignment = UITextAlignmentCenter;
            //y位置偏移
            j++;
        }
       
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败--%@",error);
    }];
}
@end
