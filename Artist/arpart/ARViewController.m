//
//  ARViewController.m
//  Artist
//
//  Created by 夏天乐 on 2018/12/11.
//  Copyright © 2018 HB. All rights reserved.
//

#import "ARViewController.h"
#import <SceneKit/SceneKit.h>
#import <ARKit/ARKit.h>
@interface ARViewController ()<ARSKViewDelegate>
@property (strong, nonatomic) IBOutlet ARSKView *imageARSKView;
/// 创建会话
@property (nonatomic, strong) ARSession *arSession;
/// 创建追踪(摄像头位置改变之后可以进行位置追踪)
@property (nonatomic, strong) ARConfiguration *arConfiguration;

@end

@implementation ARViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    ARConfiguration *arImage = [[ARConfiguration alloc] init];
//    SKSpriteNode *imageNode = [SKSpriteNode spriteNodeWithImageNamed:@"向日葵"];
//    [_imageARSKView addSubview:imageNode];
    [self.view addSubview:self.imageARSKView];
    self.imageARSKView.delegate = self;
//    self.imageARSKView.scene = @"😢";
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //创建设备追踪设置
    ARWorldTrackingConfiguration *configuration = [ARWorldTrackingConfiguration new];
    self.imageARSKView.session = [[ARSession alloc]init];
    // 加载配置
    [self.imageARSKView.session runWithConfiguration:configuration];
}

@end
