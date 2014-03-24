//
//  ViewController.h
//  cameraForBingyanV1-0
//
//  Created by 朱 俊健 on 13-10-14.
//  Copyright (c) 2013年 朱 俊健. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPUImage.h"
#import "AppDelegate.h"

#define FRAME_RECODEBUTTON CGRectMake(105, 404, 100, 40)
#define FRAME_IMAGEVIEW CGRectMake(0, 0, 320, 460)
#define FRAME_LABEL CGRectMake(0, 0, 200, 50)
#define FRAME_TABLEVIEW CGRectMake(108, 335, 105, 320)

#define STRING_STARTRECORDING @"开始录制"
#define STRING_STOPRECORDING @"停止录制"
#define STRING_SAVERECORDING @"保存录像"

#define STRING_PATHTOMOVIE @"Documents/Movie1.m4v"

#define LABEL_RECORDING @"正在录制..."

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    GPUImageMovieWriter * movieWriter;
    GPUImageVideoCamera * videoCamera;
    GPUImageOutput<GPUImageInput> * testFilter;
    GPUImageView * imageView;
    
    NSMutableDictionary * videoSettings;
    NSDictionary * audioSettings;

    
    NSString * pathToMovie;
    
    UIButton * recodeButton;
    UILabel * stateLabel;
    
    int timesHaveRecorded;
}

-(IBAction)onPressRecodeButton:(id)sender;

-(void)initializeRecoderWith:(NSString *)thePath;

//tableView
@property (nonatomic, retain) NSArray *dataList;
@property (nonatomic, retain) UITableView *myTableView;

@end
