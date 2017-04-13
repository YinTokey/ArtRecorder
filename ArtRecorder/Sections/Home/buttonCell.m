//
//  buttonCell.m
//  ArtRecorder
//
//  Created by YinjianChen on 2017/4/10.
//  Copyright © 2017年 YinjianChen. All rights reserved.
//

#import "buttonCell.h"

@implementation buttonCell

+ (instancetype)CellWithTableView:(UITableView *)tableView{
    static NSString *reuseId = @"butttonCell";
    buttonCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"buttonCell" owner:nil options:nil] lastObject];

    }
    
    return cell;
}

- (IBAction)zhuantiClcik:(id)sender {
    if([self.delegate respondsToSelector:@selector(ClickZhuanti)]){
        [self.delegate ClickZhuanti];
    }
    
    
}
- (IBAction)notiClick:(id)sender {
    
    if([self.delegate respondsToSelector:@selector(ClickNoti)]){
        [self.delegate ClickNoti];
    }
}

@end
