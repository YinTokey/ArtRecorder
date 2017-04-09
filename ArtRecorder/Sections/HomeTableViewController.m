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
#import "DetailViewController.h"
#import "ZhihuListModel.h"
#import "XRCarouselView.h"

@interface HomeTableViewController ()<XRCarouselViewDelegate>
@property(nonatomic ,strong) NSMutableArray *datasourceDics;

@property(nonatomic ,strong) NSMutableArray *zhihuListArray;
@property (nonatomic, strong) XRCarouselView *carouselView;

@property(nonatomic ,strong) NSArray *imagesArray;
@property(nonatomic ,strong) NSArray *decArray;


@end

@implementation HomeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 232;
    
    self.datasourceDics = [NSMutableArray array];
    self.zhihuListArray = [NSMutableArray array];
    self.imagesArray = [NSArray array];
    self.decArray = [NSArray array];
    
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

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:@"https://news-at.zhihu.com/api/7/theme/3" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       
        NSArray *tmpArray = [responseObject objectForKey:@"stories"];
        self.zhihuListArray =  [ZhihuListModel mj_objectArrayWithKeyValuesArray:tmpArray];
        [self setupHeaderView];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}


- (void)setupHeaderView{
    
    ZhihuListModel *model1= [_zhihuListArray objectAtIndex:3];
    ZhihuListModel *model2= [_zhihuListArray objectAtIndex:4];
    ZhihuListModel *model3= [_zhihuListArray objectAtIndex:5];
    ZhihuListModel *model4= [_zhihuListArray objectAtIndex:6];
    
    self.imagesArray = @[[model1.images firstObject],
                     [model2.images firstObject],
                     [model3.images firstObject],
                     [model4.images firstObject]
                     
                     ];
    
    
    self.decArray = @[model1.title,model2.title,model3.title,model4.title];

    self.carouselView = [[XRCarouselView alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 180)];

    _carouselView.imageArray = _imagesArray;
    _carouselView.describeArray = _decArray;
    
    //用代理处理图片点击
    _carouselView.delegate = self;
    
    //设置每张图片的停留时间，默认值为5s，最少为2s
    _carouselView.time = 2;

    UIFont *font = [UIFont systemFontOfSize:20];
    [_carouselView setDescribeTextColor:nil font:font bgColor:nil];
    
    self.tableView.tableHeaderView = _carouselView;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DetailViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"detailVC"];
    NSDictionary *dic = [self.datasourceDics objectAtIndex:indexPath.row];
    
    vc.playUrl = [dic objectForKey:@"playUrl"];
    vc.descs = [dic objectForKey:@"description"];
    vc.titletext = [dic objectForKey:@"title"];
    vc.feed = [dic objectForKey:@"feed"];
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)carouselView:(XRCarouselView *)carouselView clickImageAtIndex:(NSInteger)index{
    
    
    NSLog(@"%zd",index);
}


@end
