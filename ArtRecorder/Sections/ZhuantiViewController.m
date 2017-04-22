//
//  ZhuantiViewController.m
//  ArtRecorder
//
//  Created by YinjianChen on 2017/4/13.
//  Copyright © 2017年 YinjianChen. All rights reserved.
//

#import "ZhuantiViewController.h"
#import "YJDiscoverViewController.h"
#import <Bmob.h>
@interface ZhuantiViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) NSMutableArray *Array;

@end

@implementation ZhuantiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableview.dataSource = self;
    self.tableview.delegate = self;
    self.Array = [NSMutableArray array];
    
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"subject"];
    //查找GameScore表的数据
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        for(BmobObject *obj in array){
            
            NSString *title = [NSString stringWithFormat:@"%@",[obj objectForKey:@"title"]];

            
            [self.Array addObject:title];
        }
        [self.tableview reloadData];
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _Array.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *reuseId = @"reuseCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseId];
    }
    
    NSString *string = self.Array[indexPath.row];
    
    cell.textLabel.text = string;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
        YJDiscoverViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"YJDiscoverViewController"];
        vc.query = _Array[indexPath.row];
        [self.navigationController pushViewController:vc animated:YES];

}

#warning Incomplete implementation, return the number of rows
    
//- (IBAction)IGN:(id)sender {
//    
//    YJDiscoverViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"YJDiscoverViewController"];
//    vc.query = @"IGN";
//    [self.navigationController pushViewController:vc animated:YES];
//    
//}
//- (IBAction)guamo:(id)sender {
//    YJDiscoverViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"YJDiscoverViewController"];
//    vc.query = @"guamo";
//    [self.navigationController pushViewController:vc animated:YES];
//    
//}
//- (IBAction)record:(id)sender {
//    YJDiscoverViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"YJDiscoverViewController"];
//    vc.query = @"record";
//    [self.navigationController pushViewController:vc animated:YES];
//    
//}

@end
