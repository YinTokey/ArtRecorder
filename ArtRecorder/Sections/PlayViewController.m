//
//  PlayViewController.m
//  ArtRecorder
//
//  Created by YinjianChen on 2017/4/1.
//  Copyright © 2017年 YinjianChen. All rights reserved.
//

#import "PlayViewController.h"

@interface PlayViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webview;

@end

@implementation PlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSURL* url = [NSURL URLWithString:self.playUrl];//创建URL
    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
    [_webview loadRequest:request];//加载
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
