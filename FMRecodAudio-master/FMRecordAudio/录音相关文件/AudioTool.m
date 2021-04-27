//
//  AudioTool.m
//  RecordingDemo
//
//  Created by CharmingLee on 16/6/3.
//  Copyright © 2016年 C2B_Charming. All rights reserved.
//

#import "AudioTool.h"
#import "VideoAudioComposition.h"

#import "lame.h"

#define mp3FileName           [NSString stringWithFormat:@"%@.mp3",[NSString getNowTimeTimestamp2]]
#define synthesisFileName     [NSString stringWithFormat:@"%@.mp3",[NSString getNowTimeTimestamp2]]
#define KFILESIZE (1 * 1024 * 1024)

@interface AudioTool()<AVAudioRecorderDelegate>
/**录音文件文件夹存放路径**/
@property(nonatomic, strong) NSString *filePath;
/**真机时使用**/
@property(nonatomic, strong) AVAudioSession *session;
/**录音的设置**/
@property(nonatomic, strong) NSMutableDictionary *setting;


@property (nonatomic, copy) NSString *hechengFileName;

@end

@implementation AudioTool

#pragma mark 懒加载
- (AVAudioSession *)session {
    
 
    
   // if (!_session) {
        _session = [AVAudioSession sharedInstance];
        NSError *sessionError;
    
        [_session setCategory:AVAudioSessionCategoryPlayAndRecord
                        error:&sessionError];
    
  //  }
    
    return _session;
}

- (NSMutableDictionary *)setting {
   // if (!_setting) {
        _setting = [NSMutableDictionary dictionary];
        //录音格式 无法使用
        [_setting setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM]
                    forKey:AVFormatIDKey];
        //采样率
        [_setting setValue:[NSNumber numberWithFloat:44100.0]
                    forKey:AVSampleRateKey]; // 44100.0 11025.0
        //通道数
        [_setting setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
        //线性采样位数
        //[recordSettings setValue :[NSNumber numberWithInt:16] forKey:
        //AVLinearPCMBitDepthKey];
        //音频质量,采样质量
        [_setting setValue:[NSNumber numberWithInt:AVAudioQualityMin]
                    forKey:AVEncoderAudioQualityKey];
 //   }
    
    return _setting;
}

- (NSString *)filePath {
    if (!_filePath) {
        // 获取沙盒地址
        _filePath = [NSSearchPathForDirectoriesInDomains(
                                                         NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
       _filePath = [_filePath stringByAppendingPathComponent:@"audio"];
//        static int i = 1;
//        i = i + 1;
//        NSString *str = HPString(@"audio%d",i);
//        _filePath = [_filePath stringByAppendingPathComponent:str];

    }
    
    return _filePath;
}

#pragma mark 获取录音对象操作
-(AVAudioRecorder *)getRecorfer:(NSString *)fileName{
    //判断文件路径是否存在
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if (![manager fileExistsAtPath:self.filePath]) {
        [manager createDirectoryAtPath:self.filePath
           withIntermediateDirectories:YES
                            attributes:nil
                                 error:nil];
    }
    
    NSString *filePath = [self.filePath stringByAppendingPathComponent:fileName];
    AVAudioRecorder *recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:filePath]
                                settings:self.setting
                                   error:nil];
    recorder.delegate = self;
    recorder.meteringEnabled = YES;
    
    DDLog(@"看一下路径%@",self.filePath);
    
    //真机使用
    [self.session setActive:YES error:nil];
    
    
    
    return recorder;
}

//录音完毕的回调
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    
  
    //转换MP3
    NSString *souceFilePath = [recorder.url absoluteString];
      DDLog(@"转换前的路径%@",souceFilePath);
    
    souceFilePath = [souceFilePath substringFromIndex:7];
    
    NSString *newFilePath =
    [self.filePath stringByAppendingPathComponent:mp3FileName];
    if ([self.audioToolDelegate respondsToSelector:@selector(statrPCMtoMP3)]) {
        [self.audioToolDelegate statrPCMtoMP3];
    }
    
    //开启子线程转换文件
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        //转换格式
        [self audio_PCMtoMP3:souceFilePath andDesPath:newFilePath];
        
        //删除录音文件
        [recorder deleteRecording];
        
        //从主线程回调转换完成
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.audioToolDelegate respondsToSelector:@selector(endPCMtoMP3:)]) {
                [self.audioToolDelegate endPCMtoMP3:newFilePath];
            }
        });
        
    });
}

#pragma mark 播放MP3对象
-(AVAudioPlayer *)getRecorferPlayer{
    AVAudioPlayer *player = [[AVAudioPlayer alloc]
                   initWithContentsOfURL:[NSURL URLWithString:[self.filePath stringByAppendingPathComponent:mp3FileName]]
                   error:NULL];
    
    return player;
}

-(AVAudioPlayer *)getSynthesisPlayer{
    AVAudioPlayer *player = [[AVAudioPlayer alloc]
                             initWithContentsOfURL:[NSURL URLWithString:[self.filePath stringByAppendingPathComponent:synthesisFileName]]
                             error:NULL];
    
    return player;
}

#pragma mark 转换MP3

- (void)audio_PCMtoMP3:(NSString *)soucePath andDesPath:(NSString *)desPath {
    DDLog(@"开始转换");
    
    @try {
        int read, write;
        
        FILE *pcm = fopen([soucePath cStringUsingEncoding:1],
                          "rb"); // source 被转换的音频文件位置
        fseek(pcm, 4 * 1024, SEEK_CUR); // skip file header
        FILE *mp3 = fopen([desPath cStringUsingEncoding:1],
                          "wb"); // output 输出生成的Mp3文件位置
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE * 2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 44100.0);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            read = fread(pcm_buffer, 2 * sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read,
                                                       mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    } @catch (NSException *exception) {
        DDLog(@"%@", [exception description]);
    } @finally {
        DDLog(@"MP3生成成功%@",desPath);
    }
}

#pragma mark 合成音频
-(void)synthesisWithSouceFilePath:(NSString *)souceFilePath desFilePath:(NSString *)desFilePath{
    
    if ([self.audioToolDelegate respondsToSelector:@selector(startSynthesis)]) {
        [self.audioToolDelegate startSynthesis];
    }
    DDLog(@"合成%@---%@",souceFilePath,desFilePath);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
             [self pieceFileA:souceFilePath withFileB:desFilePath];
            
            //回调主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.audioToolDelegate respondsToSelector:@selector(endSynthesis:)]) {
                    [self.audioToolDelegate endSynthesis:self.hechengFileName];
                }
            });
        });
       
        
       
    });
}

- (BOOL)pieceFileA:(NSString *)filePathA withFileB:(NSString *)filePathB {
    
    
    DDLog(@"当前时间戳%@",[NSString getNowTimeTimestamp2]);
    
    //把文件复制到带合成文件路径
    NSString *synthesisFilePath = [self.filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3",[NSString getNowTimeTimestamp2]]];
    
    DDLog(@"合成啦啦啦的路径%@",synthesisFilePath);
    
    [[NSFileManager defaultManager] copyItemAtPath:filePathA toPath:synthesisFilePath error:nil];
    
   
    self.hechengFileName = synthesisFilePath;
    
    // 更新的方式读取文件A
    NSFileHandle *handleA = [NSFileHandle fileHandleForUpdatingAtPath:synthesisFilePath];
    [handleA seekToEndOfFile];
    
    NSDictionary *fileBDic =
    [[NSFileManager defaultManager] attributesOfItemAtPath:filePathB
                                                     error:nil];
    long long fileSizeB = fileBDic.fileSize;
    
    // 大于xM分片拼接xM
    if (fileSizeB > KFILESIZE) {
        
        // 分片
        long long pieces = fileSizeB / KFILESIZE; // 整片
        long long let = fileSizeB % KFILESIZE;    // 剩余片
        
        long long sizes = pieces;
        // 有余数
        if (let > 0) {
            // 加多一片
            sizes += 1;
        }
        
        NSFileHandle *handleB = [NSFileHandle fileHandleForReadingAtPath:filePathB];
        for (int i = 0; i < sizes; i++) {
            
            [handleB seekToFileOffset:i * KFILESIZE];
            NSData *tmp = [handleB readDataOfLength:KFILESIZE];
            [handleA writeData:tmp];
        }
        
        [handleB synchronizeFile];
        
        // 大于xM分片读xM(最后一片可能小于xM)
    } else {
        
        [handleA writeData:[NSData dataWithContentsOfFile:filePathB]];
    }
    
    [handleA synchronizeFile];
    
    DDLog(@"北京欢迎你%@\n%@",filePathA,filePathB);
    
    // 将B文件删除
        [[NSFileManager defaultManager] removeItemAtPath:filePathA error:nil];
        [[NSFileManager defaultManager] removeItemAtPath:filePathB error:nil];
     DDLog(@"合成以后的路径%@",synthesisFilePath);
    
    return YES;
}

@end
