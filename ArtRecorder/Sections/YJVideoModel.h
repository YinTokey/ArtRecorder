//
//  YJVideoModel.h
//  ArtRecorder
//
//  Created by YinjianChen on 2017/3/31.
//  Copyright © 2017年 YinjianChen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JKDBModel.h"
@interface YJVideoModel : JKDBModel

@property(nonatomic,copy) NSString * title;

@property(nonatomic,copy) NSString * playUrl;

@property(nonatomic,copy) NSString * feed;

@property(nonatomic,copy) NSString * desc;

@property(nonatomic,copy) NSString * blurred;

@end
