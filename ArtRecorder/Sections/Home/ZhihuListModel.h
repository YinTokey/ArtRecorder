//
//  ZhihuListModel.h
//  ArtRecorder
//
//  Created by YinjianChen on 2017/4/5.
//  Copyright © 2017年 YinjianChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZhihuListModel : NSObject

@property (nonatomic,copy) NSString *type;

@property (nonatomic,copy) NSString *id;

@property (nonatomic,copy) NSString *title;

@property (nonatomic,strong) NSArray *images;

@end
