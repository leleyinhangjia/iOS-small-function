//
//  AudioPlayerService.m
//  ZHEJIANG
//
//  Created by pipixia on 2018/11/19.
//  Copyright © 2018年 pipixia. All rights reserved.
//

#import "AudioPlayerService.h"
#import "PPXTimer.h"

@interface AudioPlayerService()

@property (nonatomic, strong) FSAudioStream *audioStream;

@property (nonatomic, strong) NSTimer       *playTimer;
@property (nonatomic, strong) NSTimer       *bufferTimer;

@end

@implementation AudioPlayerService

+ (instancetype)sharedInstance {
    static AudioPlayerService *player = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        player = [AudioPlayerService new];
    });
    return player;
}

- (instancetype)init {
    if (self = [super init]) {
        self.playerState = PPXAudioPlayerStateStopped;
    }
    return self;
}

- (void)setPlayUrlStr:(NSString *)playUrlStr {
    if (![_playUrlStr isEqualToString:playUrlStr]) {
        
        // 切换数据，清除缓存
        [self removeCache];
        
        _playUrlStr = playUrlStr;
        
        if ([playUrlStr hasPrefix:@"http"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.audioStream.url = [NSURL URLWithString:playUrlStr];
            });
        }else {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.audioStream.url = [NSURL fileURLWithPath:playUrlStr];
            });
        }
    }
}

- (void)setPlayerProgress:(float)progress {
    if (progress == 0) progress = 0.001;
    if (progress == 1) progress = 0.999;
    
    FSStreamPosition position = {0};
    position.position = progress;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.audioStream seekToPosition:position];
    });
}

- (void)setPlayerPlayRate:(float)playRate {
    if (playRate < 0.5) playRate = 0.5f;
    if (playRate > 2.0) playRate = 2.0f;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.audioStream setPlayRate:playRate];
    });
}

- (void)play {
    if (self.playerState == PPXAudioPlayerStatePlaying) return;
    
    NSAssert(self.playUrlStr, @"url不能为空");
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.audioStream play];
    });
    
    [self startTimer];
    
    // 如果缓冲未完成
    if (self.bufferState != PPXAudioBufferStateFinished) {
        self.bufferState = PPXAudioBufferStateNone;
        [self startBufferTimer];
    }
}

- (void)playFromProgress:(float)progress {
    FSSeekByteOffset offset = {0};
    offset.position = progress;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.audioStream playFromOffset:offset];
    });
    
    [self startTimer];
    
    // 如果缓冲未完成
    if (self.bufferState != PPXAudioBufferStateFinished) {
        self.bufferState = PPXAudioBufferStateNone;
        [self startBufferTimer];
    }
}

- (void)pause {
    if (self.playerState == PPXAudioPlayerStatePaused) return;
    
    self.playerState = PPXAudioPlayerStatePaused;
    [self setupPlayerState:self.playerState];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.audioStream pause];
    });
    
    [self stopTimer];
}

- (void)resume {
    if (self.playerState == PPXAudioPlayerStatePlaying) return;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // 这里恢复播放不能用play，需要用pause
        [self.audioStream pause];
    });
    
    [self startTimer];
}

- (void)stop {
    if (self.playerState == PPXAudioPlayerStateStoppedBy) return;
    
    self.playerState = PPXAudioPlayerStateStoppedBy;
    [self setupPlayerState:self.playerState];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.audioStream stop];
    });
    
    [self stopTimer];
}

- (void)setVolume:(float)volume {
    
    self.audioStream.volume = volume;
}

- (void)startTimer {
    if (self.playTimer) return;
    self.playTimer = [PPXTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
}

- (void)stopTimer {
    if (self.playTimer) {
        [self.playTimer invalidate];
        self.playTimer = nil;
    }
}

- (void)startBufferTimer {
    if (self.bufferTimer) return;
    self.bufferTimer = [PPXTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(bufferTimerAction:) userInfo:nil repeats:YES];
}

- (void)stopBufferTimer {
    if (self.bufferTimer) {
        [self.bufferTimer invalidate];
        self.bufferTimer = nil;
    }
}

- (void)timerAction:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        FSStreamPosition cur = self.audioStream.currentTimePlayed;
        
        NSTimeInterval currentTime = cur.playbackTimeInSeconds * 1000;
        
        NSTimeInterval totalTime = self.audioStream.duration.playbackTimeInSeconds * 1000;
        
        NSTimeInterval progress = cur.position;
        
        if ([self.delegate respondsToSelector:@selector(ppxPlayer:currentTime:totalTime:progress:)]) {
            [self.delegate ppxPlayer:self currentTime:currentTime totalTime:totalTime progress:progress];
        }
        
        if ([self.delegate respondsToSelector:@selector(ppxPlayer:totalTime:)]) {
            [self.delegate ppxPlayer:self totalTime:totalTime];
        }
    });
}

- (void)bufferTimerAction:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        float preBuffer      = (float)self.audioStream.prebufferedByteCount;
        float contentLength  = (float)self.audioStream.contentLength;
        
        // 这里获取的进度不能准确地获取到1
        float bufferProgress = contentLength > 0 ? preBuffer / contentLength : 0;
        
        //    NSLog(@"缓冲进度%.2f", bufferProgress);
        
        // 为了能使进度准确的到1，这里做了一些处理
        int buffer = (int)(bufferProgress + 0.5);
        
        if (bufferProgress > 0.9 && buffer >= 1) {
            self.bufferState = PPXAudioBufferStateFinished;
            [self stopBufferTimer];
            // 这里把进度设置为1，防止进度条出现不准确的情况
            bufferProgress = 1.0f;
            
            NSLog(@"缓冲结束了，停止进度");
        }else {
            self.bufferState = PPXAudioBufferStateBuffering;
        }
        
        if ([self.delegate respondsToSelector:@selector(ppxPlayer:bufferProgress:)]) {
            [self.delegate ppxPlayer:self bufferProgress:bufferProgress];
        }
    });
}

- (void)removeCache {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray *arr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:self.audioStream.configuration.cacheDirectory error:nil];
        
        for (NSString *filePath in arr) {
            if ([filePath hasPrefix:@"FSCache-"]) {
                NSString *path = [NSString stringWithFormat:@"%@/%@", self.audioStream.configuration.cacheDirectory, filePath];
                [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
            }
        }
    });
}

- (void)setupPlayerState:(PPXAudioPlayerState)state {
    if ([self.delegate respondsToSelector:@selector(ppxPlayer:statusChanged:)]) {
        [self.delegate ppxPlayer:self statusChanged:state];
    }
}

#pragma mark - 懒加载
- (FSAudioStream *)audioStream {
    if (!_audioStream) {
        FSStreamConfiguration *configuration = [FSStreamConfiguration new];
        configuration.enableTimeAndPitchConversion = YES;
        
        _audioStream = [[FSAudioStream alloc] initWithConfiguration:configuration];
        _audioStream.strictContentTypeChecking = NO;
        _audioStream.defaultContentType = @"audio/x-m4a";
        
        __weak __typeof(self) weakSelf = self;
        
        _audioStream.onCompletion = ^{
            DDLog(@"完成");
        };
        
        _audioStream.onStateChange = ^(FSAudioStreamState state) {
            switch (state) {
                case kFsAudioStreamRetrievingURL:       // 检索url
                    NSLog(@"检索url");
                    weakSelf.playerState = PPXAudioPlayerStateLoading;
                    break;
                case kFsAudioStreamBuffering:           // 缓冲
                    NSLog(@"缓冲中。。");
                    weakSelf.playerState = PPXAudioPlayerStateBuffering;
                    weakSelf.bufferState = PPXAudioBufferStateBuffering;
                    break;
                case kFsAudioStreamSeeking:             // seek
                    NSLog(@"seek中。。");
                    weakSelf.playerState = PPXAudioPlayerStateLoading;
                    break;
                case kFsAudioStreamPlaying:             // 播放
                    NSLog(@"播放中。。");
                    weakSelf.playerState = PPXAudioPlayerStatePlaying;
                    break;
                case kFsAudioStreamPaused:              // 暂停
                    NSLog(@"播放暂停");
                    weakSelf.playerState = PPXAudioPlayerStatePaused;
                    break;
                case kFsAudioStreamStopped:              // 停止
                    
                    // 切换歌曲时主动调用停止方法也会走这里，所以这里添加判断，区分是切换歌曲还是被打断等停止
                    if (weakSelf.playerState != PPXAudioPlayerStateStoppedBy && weakSelf.playerState != PPXAudioPlayerStateEnded) {
                        NSLog(@"播放停止被打断");
                        weakSelf.playerState = PPXAudioPlayerStateStopped;
                    }
                    break;
                case kFsAudioStreamRetryingFailed:              // 检索失败
                    NSLog(@"检索失败");
                    weakSelf.playerState = PPXAudioPlayerStateError;
                    break;
                case kFsAudioStreamRetryingStarted:             // 检索开始
                    NSLog(@"检索开始");
                    weakSelf.playerState = PPXAudioPlayerStateLoading;
                    break;
                case kFsAudioStreamFailed:                      // 播放失败
                    NSLog(@"播放失败");
                    weakSelf.playerState = PPXAudioPlayerStateError;
                    break;
                case kFsAudioStreamPlaybackCompleted:           // 播放完成
                    NSLog(@"播放完成");
                    weakSelf.playerState = PPXAudioPlayerStateEnded;
                    break;
                case kFsAudioStreamRetryingSucceeded:           // 检索成功
                    NSLog(@"检索成功");
                    weakSelf.playerState = PPXAudioPlayerStateLoading;
                    break;
                case kFsAudioStreamUnknownState:                // 未知状态
                    NSLog(@"未知状态");
                    weakSelf.playerState = PPXAudioPlayerStateError;
                    break;
                case kFSAudioStreamEndOfFile:                   // 缓冲结束
                    {
                        NSLog(@"缓冲结束");
                        
                        if (self.bufferState == PPXAudioBufferStateFinished) return;
                        // 定时器停止后需要再次调用获取进度方法，防止出现进度不准确的情况
                        [weakSelf bufferTimerAction:nil];
                        
                        [weakSelf stopBufferTimer];
                    }
                    break;
                    
                default:
                    break;
            }
            [weakSelf setupPlayerState:weakSelf.playerState];
        };
    }
    return _audioStream;
}

@end
