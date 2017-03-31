//
//  DetailViewController.m
//  ArtRecorder
//
//  Created by YinjianChen on 2017/4/1.
//  Copyright © 2017年 YinjianChen. All rights reserved.
//

#import "DetailViewController.h"

#import "PlayViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleLabel.text = self.titletext;
    [self.imgV sd_setImageWithURL:[NSURL URLWithString:self.feed]];
    self.desc.text = self.descs;
    
}
- (IBAction)playClick:(id)sender {
    
    PlayViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"playVC"];
    vc.playUrl= self.playUrl;
    [self.navigationController pushViewController:vc animated:YES];
}



@end
