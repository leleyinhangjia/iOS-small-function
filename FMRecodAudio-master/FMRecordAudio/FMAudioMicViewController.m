//
//  FMAudioMicViewController.m
//  FMRecordAudio
//
//  Created by 范明 on 2019/8/2.
//  Copyright © 2019 范明. All rights reserved.
//

#import "FMAudioMicViewController.h"
#import "AudioTool.h"
#import "MBProgressHUD+MJ.h"
#import "AudioPlayerService.h"

#define  kRecordDuration  600
typedef void(^xiangyingBlock)();
@interface FMAudioMicViewController ()<AudioToolDelegate,PPXAudioPlayerDelegate>
@property (nonatomic, strong) UIButton *micBtn;//话筒按钮
@property (nonatomic, copy) NSString *micStatus;//话筒状态  0是未录状态  1是录音暂停状态  2播放状态  3播放暂停状态  中途再次录制5
@property (nonatomic, strong) UISlider *slider;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, strong) UIButton *cancelBtn;  //  取消按钮
@property (nonatomic, strong) UIButton  *saveBtn;  //  取消按钮
@property (nonatomic, copy) xiangyingBlock xiangyingBlock;
/** 录音工具 */
@property (nonatomic, assign) NSInteger recordTimeIndex;
@property (nonatomic, strong) AudioTool *audioTool2;
@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) NSString *filePath;
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic, copy) NSString *AudioFilePathStr;
@property (nonatomic, strong) NSMutableArray *fileArr;
@property (nonatomic, strong) NSTimer  *timer;//录音timer
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, assign) float toSeekProgress; // seek进度
@property (nonatomic, assign) BOOL isDraging;// 是否正在拖拽进度条
@property (nonatomic, copy) NSString *isfirstClicSaveBtn;

@end

@implementation FMAudioMicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
    self.micStatus = @"0";
    [self cancelBtnAction];
    kPlayer.delegate = self;
    self.isfirstClicSaveBtn = @"0";
}
- (void)viewWillAppear:(BOOL)animated{
    [UIApplication sharedApplication].idleTimerDisabled=YES;//禁止自动休眠
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [kPlayer stop];
    [UIApplication sharedApplication].idleTimerDisabled=NO;
}
- (void)recordAnimationAction
{
    NSString *str = [NSString stringWithFormat:@"%ld",(long)_recordTimeIndex];
    self.timeLabel.text = [NSString stringWithFormat:@"正在录制 %@",[NSString getTwoMMSSFromSS:str]];
    self.slider.value = (float)_recordTimeIndex;
}

- (void)playTime:(float)playTime
{
    self.slider.value = playTime;// 给滑竿赋值
    NSString *str = [NSString stringWithFormat:@"%f",playTime];
    self.timeLabel.text = [NSString stringWithFormat:@"正在播放 %@",[NSString getTwoMMSSFromSS:str]];
}

-(void)sliderValueChanged:(UISlider *)slider
{
    //话筒状态  0是未录状态  1是录音暂停状态  2播放状态  3播放暂停状态 4录制状态 中途再次录制5
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
    //此处需要恢复设置回放标志，否则会导致其它播放声音也会变小self.currentAudioTime = self.audioRecorder.currentTime;
    
    if ([self.micStatus isEqualToString:@"0"]) {
        if (slider.value>=self.recordTimeIndex) {
            [self.slider setValue:self.recordTimeIndex animated:YES];
        }else{
            self.slider.value = slider.value;
            
            kPlayer.playUrlStr = self.AudioFilePathStr;
            self.toSeekProgress =  slider.value/600;
            [kPlayer play];
            self.micStatus = @"2";//播放状态
            self.slider.userInteractionEnabled = NO;
            [self.micBtn setImage:[UIImage imageNamed:@"录音暂停"] forState:0];
        }
    }else if ([self.micStatus isEqualToString:@"1"]) {
        
        
        if (slider.value>=self.recordTimeIndex) {
            [self.slider setValue:self.recordTimeIndex animated:YES];
        }else{
            self.slider.value = slider.value;
            
            DDLog(@"看下进度%.2f,%ld",slider.value,self.recordTimeIndex);
            kPlayer.playUrlStr = self.AudioFilePathStr;
            self.toSeekProgress =  slider.value/self.recordTimeIndex;
            [kPlayer play];
            
            //  [kPlayer playFromProgress:slider.value/self.recordTimeIndex];
            //      [kPlayer setPlayerProgress:self.slider.value/self.recordTimeIndex];
            
            self.micStatus = @"2";//播放状态
            //self.slider.userInteractionEnabled = NO;
            [self.micBtn setImage:[UIImage imageNamed:@"录音暂停"] forState:0];
        }
        
    }else if ([self.micStatus isEqualToString:@"2"]) {//播放状态
        if (slider.value>=self.recordTimeIndex) {
            [self.slider setValue:self.recordTimeIndex animated:YES];
            [kPlayer stop];
            [self.micBtn  setImage:[UIImage  imageNamed:@"luyin1"]  forState:UIControlStateNormal];
            //  weakself.slider.userInteractionEnabled  =  YES;//暂时不让拉回
            self.slider.userInteractionEnabled  =  YES;
            self.micStatus = @"5";
            self.timeLabel.text = @"继续录制";
            self.isPlaying = NO;
            
        }else{
            DDLog(@"播放过程中拖拉滑竿%f--总时长%ld",slider.value,self.recordTimeIndex);
            
            [kPlayer stop];
            
            self.slider.value = slider.value;
            kPlayer.playUrlStr = self.AudioFilePathStr;
            self.toSeekProgress =  slider.value/self.recordTimeIndex;
            [kPlayer play];
            //  [kPlayer playFromProgress:slider.value/self.recordTimeIndex];
            //  [kPlayer setPlayerProgress:self.slider.value/self.recordTimeIndex];
            self.micStatus = @"2";//播放状态
            // self.slider.userInteractionEnabled = NO;
            [self.micBtn setImage:[UIImage imageNamed:@"录音暂停"] forState:0];
        }
    }else if ([self.micStatus isEqualToString:@"3"]) {
        
    }else if ([self.micStatus isEqualToString:@"4"]){
        
    }else if ([self.micStatus isEqualToString:@"5"]){
        if (slider.value>=self.recordTimeIndex) {
            [self.slider setValue:self.recordTimeIndex animated:YES];
        }else{
            self.slider.value = slider.value;
            kPlayer.playUrlStr = self.AudioFilePathStr;
            self.toSeekProgress =  slider.value/self.recordTimeIndex;
            [kPlayer play];
            //  [kPlayer playFromProgress:slider.value/self.recordTimeIndex];
            //  [kPlayer setPlayerProgress:self.slider.value/self.recordTimeIndex];
            self.micStatus = @"2";//播放状态
            // self.slider.userInteractionEnabled = NO;
            [self.micBtn setImage:[UIImage imageNamed:@"录音暂停"] forState:0];
        }
    }
}
/**
 *  timer
 */
- (void)configTimer{
    if (!_timer) {
        _recordTimeIndex = 0;
        _timer = [NSTimer timerWithTimeInterval:1
                                         target:self
                                       selector:@selector(startRecordAction)
                                       userInfo:nil
                                        repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}
- (void)startRecordAction{//开启录音定时器
    
    if (_recordTimeIndex < kRecordDuration) {
        
        _recordTimeIndex += 1;
        [self recordAnimationAction];
        
    }else{
        [self.recorder stop];
        [self.timer  setFireDate:[NSDate  distantFuture]];//定时器暂停
        [WarningTool showToastHintWithText:@"录音时间到"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self saveBtnAction];
        });
        
    }
}
- (void)cancelBtnAction{
    DDLog(@"点击了取消按钮");
    
    _audioTool2 = [AudioTool new];
    _audioTool2.audioToolDelegate = self;
    
    _filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    _filePath = [_filePath stringByAppendingPathComponent:@"audio"];
    self.fileArr = [NSMutableArray array];
    
    NSString *file1 = self.filePath;
    
    DDLog(@"看看%@",self.filePath);
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:file1]) {
        [manager removeItemAtPath:file1 error:nil];
    }else{
        //[MBProgressHUD showError:@"文件已清空"];
    }
    //初始化录音数据
    _recordTimeIndex  =  0;
    [_timer  invalidate];
    _timer  =  nil;
    
    [self.micBtn setImage:[UIImage imageNamed:@"录音话筒"] forState:0];
    self.micStatus = @"0";
    self.slider.userInteractionEnabled = YES;
    [self.slider setValue:0 animated:YES];
    self.timeLabel.text = @"开始录制";
    
    self.recorder = [self.audioTool2 getRecorfer:@"test"];
  
}
//点击了下一步保存
- (void)saveBtnAction{

    self.isfirstClicSaveBtn = @"1";
  
    if (self.recorder.isRecording) {
        [self.recorder stop];
        [self.micBtn setImage:[UIImage imageNamed:@"录音话筒"] forState:0];
        self.micStatus = @"1";
        self.slider.userInteractionEnabled = YES;
        
        [self.timer  setFireDate:[NSDate  distantFuture]];//定时器暂停
        
        WeakSelf(self)
        self.xiangyingBlock = ^{
            DDLog(@"要传过去的音频路径%@",weakself.AudioFilePathStr);
            
        };
        
        
        
    }else{
        
        
        if (self.isPlaying) {
            [kPlayer stop];
        }
        DDLog(@"点击了保存并上传按钮---%@",self.AudioFilePathStr);
     
        if (self.recordTimeIndex == 0) {
            [WarningTool showToastHintWithText:@"请录音"];
            [self cancelBtnAction];
            return;
        }
        
        DDLog(@"要传过去的音频路径%@",self.AudioFilePathStr);
    }
    
    
    
    
}
- (void)micBtnAction{
    DDLog(@"点击了录音话筒按钮看下此时的状态%@",self.micStatus);
    if ([self.micStatus isEqualToString:@"0"]) {//未录制-->录制状态
        self.micStatus = @"4";
        [self.micBtn setImage:[UIImage imageNamed:@"录音暂停"] forState:0];
        self.slider.userInteractionEnabled = NO;
        
        self.recorder = [self.audioTool2 getRecorfer:@"test"];
        [self.recorder record];
        
        [self configTimer];
        
    }else if ([self.micStatus isEqualToString:@"4"]){//录制状态-->暂停
        [self.micBtn setImage:[UIImage imageNamed:@"录音话筒"] forState:0];
        self.micStatus = @"1";
        self.slider.userInteractionEnabled = YES;
        
        if ([self.recorder isRecording]) {
            
            [self.recorder stop];
            
        }
        
        [self.timer  setFireDate:[NSDate  distantFuture]];//定时器暂停
        
    }else if ([self.micStatus isEqualToString:@"1"]){//暂停状态-->录制
        [self.micBtn setImage:[UIImage imageNamed:@"录音暂停"] forState:0];
        self.micStatus = @"4";
        self.slider.userInteractionEnabled = NO;
        
        self.recorder = [self.audioTool2 getRecorfer:@"test"];
        
        
        [self.recorder record];
        
        [self.timer  setFireDate:[NSDate  distantPast]];//定时器重新计时
        
        
    }else if ([self.micStatus isEqualToString:@"2"]){//播放状态-->暂停状态
        self.micStatus = @"3";
        [self.micBtn setImage:[UIImage imageNamed:@"录音播放"] forState:0];
        self.slider.userInteractionEnabled = NO;
        
        [kPlayer pause];
        
    }else if ([self.micStatus isEqualToString:@"3"]){//播放暂停状态--->播放状态
        self.micStatus = @"2";
        [self.micBtn setImage:[UIImage imageNamed:@"录音暂停"] forState:0];
        self.slider.userInteractionEnabled = NO;
        kPlayer.playUrlStr = self.AudioFilePathStr;
        [kPlayer resume];
        
    }else if ([self.micStatus isEqualToString:@"5"]){
        
        DDLog(@"点击继续录制---->录制状态");
        
        self.micStatus = @"4";
        [self.micBtn setImage:[UIImage imageNamed:@"录音暂停"] forState:0];
        self.slider.userInteractionEnabled = NO;
        
        self.recorder = [self.audioTool2 getRecorfer:@"test"];
        
        [self.recorder prepareToRecord];
        [self.recorder record];
        [self.timer  setFireDate:[NSDate  distantPast]];//继续定时器
    }
    
    
}
-(NSString *)filePath{
    if (!_filePath) {
        
    }
    
    return _filePath;
}

-(AudioTool *)audioTool2{
    if (!_audioTool2) {
        _audioTool2 = [AudioTool new];
        _audioTool2.audioToolDelegate = self;
    }
    
    return _audioTool2;
}
#pragma mark 转换的回调
-(void)statrPCMtoMP3{
    [MBProgressHUD showMessage:@"正在转换...."];
}

-(void)endPCMtoMP3:(NSString *)fileName{
    
    DDLog(@"现在存在的录音文件%@成功了",fileName);
    
    self.AudioFilePathStr = fileName;
    
    [MBProgressHUD hideHUD];
    [self.fileArr addObject:fileName];
    
    DDLog(@"在录制数组%@",self.fileArr);
    
    if (self.fileArr.count>1) {
        [self.audioTool2 synthesisWithSouceFilePath:self.fileArr[0] desFilePath:self.fileArr[1] ];
    }else{//第一次进来录音中直接点击保存按钮
        
        if ([self.isfirstClicSaveBtn isEqualToString:@"1"]) {
           
            DDLog(@"穿过去的路径%@",self.AudioFilePathStr);
           
        }
        
    }
}
-(void)startSynthesis{
    [MBProgressHUD showMessage:@"正在合成...."];
}

-(void)endSynthesis:(NSString *)fileName{
    
    [self.fileArr removeAllObjects];
    [self.fileArr addObject:fileName];
    self.AudioFilePathStr = fileName;
    [MBProgressHUD hideHUD];
    if (self.xiangyingBlock) {
        self.xiangyingBlock();
    }
}


- (void)creatUI{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"录音";
    UIImageView *backIMV = [[UIImageView alloc]initWithFrame:CGRectMake(26, SafeAreaTopHeight+100, KScreenWidth-52, 118)];
    backIMV.image = [UIImage imageNamed:@"录音背景"];
    [self.view addSubview:backIMV];
    
    self.micBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.micBtn setImage:[UIImage imageNamed:@"录音话筒"] forState:0];
    self.micBtn.frame = CGRectMake((KScreenWidth-153)/2, SafeAreaTopHeight+94, 153, 153);
    [self.view addSubview:_micBtn];
    [self.micBtn addTarget:self action:@selector(micBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.slider = [[UISlider alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_micBtn.frame)+ 30, SCREEN_WIDTH -40, 20)];
    self.slider.continuous = YES;
    self.slider.minimumValue = 0;// 设置最小值
    self.slider.maximumValue = 600;// 设置最大值
    self.slider.value = 0;
    self.slider.userInteractionEnabled = NO;
    [self.slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.slider.continuous = NO;//UISlider 对象会在手指离开时，触发一次 valueChange 事件。
    
    [self.view addSubview:self.slider];
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_slider.frame)+ 20, SCREEN_HEIGHT / 2 - 50, 14)];
    self.timeLabel.textColor = UIColorFromRGB(0x666666);
    self.timeLabel.font = FH(14);
    self.timeLabel.text = @"开始录制";
    [self.view addSubview:self.timeLabel];
    
    self.promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - 140, CGRectGetMaxY(_slider.frame)+ 20, 120, 12)];
    self.promptLabel.textColor = UIColorFromRGB(0x666666);
    self.promptLabel.font = FH(12);
    self.promptLabel.textAlignment = NSTextAlignmentRight;
    self.promptLabel.text = @"最多录制10分钟";
    [self.view addSubview:self.promptLabel];
    
    self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancelBtn setBackgroundImage:[UIImage imageNamed:@"圆角矩形_1_拷贝_2 copy"] forState:UIControlStateNormal];
    [self.cancelBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    self.cancelBtn.frame = CGRectMake((KScreenWidth/2 - 160) /2, SCREEN_HEIGHT - 45 -30, 160, 45);
    [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    self.cancelBtn.titleLabel.font = FH(16);
    [self.cancelBtn addTarget:self action:@selector(cancelBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cancelBtn];
    
    
    self.saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.saveBtn setBackgroundImage:[UIImage imageNamed:@"圆角矩形_1_拷贝_2-3"] forState:UIControlStateNormal];
    [self.saveBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    self.saveBtn.frame = CGRectMake(KScreenWidth/2 + (KScreenWidth/2 - 160) /2, SCREEN_HEIGHT - 45 -30, 160, 45);
    [self.saveBtn setTitle:@"保存并上传" forState:UIControlStateNormal];
    self.saveBtn.titleLabel.font = FH(16);
    [self.saveBtn addTarget:self action:@selector(saveBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.saveBtn];
}
- (NSMutableArray *)fileArr{
    if (!_fileArr) {
        _fileArr = [NSMutableArray array];
    }
    return _fileArr;
}
- (void)dealloc{
    DDLog(@"销毁了");
    [_timer invalidate];
    _timer=nil;
}


// 播放时间（单位：毫秒)、总时间（单位：毫秒）、进度（播放时间 / 总时间）
- (void)ppxPlayer:(AudioPlayerService *)player currentTime:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime progress:(float)progress{
    DDLog(@"播放中%f秒",currentTime/1000);
    // self.slider.value = currentTime;
    [self playTime:currentTime/1000];
    
}

#pragma mark - 代理
#pragma mark - GKPlayerDelegate
// 播放状态改变
- (void)ppxPlayer:(AudioPlayerService *)player statusChanged:(PPXAudioPlayerState)status
{
    switch (status) {
        case PPXAudioPlayerStateLoading:{    // 加载中
            self.isPlaying = NO;
        }
            break;
        case PPXAudioPlayerStateBuffering: { // 缓冲中
            self.isPlaying = YES;
        }
            break;
        case PPXAudioPlayerStatePlaying: {   // 播放中
            if (self.toSeekProgress > 0) {
                [kPlayer setPlayerProgress:self.toSeekProgress];
                self.toSeekProgress = 0;
            }
            
            self.isPlaying = YES;
        }
            break;
        case PPXAudioPlayerStatePaused:{     // 暂停
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
            self.isPlaying = NO;
        }
            break;
        case PPXAudioPlayerStateStoppedBy:{  // 主动停止
            //            dispatch_async(dispatch_get_main_queue(), ^{
            //                [self pauseMusic];
            //            });
            self.isPlaying = NO;
            
        }
            break;
        case PPXAudioPlayerStateStopped:{    // 打断停止
            dispatch_async(dispatch_get_main_queue(), ^{
                //                [self pauseMusic];
            });
            self.isPlaying = NO;
        }
            break;
        case PPXAudioPlayerStateEnded: {     // 播放结束
            DDLog(@"播放结束了");
            [kPlayer stop];
            
            [self.micBtn  setImage:[UIImage  imageNamed:@"luyin1"]  forState:UIControlStateNormal];
            //  weakself.slider.userInteractionEnabled  =  YES;//暂时不让拉回
            self.slider.userInteractionEnabled  =  YES;
            self.micStatus = @"5";
            self.timeLabel.text = @"继续录制";
            self.isPlaying = NO;
            
        }
            break;
        case PPXAudioPlayerStateError: {     // 播放出错
            NSLog(@"播放出错了");
            dispatch_async(dispatch_get_main_queue(), ^{
                //                [self pauseMusic];
            });
            self.isPlaying = NO;
        }
            break;
        default:
            break;
    }
}


@end
