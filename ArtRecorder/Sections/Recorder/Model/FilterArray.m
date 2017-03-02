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
    NSDictionary * dic1 = [NSDictionary dictionaryWithObjectsAndKeys:Filter1,@"filter",title1,@"name", nil];
    [arr addObject:dic1];
    
    GPUImageOutput<GPUImageInput> * Filter2 = [[GPUImageWhiteBalanceFilter alloc] init];
    NSString * title2 = @"暖色调";
    [(GPUImageWhiteBalanceFilter *)Filter2 setTemperature:8000];
    [(GPUImageWhiteBalanceFilter *)Filter2 setTint:50];
    NSDictionary * dic2 = [NSDictionary dictionaryWithObjectsAndKeys:Filter2,@"filter",title2,@"name", nil];
    [arr addObject:dic2];
    
    
    GPUImageOutput<GPUImageInput> * Filter7 = [[GPUImageSepiaFilter alloc] init];
    NSString * title7 = @"褐色怀旧";
    NSDictionary * dic7 = [NSDictionary dictionaryWithObjectsAndKeys:Filter7,@"filter",title7,@"name", nil];
    [arr addObject:dic7];
    
    GPUImageOutput<GPUImageInput> * Filter8 = [[GPUImageGrayscaleFilter alloc] init];
    NSString * title8 = @"灰度";
    NSDictionary * dic8 = [NSDictionary dictionaryWithObjectsAndKeys:Filter8,@"filter",title8,@"name", nil];
    [arr addObject:dic8];
    
    GPUImageOutput<GPUImageInput> * Filter9 = [[GPUImageHistogramGenerator alloc] init];
    NSString * title9 = @"色彩直方图？";
    NSDictionary * dic9 = [NSDictionary dictionaryWithObjectsAndKeys:Filter9,@"filter",title9,@"name", nil];
    [arr addObject:dic9];
    
    GPUImageOutput<GPUImageInput> * Filter10 = [[GPUImageRGBFilter alloc] init];
    NSString * title10 = @"RGB";
    [(GPUImageRGBFilter *)Filter10 setRed:0.8];
    [(GPUImageRGBFilter *)Filter10 setGreen:0.3];
    [(GPUImageRGBFilter *)Filter10 setBlue:0.5];
    NSDictionary * dic10 = [NSDictionary dictionaryWithObjectsAndKeys:Filter10,@"filter",title10,@"name", nil];
    [arr addObject:dic10];
    
    GPUImageOutput<GPUImageInput> * Filter11 = [[GPUImageMonochromeFilter alloc] init];
    [(GPUImageMonochromeFilter *)Filter11 setColorRed:0.3 green:0.5 blue:0.8];
    NSString * title11 = @"单色";
    NSDictionary * dic11 = [NSDictionary dictionaryWithObjectsAndKeys:Filter11,@"filter",title11,@"name", nil];
    [arr addObject:dic11];
    
    
    GPUImageOutput<GPUImageInput> * Filter15 = [[GPUImageSketchFilter alloc] init];
    //    [(GPUImageSobelEdgeDetectionFilter *)Filter13 ];
    NSString * title15 = @"素描";
    NSDictionary * dic15 = [NSDictionary dictionaryWithObjectsAndKeys:Filter15,@"filter",title15,@"name", nil];
    [arr addObject:dic15];
    
    GPUImageOutput<GPUImageInput> * Filter16 = [[GPUImageSmoothToonFilter alloc] init];
    //    [(GPUImageSobelEdgeDetectionFilter *)Filter13 ];
    NSString * title16 = @"卡通";
    NSDictionary * dic16 = [NSDictionary dictionaryWithObjectsAndKeys:Filter16,@"filter",title16,@"name", nil];
    [arr addObject:dic16];
    
    
    GPUImageOutput<GPUImageInput> * Filter17 = [[GPUImageColorPackingFilter alloc] init];
    //    [(GPUImageSobelEdgeDetectionFilter *)Filter13 ];
    NSString * title17 = @"监控";
    NSDictionary * dic17 = [NSDictionary dictionaryWithObjectsAndKeys:Filter17,@"filter",title17,@"name", nil];
    [arr addObject:dic17];
    
    GPUImageOutput<GPUImageInput> * Filter25 = [[GPUImageEmbossFilter alloc] init];
    NSString * title25 = @"浮雕";
    NSDictionary * dic25 = [NSDictionary dictionaryWithObjectsAndKeys:Filter25,@"filter",title25,@"name", nil];
    [arr addObject:dic25];
    

    return arr;
}
@end
