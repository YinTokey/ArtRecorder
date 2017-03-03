//
//  FilterArray.m
//  GPU-Video-Edit
//
//  Created by xiaoke_mh on 16/4/14.
//  Copyright © 2016年 m-h. All rights reserved.
//

#import "FilterArray.h"

@implementation FilterArray
+(NSArray *)creatFilterArray{
    NSMutableArray * arr = [NSMutableArray arrayWithCapacity:0];
    
    GPUImageOutput<GPUImageInput> * Filter1 = [[GPUImageWhiteBalanceFilter alloc] init];
    NSString * title1 = @"冷色调";
    [(GPUImageWhiteBalanceFilter *)Filter1 setTemperature:2000];
    [(GPUImageWhiteBalanceFilter *)Filter1 setTint:-100];
    NSString *filePath1 = [[NSBundle mainBundle] pathForResource:
                              @"filter_1" ofType:@"png"
                              ];
    
    UIImage *image1 = [UIImage imageWithContentsOfFile:filePath1];
    
    NSDictionary * dic1 = [NSDictionary dictionaryWithObjectsAndKeys:Filter1,@"filter",title1,@"name",image1,@"image", nil];
    [arr addObject:dic1];
    
    GPUImageOutput<GPUImageInput> * Filter2 = [[GPUImageWhiteBalanceFilter alloc] init];
    NSString * title2 = @"暖色调";
    [(GPUImageWhiteBalanceFilter *)Filter2 setTemperature:8000];
    [(GPUImageWhiteBalanceFilter *)Filter2 setTint:100];
    
    NSString *filePath2 = [[NSBundle mainBundle] pathForResource:
                           @"filter_2" ofType:@"png"
                           ];
    
    UIImage *image2 = [UIImage imageWithContentsOfFile:filePath2];
    NSDictionary * dic2 = [NSDictionary dictionaryWithObjectsAndKeys:Filter2,@"filter",title2,@"name",image2,@"image", nil];
    [arr addObject:dic2];
    
    
    GPUImageOutput<GPUImageInput> * Filter3 = [[GPUImageSepiaFilter alloc] init];
    NSString * title3 = @"褐色";
    NSString *filePath3 = [[NSBundle mainBundle] pathForResource:
                           @"filter_3" ofType:@"png"
                           ];
    
    UIImage *image3 = [UIImage imageWithContentsOfFile:filePath3];
    NSDictionary * dic3 = [NSDictionary dictionaryWithObjectsAndKeys:Filter3,@"filter",title3,@"name",image3,@"image", nil];
    [arr addObject:dic3];
    
    GPUImageOutput<GPUImageInput> * Filter4 = [[GPUImageGrayscaleFilter alloc] init];
    NSString * title4 = @"灰色";
    NSString *filePath4 = [[NSBundle mainBundle] pathForResource:
                           @"filter_4" ofType:@"png"
                           ];
    
    UIImage *image4 = [UIImage imageWithContentsOfFile:filePath4];
    
    NSDictionary * dic4 = [NSDictionary dictionaryWithObjectsAndKeys:Filter4,@"filter",title4,@"name",image4,@"image", nil];
    [arr addObject:dic4];
    
    GPUImageOutput<GPUImageInput> * Filter5 = [[GPUImageSketchFilter alloc] init];
    NSString * title5 = @"素描";
    NSString *filePath5 = [[NSBundle mainBundle] pathForResource:
                           @"filter_5" ofType:@"png"
                           ];
    
    UIImage *image5 = [UIImage imageWithContentsOfFile:filePath5];
    
    NSDictionary * dic5 = [NSDictionary dictionaryWithObjectsAndKeys:Filter5,@"filter",title5,@"name",image5,@"image", nil];
    [arr addObject:dic5];

    

    return arr;
}
@end
