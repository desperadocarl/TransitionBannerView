//
//  ViewController.m
//
//  Created by 费宇超 on 2018/2/2.
//  Copyright © 2018年 费宇超. All rights reserved.
//

#import "ViewController.h"
#import "ELTransitionView.h"
#import "ELTransitionBannerView.h"

@interface ViewController ()<ELTransitionBannerViewDelegate>
@property (nonatomic, strong) ELTransitionView * vTransition;
@property (nonatomic, strong) ELTransitionBannerView * bannerView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    self.bannerView = [[ELTransitionBannerView alloc] initWithFrame:CGRectMake(10, rectStatus.size.height + 4 + 44, self.view.frame.size.width-20, (self.view.frame.size.width-30)/750*400 + 26 + 10)];
    self.bannerView.delegate = self;
    self.bannerView.hidden = YES;
    self.bannerView.alpha = 0;
    [self.view addSubview:self.bannerView];

    
    NSMutableArray * arr = [[NSMutableArray alloc] init];
    [arr addObject:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1517595972082&di=a0ed81be6c36f4fc64b027cac4dc8417&imgtype=0&src=http%3A%2F%2Fimg4.duitang.com%2Fuploads%2Fitem%2F201602%2F03%2F20160203165826_8VQiX.jpeg"];
    [arr addObject:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1517595972082&di=ae2aaab145760e6d7d201e9f52c57fa8&imgtype=0&src=http%3A%2F%2Fimg5q.duitang.com%2Fuploads%2Fitem%2F201502%2F18%2F20150218224907_NN5SG.jpeg"];
    [arr addObject:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1517595972082&di=248986537313aabe7d3f864035e69ff0&imgtype=0&src=http%3A%2F%2Ff4.topitme.com%2F4%2Fd6%2Faa%2F112483878856faad64o.jpg"];
    self.bannerView.imageURLs = [arr copy];
    
    [self shakeAim];
    
}

- (void)shakeAim{
    [self.bannerView shakeAim];
}

- (void)bannerView:(ELTransitionBannerView *)bannerView didClickAtIndex:(NSUInteger)index{
    NSLog(@"外面点击的是哪一个呢++%ld",(long)index);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

