//
//  HomeViewController.m
//  ArtRecorder
//
//  Created by Decade on 2017/2/19.
//  Copyright © 2017年 YinjianChen. All rights reserved.
//

#import "HomeViewController.h"
#import "RecorderViewController.h"
#import "VideoViewController.h"
@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupButtons];
}

- (void)setupButtons{
    UIButton *startBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 160, 80)];
    [startBtn setTitle:@"START" forState:UIControlStateNormal];
    startBtn.backgroundColor = [UIColor blackColor];
    [self.view addSubview:startBtn];
    @weakify(self);
    [startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY).with.offset(-80);
        make.size.mas_equalTo(CGSizeMake(160, 80));
    }];
    [[startBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        RecorderViewController *recorderVC = [[RecorderViewController alloc]init];
        @strongify(self);
        [self.navigationController pushViewController:recorderVC animated:NO];
    }];

    UIButton *openBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 160, 80)];
    [openBtn setTitle:@"OPEN" forState:UIControlStateNormal];
    openBtn.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:openBtn];
    [openBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY).with.offset(80);
        make.size.mas_equalTo(CGSizeMake(160, 80));
    }];
    [[openBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        VideoViewController *videoVC = [[VideoViewController alloc]init];
        @strongify(self);
        [self.navigationController pushViewController:videoVC animated:NO];
    }];
    
}



@end
