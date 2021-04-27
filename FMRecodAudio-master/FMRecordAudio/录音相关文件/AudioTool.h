//
//  AudioTool.h
//  RecordingDemo
//
//  Created by CharmingLee on 16/6/3.
//  Copyright © 2016年 C2B_Charming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol AudioToolDelegate <NSObject>
@optional
-(void)statrPCMtoMP3;
-(void)endPCMtoMP3:(NSString *)fileName;
-(void)startSynthesis;
-(void)endSynthesis:(NSString *)fileName;
@end

@interface AudioTool : NSObject
@property(nonatomic,weak)id<AudioToolDelegate> audioToolDelegate;
/**
 *  获取录音对象
 *
 *  @param fileName 录音文件路径
 *
 *  @return 
 */
-(AVAudioRecorder *)getRecorfer:(NSString *)fileName;

/**
 *  获取录音文件播放器对象
 *
 *  @param fileName 播放文件路径
 *
 *  @return
 */
-(AVAudioPlayer *)getRecorferPlayer;

/**
 *  获取合成文件播放器对象
 *
 *  @param fileName 播放文件路径
 *
 *  @return
 */
-(AVAudioPlayer *)getSynthesisPlayer;

/**
 *  合成音频
 */
-(void)synthesisWithSouceFilePath:(NSString *)souceFilePath desFilePath:(NSString *)desFilePath;
@end
