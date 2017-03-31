//
//  HomeTableViewController.m
//  ArtRecorder
//
//  Created by YinjianChen on 2017/3/31.
//  Copyright © 2017年 YinjianChen. All rights reserved.
//

#import "HomeTableViewController.h"
#import <Bmob.h>
#import "YJVideoCell.h"
@interface HomeTableViewController ()
@property(nonatomic ,strong) NSMutableArray *datasourceDics;
@end

@implementation HomeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 232;
    
    self.datasourceDics = [NSMutableArray array];
    
    BmobQuery   *bquery = [BmobQuery queryWithClassName:@"home"];
    //查找GameScore表的数据
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        for(BmobObject *obj in array){
            
            NSString *title = [NSString stringWithFormat:@"%@",[obj objectForKey:@"title"]];
            NSString *description = [NSString stringWithFormat:@"%@",[obj objectForKey:@"description"]];
            NSString *blurred = [NSString stringWithFormat:@"%@",[obj objectForKey:@"blurred"]];
            NSString *feed = [NSString stringWithFormat:@"%@",[obj objectForKey:@"feed"]];
            NSString *playUrl = [NSString stringWithFormat:@"%@",[obj objectForKey:@"playUrl"]];
            NSDictionary *dic = [[NSDictionary alloc]initWithObjects:@[title,description,blurred,feed,playUrl] forKeys:@[@"title",@"description",@"blurred",@"feed",@"playUrl"]];
            
            [self.datasourceDics addObject:dic];
        }
        [self.tableView reloadData];
    }];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _datasourceDics.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YJVideoCell *cell = [YJVideoCell CellWithTableView:tableView];
    NSDictionary *dic = [self.datasourceDics objectAtIndex:indexPath.row];
    [cell setupWithDic:dic];
    
    
    return cell;
}


@end
