//
//  YJPersonViewController.m
//  ArtRecorder
//
//  Created by YinjianChen on 2017/4/3.
//  Copyright © 2017年 YinjianChen. All rights reserved.
//

#import "YJPersonViewController.h"
#import "DetailViewController.h"
@interface YJPersonViewController ()

@property (nonatomic,strong) NSMutableArray *collectedArray;

@end

@implementation YJPersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.collectedArray = [NSMutableArray arrayWithArray:[YJVideoModel findAll]];
    [self.tableView reloadData];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return _collectedArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    static NSString *reuseId = @"reuseCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseId];
    }
    
    YJVideoModel *model = self.collectedArray[indexPath.row];
    
    cell.textLabel.text = model.title;
    
    return cell;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *action = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        //从数据库中删除对应的纪录
        YJVideoModel *model = self.collectedArray[indexPath.row];
        [model deleteObject];
        
        //删除cell
        [self.collectedArray removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
    }];
    
    
    return @[action];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"detailVC"];
    YJVideoModel *model = self.collectedArray[indexPath.row];
    
    vc.playUrl = model.playUrl;
    vc.descs = model.desc;
    vc.titletext = model.title;
    vc.feed = model.feed;
    vc.blurred = model.blurred;
    
    [self.navigationController pushViewController:vc animated:YES];
}


@end
