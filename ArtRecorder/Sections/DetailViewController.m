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
@property (weak, nonatomic) IBOutlet UIBarButtonItem *collectionBtn;

@property(nonatomic,strong) YJVideoModel *videoModel;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleLabel.text = self.titletext;
    [self.imgV sd_setImageWithURL:[NSURL URLWithString:self.feed]];
    self.desc.text = self.descs;
    
    _videoModel =  [[YJVideoModel alloc]init];
    _videoModel.title= self.title;
    _videoModel.description = self.description;
    _videoModel.playUrl = self.playUrl;
    _videoModel.feed = self.feed;
    _videoModel.blurred = self.blurred;
}
- (IBAction)playClick:(id)sender {
    
    PlayViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"playVC"];
    vc.playUrl= self.playUrl;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)collectClick:(id)sender {
    
    [_videoModel save];
    
}


@end
