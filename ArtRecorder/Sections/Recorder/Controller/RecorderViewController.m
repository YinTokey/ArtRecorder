//
//  RecorderViewController.m
//  ArtRecorder
//
//  Created by Decade on 2017/2/19.
//  Copyright © 2017年 YinjianChen. All rights reserved.
//

#import "RecorderViewController.h"
#import "FilterChooseView.h"

#import "EHSocialShareViewModel.h"
@interface RecorderViewController ()<GPUImageVideoCameraDelegate>

@property (nonatomic,retain) GPUImageVideoCamera *camera;
@property (nonatomic,strong) GPUImageView * filterView;
@property (nonatomic,retain) GPUImageMovieWriter *writer;
@property (nonatomic,retain) GPUImageFilter *filter;
@property (nonatomic,retain) FilterChooseView * chooseView;
@property (nonatomic,retain) GPUImageAlphaBlendFilter *blendFilter;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic, assign) int count;

@property (nonatomic, strong) GPUImageUIElement *element;
@property (nonatomic, strong) UIView *elementView;
@property (nonatomic, strong) UIImageView *capImageView;
@property (nonatomic, assign) CGRect faceBounds;
@property (nonatomic, strong) CIDetector *faceDetector;
@property (nonatomic, assign) BOOL faceThinking;

//风景滤镜模式
@property (nonatomic,assign) BOOL filterMode;

@property (nonatomic,strong)UIAlertView *shareAlertView;
// Switching between front and back cameras
@end

@implementation RecorderViewController
{
    NSString *pathToMovie;
    NSMutableArray *titleArray;
    NSMutableArray *picArray;
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.hidden = YES;
    
    self.camera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1280x720 cameraPosition:AVCaptureDevicePositionBack];
    self.camera.outputImageOrientation = UIInterfaceOrientationPortrait;
    self.camera.horizontallyMirrorFrontFacingCamera = NO;
    self.camera.horizontallyMirrorRearFacingCamera = NO;
    self.camera.delegate = self;
//    if (self.filter) {
//        [self.camera addTarget:_filter];
//        [_filter addTarget:_filterView];
//    }else{
//        [self.camera addTarget:_filterView];
//    }
    _filter = [[GPUImageFilter alloc] init];
    [self.camera addTarget:_filter];
    
    self.element = [[GPUImageUIElement alloc] initWithView:self.elementView];
    
    _blendFilter = [[GPUImageAlphaBlendFilter alloc] init];
    _blendFilter.mix = 1.0;
    [_filter addTarget:_blendFilter];
    [self.element addTarget:_blendFilter];
    
    self.filterView = [[GPUImageView alloc] initWithFrame:self.view.frame];
    self.filterView.center = self.view.center;
    [self.view insertSubview:_filterView atIndex:0];
    [_blendFilter addTarget:self.filterView];
    
    __weak typeof (self) weakSelf = self;
    [_filter setFrameProcessingCompletionBlock:^(GPUImageOutput *output, CMTime time) {
        __strong typeof (self) strongSelf = weakSelf;
        // update capImageView's frame
        CGRect rect = strongSelf.faceBounds;
        CGSize size = strongSelf.capImageView.frame.size;
        strongSelf.capImageView.frame = CGRectMake(rect.origin.x +  (rect.size.width - size.width)/2, rect.origin.y - size.height, size.width, size.height);
        [strongSelf.element update];
    }];
    
    
    [self.camera startCameraCapture];
    
    
    [self setupBtns];
    
    [self setupChooseView];
    
    _filterMode = NO;
    
    _shareAlertView = [[UIAlertView alloc] initWithTitle:@"是否分享" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"分享", nil];
    _shareAlertView.tag = 1;

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
        
        [_camera rotateCamera];
    }];

}


- (void)setupChooseView{
    _chooseView = [[FilterChooseView alloc] initWithFrame:CGRectMake(0, 80, self.view.frame.size.width, 95)];
    @weakify(self);
    _chooseView.backback = ^(GPUImageFilter * filter){
        @strongify(self);
        _filter = (GPUImageFilter *)filter;
        [self choose_callBack:self.filter];
    };
    [self.view addSubview:_chooseView];
    _chooseView.hidden = YES;

}

#pragma mark 选择滤镜
-(void)choose_callBack:(GPUImageFilter *)filter
{
    BOOL isSelected = self.startBtn.isSelected;
    if (isSelected) {
        return;
    }
    self.filter = filter;
    [self.camera removeAllTargets];
    [self.camera addTarget:_filter];
    [_filter addTarget:_filterView];
    
    _filterMode = YES;
}

- (void)start_stop
{
    BOOL isSelected = self.startBtn.isSelected;
    [self.startBtn setSelected:!isSelected];
    if (isSelected) {
        if(_filterMode == NO){
            [self.blendFilter removeTarget:self.writer];
        }else{
            // 风景滤镜模式，用filter写
            [self.filter removeTarget:self.writer];
        }
        
        self.camera.audioEncodingTarget = nil;
        [self.writer finishRecording];
        UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:@"是否保存到相册" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"保存", nil];
        [alertview show];
        alertview.tag = 0;
        
        
        
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
        
        if(_filterMode == NO){
            [self.blendFilter addTarget:self.writer];
        }else{
            // 风景滤镜模式，用filter写
            [self.filter addTarget:self.writer];
        }
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
    
    if(alertView.tag == 0){
        if (buttonIndex == 1) {
            NSLog(@"baocun");
            [self save_to_photosAlbum:pathToMovie];
        }
        [_shareAlertView show];
    }
    if(alertView.tag == 1){
    
        if(buttonIndex == 1){
            NSString *prefix = @"photos";
            NSString *urlStr = [NSString stringWithFormat:@"%@-redirect:",prefix];
            NSURL *url = [NSURL URLWithString:urlStr];
            
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }
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


- (void)willOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer {
    if (!_faceThinking) {
        CFAllocatorRef allocator = CFAllocatorGetDefault();
        CMSampleBufferRef sbufCopyOut;
        CMSampleBufferCreateCopy(allocator,sampleBuffer,&sbufCopyOut);
        [self performSelectorInBackground:@selector(grepFacesForSampleBuffer:) withObject:CFBridgingRelease(sbufCopyOut)];
    }
}

- (void)grepFacesForSampleBuffer:(CMSampleBufferRef)sampleBuffer{
    _faceThinking = YES;
    CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CFDictionaryRef attachments = CMCopyDictionaryOfAttachments(kCFAllocatorDefault, sampleBuffer, kCMAttachmentMode_ShouldPropagate);
    CIImage *convertedImage = [[CIImage alloc] initWithCVPixelBuffer:pixelBuffer options:(__bridge NSDictionary *)attachments];
    
    if (attachments)
        CFRelease(attachments);
    NSDictionary *imageOptions = nil;
    UIDeviceOrientation curDeviceOrientation = [[UIDevice currentDevice] orientation];
    int exifOrientation;
    
    /* kCGImagePropertyOrientation values
     The intended display orientation of the image. If present, this key is a CFNumber value with the same value as defined
     by the TIFF and EXIF specifications -- see enumeration of integer constants.
     The value specified where the origin (0,0) of the image is located. If not present, a value of 1 is assumed.
     
     used when calling featuresInImage: options: The value for this key is an integer NSNumber from 1..8 as found in kCGImagePropertyOrientation.
     If present, the detection will be done based on that orientation but the coordinates in the returned features will still be based on those of the image. */
    
    enum {
        PHOTOS_EXIF_0ROW_TOP_0COL_LEFT			= 1, //   1  =  0th row is at the top, and 0th column is on the left (THE DEFAULT).
        PHOTOS_EXIF_0ROW_TOP_0COL_RIGHT			= 2, //   2  =  0th row is at the top, and 0th column is on the right.
        PHOTOS_EXIF_0ROW_BOTTOM_0COL_RIGHT      = 3, //   3  =  0th row is at the bottom, and 0th column is on the right.
        PHOTOS_EXIF_0ROW_BOTTOM_0COL_LEFT       = 4, //   4  =  0th row is at the bottom, and 0th column is on the left.
        PHOTOS_EXIF_0ROW_LEFT_0COL_TOP          = 5, //   5  =  0th row is on the left, and 0th column is the top.
        PHOTOS_EXIF_0ROW_RIGHT_0COL_TOP         = 6, //   6  =  0th row is on the right, and 0th column is the top.
        PHOTOS_EXIF_0ROW_RIGHT_0COL_BOTTOM      = 7, //   7  =  0th row is on the right, and 0th column is the bottom.
        PHOTOS_EXIF_0ROW_LEFT_0COL_BOTTOM       = 8  //   8  =  0th row is on the left, and 0th column is the bottom.
    };
    BOOL isUsingFrontFacingCamera = FALSE;
    AVCaptureDevicePosition currentCameraPosition = [self.camera cameraPosition];
    
    if (currentCameraPosition != AVCaptureDevicePositionBack)
    {
        isUsingFrontFacingCamera = TRUE;
    }
    
    switch (curDeviceOrientation) {
        case UIDeviceOrientationPortraitUpsideDown:  // Device oriented vertically, home button on the top
            exifOrientation = PHOTOS_EXIF_0ROW_LEFT_0COL_BOTTOM;
            break;
        case UIDeviceOrientationLandscapeLeft:       // Device oriented horizontally, home button on the right
            if (isUsingFrontFacingCamera)
                exifOrientation = PHOTOS_EXIF_0ROW_BOTTOM_0COL_RIGHT;
            else
                exifOrientation = PHOTOS_EXIF_0ROW_TOP_0COL_LEFT;
            break;
        case UIDeviceOrientationLandscapeRight:      // Device oriented horizontally, home button on the left
            if (isUsingFrontFacingCamera)
                exifOrientation = PHOTOS_EXIF_0ROW_TOP_0COL_LEFT;
            else
                exifOrientation = PHOTOS_EXIF_0ROW_BOTTOM_0COL_RIGHT;
            break;
        case UIDeviceOrientationPortrait:            // Device oriented vertically, home button on the bottom
        default:
            exifOrientation = PHOTOS_EXIF_0ROW_RIGHT_0COL_TOP;
            break;
    }
    
    imageOptions = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:exifOrientation] forKey:CIDetectorImageOrientation];
    NSArray *features = [self.faceDetector featuresInImage:convertedImage options:imageOptions];
    
    // get the clean aperture
    // the clean aperture is a rectangle that defines the portion of the encoded pixel dimensions
    // that represents image data valid for display.
    CMFormatDescriptionRef fdesc = CMSampleBufferGetFormatDescription(sampleBuffer);
    CGRect clap = CMVideoFormatDescriptionGetCleanAperture(fdesc, false /*originIsTopLeft == false*/);
    
    
    [self GPUVCWillOutputFeatures:features forClap:clap andOrientation:curDeviceOrientation];
    _faceThinking = NO;
    
}

- (void)GPUVCWillOutputFeatures:(NSArray*)featureArray forClap:(CGRect)clap
                 andOrientation:(UIDeviceOrientation)curDeviceOrientation
{
    dispatch_async(dispatch_get_main_queue(), ^{
        CGRect previewBox = self.view.frame;
        if (featureArray.count) {
            self.capImageView.hidden = NO;
        }
        else {
            self.capImageView.hidden = YES;
            //            [self.faceView removeFromSuperview];
            //            self.faceView = nil;
        }
        for ( CIFaceFeature *faceFeature in featureArray) {
            
            // find the correct position for the square layer within the previewLayer
            // the feature box originates in the bottom left of the video frame.
            // (Bottom right if mirroring is turned on)
            //Update face bounds for iOS Coordinate System
            CGRect faceRect = [faceFeature bounds];
            
            // flip preview width and height
            CGFloat temp = faceRect.size.width;
            faceRect.size.width = faceRect.size.height;
            faceRect.size.height = temp;
            temp = faceRect.origin.x;
            faceRect.origin.x = faceRect.origin.y;
            faceRect.origin.y = temp;
            // scale coordinates so they fit in the preview box, which may be scaled
            CGFloat widthScaleBy = previewBox.size.width / clap.size.height;
            CGFloat heightScaleBy = previewBox.size.height / clap.size.width;
            faceRect.size.width *= widthScaleBy;
            faceRect.size.height *= heightScaleBy;
            faceRect.origin.x *= widthScaleBy;
            faceRect.origin.y *= heightScaleBy;
            
            faceRect = CGRectOffset(faceRect, previewBox.origin.x, previewBox.origin.y);
            
            //mirror
            CGRect rect = CGRectMake(previewBox.size.width - faceRect.origin.x - faceRect.size.width, faceRect.origin.y, faceRect.size.width, faceRect.size.height);
            if (fabs(rect.origin.x - self.faceBounds.origin.x) > 5.0) {
                self.faceBounds = rect;
                //                if (self.faceView) {
                //                    [self.faceView removeFromSuperview];
                //                    self.faceView =  nil;
                //                }
                //
                //                // create a UIView using the bounds of the face
                //                self.faceView = [[UIView alloc] initWithFrame:self.faceBounds];
                //
                //                // add a border around the newly created UIView
                //                self.faceView.layer.borderWidth = 1;
                //                self.faceView.layer.borderColor = [[UIColor redColor] CGColor];
                //
                //                // add the new view to create a box around the face
                //                [self.view addSubview:self.faceView];
            }
        }
    });
    
}

#pragma mark -
#pragma mark Getter

- (CIDetector *)faceDetector {
    if (!_faceDetector) {
        NSDictionary *detectorOptions = [[NSDictionary alloc] initWithObjectsAndKeys:CIDetectorAccuracyLow, CIDetectorAccuracy, nil];
        _faceDetector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:detectorOptions];
    }
    return _faceDetector;
}

- (UIView *)elementView {
    if (!_elementView) {
        _elementView = [[UIView alloc] initWithFrame:self.view.frame];
        _capImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 160)];
        [_capImageView setImage:[UIImage imageNamed:@"fire.png"]];
        [_elementView addSubview:_capImageView];
    }
    return _elementView;
}


@end
