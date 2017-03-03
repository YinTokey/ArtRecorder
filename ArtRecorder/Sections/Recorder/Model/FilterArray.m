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
    [(GPUImageWhiteBalanceFilter *)Filter2 setTint:100];
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
    
    GPUImageOutput<GPUImageInput> * Filter15 = [[GPUImageSketchFilter alloc] init];
    //    [(GPUImageSobelEdgeDetectionFilter *)Filter13 ];
    NSString * title15 = @"素描";
    NSDictionary * dic15 = [NSDictionary dictionaryWithObjectsAndKeys:Filter15,@"filter",title15,@"name", nil];
    [arr addObject:dic15];

    

    return arr;
}
@end
