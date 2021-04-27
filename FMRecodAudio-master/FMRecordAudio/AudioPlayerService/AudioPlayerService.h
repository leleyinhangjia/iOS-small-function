//
//  AudioPlayerService.h
//  ZHEJIANG
//
//  Created by pipixia on 2018/11/19.
//  Copyright © 2018年 pipixia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FreeStreamer/FSAudioStream.h>

// 播放器播放状态
typedef NS_ENUM(NSUInteger, PPXAudioPlayerState) {
    PPXAudioPlayerStateLoading,          // 加载中
    PPXAudioPlayerStateBuffering,        // 缓冲中
    PPXAudioPlayerStatePlaying,          // 播放
    PPXAudioPlayerStatePaused,           // 暂停
    PPXAudioPlayerStateStoppedBy,        // 停止（用户切换歌曲时调用）
    PPXAudioPlayerStateStopped,          // 停止（播放器主动发出：如播放被打断）
    PPXAudioPlayerStateEnded,            // 结束（播放完成）
    PPXAudioPlayerStateError             // 错误
};

// 播放器缓冲状态
typedef NS_ENUM(NSUInteger, PPXAudioBufferState) {
    PPXAudioBufferStateNone,
    PPXAudioBufferStateBuffering,
    PPXAudioBufferStateFinished
};

#define kPlayer [AudioPlayerService sharedInstance]

@class AudioPlayerService;

@protocol PPXAudioPlayerDelegate<NSObject>

// 播放器状态改变
- (void)ppxPlayer:(AudioPlayerService *)player statusChanged:(PPXAudioPlayerState)status;

// 播放时间（单位：毫秒)、总时间（单位：毫秒）、进度（播放时间 / 总时间）
- (void)ppxPlayer:(AudioPlayerService *)player currentTime:(NSTimeInterval)currentTime totalTime:(NSTimeInterval)totalTime progress:(float)progress;

// 总时间（单位：毫秒）
- (void)ppxPlayer:(AudioPlayerService *)player totalTime:(NSTimeInterval)totalTime;

// 缓冲进度
- (void)ppxPlayer:(AudioPlayerService *)player bufferProgress:(float)bufferProgress;

@end

@interface AudioPlayerService : NSObject

/**
 代理
 */
@property (nonatomic, weak) id<PPXAudioPlayerDelegate> delegate;

/**
 播放地址（网络或本地）
 */
@property (nonatomic, copy) NSString *playUrlStr;

/**
 播放状态
 */
@property (nonatomic, assign) PPXAudioPlayerState    playerState;

/**
 缓冲状态
 */
@property (nonatomic, assign) PPXAudioBufferState    bufferState;

/**
 单例

 @return 播放器对象
 */
+ (instancetype)sharedInstance;

/**
 快进、快退

 @param progress 进度
 */
- (void)setPlayerProgress:(float)progress;

/**
 设置播放速率 0.5 - 2.0， 1.0是正常速率
 
 @param playRate 速率
 */
- (void)setPlayerPlayRate:(float)playRate;

/**
 播放
 */
- (void)play;

/**
 从某个进度开始播放

 @param progress 进度
 */
- (void)playFromProgress:(float)progress;

/**
 暂停
 */
- (void)pause;

/**
 恢复（暂停后再次播放使用）
 */
- (void)resume;

/**
 停止
 */
- (void)stop;

/** 声音 */
@property (nonatomic, assign) float volume;

@end
