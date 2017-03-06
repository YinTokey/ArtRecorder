//
//  RecorderViewController.m
//  ArtRecorder
//
//  Created by Decade on 2017/2/19.
//  Copyright © 2017年 YinjianChen. All rights reserved.
//

#import "RecorderViewController.h"
#import "FilterChooseView.h"
@interface RecorderViewController ()

@property (nonatomic,retain) GPUImageVideoCamera *camera;
@property (nonatomic,strong) GPUImageView * filterView;
@property (nonatomic,retain) GPUImageMovieWriter *writer;
@property (nonatomic,retain) GPUImageOutput<GPUImageInput> *filter;
@property (nonatomic,retain) FilterChooseView * chooseView;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic, assign) int count;

// Switching between front and back cameras
@end

@implementation RecorderViewController
{
    NSString *pathToMovie;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.hidden = YES;

    
    _filterView = [[GPUImageView alloc] initWithFrame:self.view.bounds];
    [self.view insertSubview:_filterView atIndex:0];
    
    self.camera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1280x720 cameraPosition:AVCaptureDevicePositionBack];
    self.camera.outputImageOrientation = UIInterfaceOrientationPortrait;
    self.camera.horizontallyMirrorFrontFacingCamera = NO;
    self.camera.horizontallyMirrorRearFacingCamera = NO;
    if (self.filter) {
        [self.camera addTarget:_filter];
        [_filter addTarget:_filterView];
    }else{
        [self.camera addTarget:_filterView];
    }
    [self.camera startCameraCapture];
    
    
    [self setupBtns];
    
    _chooseView = [[FilterChooseView alloc] initWithFrame:CGRectMake(0, 80, self.view.frame.size.width, 95)];
    @weakify(self);
    _chooseView.backback = ^(GPUImageOutput<GPUImageInput> * filter){
        @strongify(self);
        [self choose_callBack:filter];
    };
    [self.view addSubview:_chooseView];
    _chooseView.hidden = YES;
    

}

- (void)setupBtns{

    [[self.closeBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        [self.navigationController popViewControllerAnimated:NO];
    }];
    
    
    [[self.filterBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        
        if(_chooseView.hidden == YES){
            _chooseView.hidden = NO;
        }else{
            _chooseView.hidden = YES;
        }
        
    }];
    
    [[self.startBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        
        [self start_stop];
        
    }];
    
    [[self.switchBtn rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(id x) {
        
        
    }];

}

#pragma mark 选择滤镜
-(void)choose_callBack:(GPUImageOutput<GPUImageInput> *)filter
{
    BOOL isSelected = self.startBtn.isSelected;
    if (isSelected) {
        return;
    }
    self.filter = filter;
    [self.camera removeAllTargets];
    [self.camera addTarget:_filter];
    [_filter addTarget:_filterView];
}

- (void)start_stop
{
    BOOL isSelected = self.startBtn.isSelected;
    [self.startBtn setSelected:!isSelected];
    if (isSelected) {
        [self.filter removeTarget:self.writer];
        self.camera.audioEncodingTarget = nil;
        [self.writer finishRecording];
        UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:@"是否保存到相册" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"保存", nil];
        [alertview show];
        
        //停止计时器
        if (self.timer) {
            [self.timer invalidate];
            self.timer = nil;
        }
        self.count = 0;
        self.timeLabel.text = @"00:00";
        
    }else{
        NSString *fileName = [@"Documents/" stringByAppendingFormat:@"Movie%d.m4v",(int)[[NSDate date] timeIntervalSince1970]];
        pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:fileName];
        
        NSURL *movieURL = [NSURL fileURLWithPath:pathToMovie];
        self.writer = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(480.0, 640.0)];
        [self.filter addTarget:self.writer];
        self.camera.audioEncodingTarget = self.writer;
        [self.writer startRecording];
        //开始计时器
        if (self.timer) {
            [self.timer invalidate];
            self.timer = nil;
        }
        self.count = 0;
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(repeatShowTime:) userInfo:@"admin" repeats:YES];
        
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSLog(@"baocun");
        [self save_to_photosAlbum:pathToMovie];
    }
}
-(void)save_to_photosAlbum:(NSString *)path
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(path)) {
            
            UISaveVideoAtPathToSavedPhotosAlbum(path, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
        }
    });
}

// 视频保存回调
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo: (void *)contextInfo {
    if (error) {
        NSLog(@"保存视频过程中发生错误，错误信息:%@",error.localizedDescription);
    }else{
        NSLog(@"视频保存成功.");
        
    }
    
}

- (void)repeatShowTime:(NSTimer *)tempTimer {
    
    self.count++;
    
    self.timeLabel.text = [NSString stringWithFormat:@"%02d:%02d",self.count/60,self.count%60];
}

- (void)dealloc {   //销毁NSTimer
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

@end
