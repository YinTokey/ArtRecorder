//
//  DetailViewController.h
//  ArtRecorder
//
//  Created by YinjianChen on 2017/4/1.
//  Copyright © 2017年 YinjianChen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YJVideoModel.h"

@interface DetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *desc;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgV;

@property(nonatomic,copy) NSString * playUrl;

@property(nonatomic,copy) NSString * descs;

@property(nonatomic,copy) NSString * titletext;

@property(nonatomic,copy) NSString * feed;

@property(nonatomic,copy) NSString * blurred;

@end
