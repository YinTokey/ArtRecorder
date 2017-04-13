//
//  buttonCell.h
//  ArtRecorder
//
//  Created by YinjianChen on 2017/4/10.
//  Copyright © 2017年 YinjianChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol buttonCellDelegate <NSObject>

- (void)ClickZhuanti;

- (void)ClickNoti;

@end

@interface buttonCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *zhuantiBtn;
@property (weak, nonatomic) IBOutlet UIButton *notiBtn;

@property(nonatomic,weak) id<buttonCellDelegate>delegate;


+ (instancetype)CellWithTableView:(UITableView *)tableView;

@end
