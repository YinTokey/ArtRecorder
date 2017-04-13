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
#import "buttonCell.h"
#import "ZhuantiViewController.h"
#import "NotiViewController.h"
#import "PlayViewController.h"
@interface HomeTableViewController ()<XRCarouselViewDelegate,buttonCellDelegate>
@property(nonatomic ,strong) NSMutableArray *datasourceDics;

@property(nonatomic ,strong) NSMutableArray *zhihuListArray;
@property (nonatomic, strong) XRCarouselView *carouselView;

@property(nonatomic ,strong) NSArray *imagesArray;
@property(nonatomic ,strong) NSArray *decArray;


@end

@implementation HomeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        return 76;
    }else{
        return 232;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

  return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 1;
    }else{
        return _datasourceDics.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        buttonCell *cell = [buttonCell CellWithTableView:tableView];
        cell.delegate = self;
        return cell ;
    }else{
        YJVideoCell *cell = [YJVideoCell CellWithTableView:tableView];
        NSDictionary *dic = [self.datasourceDics objectAtIndex:indexPath.row];
        [cell setupWithDic:dic];
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 1){
        DetailViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"detailVC"];
        NSDictionary *dic = [self.datasourceDics objectAtIndex:indexPath.row];
        
        vc.playUrl = [dic objectForKey:@"playUrl"];
        vc.descs = [dic objectForKey:@"description"];
        vc.titletext = [dic objectForKey:@"title"];
        vc.feed = [dic objectForKey:@"feed"];
        
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)carouselView:(XRCarouselView *)carouselView clickImageAtIndex:(NSInteger)index{
    
    ZhihuListModel *model = _zhihuListArray[index];
    NSString *urlStr = [NSString stringWithFormat:@"https://news-at.zhihu.com/api/7/story/%@",model.id];
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *detailUrlStr = [responseObject objectForKey:@"share_url"];
        PlayViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"playVC"];
        vc.playUrl = detailUrlStr;
        [self.navigationController pushViewController:vc animated:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
    
    NSLog(@"%zd",index);
}

- (void)ClickNoti{
    NotiViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"NotiViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)ClickZhuanti{
    ZhuantiViewController *vc = [[self storyboard]instantiateViewControllerWithIdentifier:@"ZhuantiViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
