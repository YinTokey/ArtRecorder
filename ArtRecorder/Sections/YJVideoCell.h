//
//  YJVideoCell.h
//  ArtRecorder
//
//  Created by YinjianChen on 2017/3/31.
//  Copyright © 2017年 YinjianChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YJVideoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UILabel *title;



+ (instancetype)CellWithTableView:(UITableView *)tableView;
- (void)setupWithDic:(NSDictionary *)dic;
@end
