//
//  ViewController.m
//  cameraForBingyanV1-0
//
//  Created by 朱 俊健 on 13-10-14.
//  Copyright (c) 2013年 朱 俊健. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //init times
    timesHaveRecorded = 0;
    
    //init Label
    stateLabel = [[UILabel alloc] initWithFrame:FRAME_LABEL];
    stateLabel.text = LABEL_RECORDING;
    stateLabel.textColor = [UIColor redColor];
    stateLabel.backgroundColor = [UIColor clearColor];
    
    //init ImageView
    imageView = [[GPUImageView alloc]init];
    imageView.frame = FRAME_IMAGEVIEW;
    [self.view addSubview:imageView];
    
    //init Button
    recodeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    recodeButton.frame = FRAME_RECODEBUTTON;
    [recodeButton setTitle:STRING_STARTRECORDING forState:UIControlStateNormal];
    [recodeButton addTarget:self action:@selector(onPressRecodeButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:recodeButton];
    
    
    
    
    //init Video Setting
    videoSettings = [[NSMutableDictionary alloc] init];;
    [videoSettings setObject:AVVideoCodecH264 forKey:AVVideoCodecKey];
    [videoSettings setObject:[NSNumber numberWithInteger:200] forKey:AVVideoWidthKey];
    [videoSettings setObject:[NSNumber numberWithInteger:200] forKey:AVVideoHeightKey];
    
    //init audio setting
    AudioChannelLayout channelLayout;
    memset(&channelLayout, 0, sizeof(AudioChannelLayout));
    channelLayout.mChannelLayoutTag = kAudioChannelLayoutTag_Stereo;
    
    audioSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [ NSNumber numberWithInt: kAudioFormatMPEG4AAC], AVFormatIDKey,
                                   [ NSNumber numberWithInt: 2 ], AVNumberOfChannelsKey,
                                   [ NSNumber numberWithFloat: 16000.0 ], AVSampleRateKey,
                                   [ NSData dataWithBytes:&channelLayout length: sizeof( AudioChannelLayout ) ], AVChannelLayoutKey,
                                   [ NSNumber numberWithInt: 32000 ], AVEncoderBitRateKey,
                                   nil];
    //init VideoCamera
    videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionBack];
    videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;

    [videoCamera startCameraCapture];

    //init url
    [self initializeRecoderWith:STRING_PATHTOMOVIE];
//    //init Movie path
//    pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:STRING_PATHTOMOVIE];
//    unlink([pathToMovie UTF8String]); // If a file already exists, AVAssetWriter won't let you record new frames, so delete the old movie
//    NSURL *movieURL = [NSURL fileURLWithPath:pathToMovie];
//    
//    //init movieWriter
//    movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(480.0, 640.0) fileType:AVFileTypeMPEG4 outputSettings:videoSettings];
//    
//    [movieWriter setHasAudioTrack:YES audioSettings:audioSettings];
//    
//    
//    //init VideoCamera
//    videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionBack];
//    videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
//    
//    //init Filter
//    testFilter = [[GPUImageSketchFilter alloc] init];
//    
//    [videoCamera addTarget:testFilter];
//    [testFilter addTarget:imageView];
//    [testFilter addTarget:movieWriter];
//    [videoCamera startCameraCapture];
//    
    
    
    
    //init tableView
    NSArray *list = [NSArray arrayWithObjects:@"模糊",@"素描",@"怀旧", nil];
    self.dataList = list;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:FRAME_TABLEVIEW style:UITableViewStylePlain];
    // 设置tableView的数据源
    tableView.dataSource = self;
    // 设置tableView的委托
    tableView.delegate = self;
     tableView.transform = CGAffineTransformMakeRotation(-M_PI / 2);
    tableView.showsVerticalScrollIndicator = NO;
    // 设置tableView的背景图
//    tableView.backgroundView = [[UIImageView alloc] init];
    self.myTableView = tableView;
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.myTableView];
    
}

- (void)initializeRecoderWith:(NSString *)thePath
{
    //init Movie path
    pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:thePath];
    unlink([pathToMovie UTF8String]); // If a file already exists, AVAssetWriter won't let you record new frames, so delete the old movie
    NSURL *movieURL = [NSURL fileURLWithPath:pathToMovie];
    
    //init movieWriter
    movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(480.0, 640.0) fileType:AVFileTypeMPEG4 outputSettings:videoSettings];
    
    [movieWriter setHasAudioTrack:YES audioSettings:audioSettings];
    
    

    
    //init Filter
    testFilter = [[GPUImageSketchFilter alloc] init];
    
    [videoCamera addTarget:testFilter];
    [testFilter addTarget:imageView];
    [testFilter addTarget:movieWriter];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - vidoe camera
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    // Map UIDeviceOrientation to UIInterfaceOrientation.
    UIInterfaceOrientation orient = UIInterfaceOrientationPortrait;
    switch ([[UIDevice currentDevice] orientation])
    {
        case UIDeviceOrientationLandscapeLeft:
            orient = UIInterfaceOrientationLandscapeLeft;
            break;
            
        case UIDeviceOrientationLandscapeRight:
            orient = UIInterfaceOrientationLandscapeRight;
            break;
            
        case UIDeviceOrientationPortrait:
            orient = UIInterfaceOrientationPortrait;
            break;
            
        case UIDeviceOrientationPortraitUpsideDown:
            orient = UIInterfaceOrientationPortraitUpsideDown;
            break;
            
        case UIDeviceOrientationFaceUp:
        case UIDeviceOrientationFaceDown:
        case UIDeviceOrientationUnknown:
            // When in doubt, stay the same.
            orient = fromInterfaceOrientation;
            break;
    }
    videoCamera.outputImageOrientation = orient;
    
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES; // Support all orientations.
}


#pragma mark - responder

- (IBAction)onPressRecodeButton:(id)sender
{

    
    NSString * title = [recodeButton titleForState:normal];
    
    if ([title isEqualToString:STRING_STARTRECORDING]) {
        NSString * tempPath = [NSString stringWithFormat:@"Documents/Movie%d.m4v",timesHaveRecorded];

        //reset url and movieWriter
        [testFilter removeAllTargets];
        [videoCamera removeAllTargets];
        [self initializeRecoderWith:tempPath];
        
        // ui sets
        [recodeButton setTitle:STRING_SAVERECORDING forState:UIControlStateNormal];
        [self.view addSubview:stateLabel];
        [stateLabel setAlpha:1.0];

        //start recording
        NSLog(@"start recording");
        videoCamera.audioEncodingTarget = movieWriter;
        [movieWriter startRecording];

        //error
        NSError * error = nil;
        if (![videoCamera.inputCamera lockForConfiguration:&error])
        {
            NSLog(@"Error locking for configuration: %@", error);
        };
        
        //flashLight
//        [videoCamera.inputCamera setTorchMode:AVCaptureTorchModeOn];
//        [videoCamera.inputCamera unlockForConfiguration];
        
    }
    else if ([title isEqualToString:STRING_SAVERECORDING]){
        //ui sets
        [recodeButton setTitle:STRING_STARTRECORDING forState:UIControlStateNormal];
        [stateLabel removeFromSuperview];

        //stop recording
        [testFilter removeTarget:movieWriter];
        videoCamera.audioEncodingTarget = nil;
        [movieWriter finishRecording];
        NSLog(@"Movie completed");
        
        //error
        [videoCamera.inputCamera lockForConfiguration:nil];
//        [videoCamera.inputCamera setTorchMode:AVCaptureTorchModeOff];
//        [videoCamera.inputCamera unlockForConfiguration];

        UISaveVideoAtPathToSavedPhotosAlbum(pathToMovie, nil, nil, nil);
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示~" message:@"保存成功" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];

    }
//    else{
//        UISaveVideoAtPathToSavedPhotosAlbum(pathToMovie, nil, nil, nil);
//        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示~" message:@"保存成功" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//        [alert show];
//    }
}




#pragma mark - Table View

//set cells
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellWithIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellWithIdentifier];
    }
    cell.imageView.image = [UIImage imageNamed:@"example.png"];
    return cell;
}

//set number of sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//行首缩进
- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0;
}

//row height
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 105;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if ([indexPath row] % 2 == 0) {
//        cell.backgroundColor = [UIColor blueColor];
//    } else {
//        cell.backgroundColor = [UIColor greenColor];
//    }
}


//select rows callback
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [videoCamera removeAllTargets];
    [testFilter removeAllTargets];

    
    switch ([indexPath row]) {
        case 0:
            testFilter = [[GPUImageFastBlurFilter alloc] init];
            break;
        case 1:
            testFilter = [[GPUImageSketchFilter alloc] init];
            break;
        case 2:
            testFilter = [[GPUImageSepiaFilter alloc] init];
            break;
        default:
            break;
    }
    

    [videoCamera addTarget:testFilter];
    [testFilter addTarget:imageView];
    [testFilter addTarget:movieWriter];

}


// delete
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"执行删除操作");
}

//设置没有分界线
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}


//number of rows
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}
@end
