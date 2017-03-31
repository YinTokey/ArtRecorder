//
//  YJVideoCell.m
//  ArtRecorder
//
//  Created by YinjianChen on 2017/3/31.
//  Copyright © 2017年 YinjianChen. All rights reserved.
//

#import "YJVideoCell.h"

@implementation YJVideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)CellWithTableView:(UITableView *)tableView{
    static NSString *reuseId = @"YJVideoCell";
    YJVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"YJVideoCell" owner:nil options:nil] lastObject];
        cell.imgV.contentMode = UIViewContentModeScaleAspectFill;
        cell.imgV.clipsToBounds = YES;
    }
    
    return cell;
}

- (void)setupWithDic:(NSDictionary *)dic{
    self.title.text = [dic objectForKey:@"title"];
    [self.imgV sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"feed"]]];
    
    UIImageView *blurr = [[UIImageView alloc]init];
    [self.imgV addSubview:blurr];
    [blurr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.with.right.with.bottom.left.equalTo(self.imgV);
    }];
    blurr.alpha = 0.2;
    [blurr sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"blurred"]]];
    
}

@end
