//
//  ZhuantiViewController.m
//  ArtRecorder
//
//  Created by YinjianChen on 2017/4/13.
//  Copyright © 2017年 YinjianChen. All rights reserved.
//

#import "ZhuantiViewController.h"
#import "YJDiscoverViewController.h"

@interface ZhuantiViewController ()

@end

@implementation ZhuantiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)IGN:(id)sender {
    
    YJDiscoverViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"YJDiscoverViewController"];
    vc.query = @"IGN";
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (IBAction)guamo:(id)sender {
    YJDiscoverViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"YJDiscoverViewController"];
    vc.query = @"guamo";
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (IBAction)record:(id)sender {
    YJDiscoverViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"YJDiscoverViewController"];
    vc.query = @"record";
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
