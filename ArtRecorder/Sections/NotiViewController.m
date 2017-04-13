//
//  NotiViewController.m
//  ArtRecorder
//
//  Created by YinjianChen on 2017/4/13.
//  Copyright © 2017年 YinjianChen. All rights reserved.
//

#import "NotiViewController.h"

@interface NotiViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *notiSwitch;

@end

@implementation NotiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)SWITCH:(id)sender {
    
    if(_notiSwitch.selected){
        NSLog(@"open");
    }else{
        NSLog(@"close");
    }
    
    _notiSwitch.selected = !_notiSwitch.selected;
}

@end
