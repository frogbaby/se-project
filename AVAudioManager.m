//
//  AVAudioManager.m
//  SXSpeechRecognitionTwoWays
//
//  Created by dongshangxian on 2016/12/15.
//  Copyright © 2016年 Sankuai. All rights reserved.
//

#import "AVAudioManager.h"
#import <Speech/Speech.h>

@interface AVAudioManager()<SFSpeechRecognitionTaskDelegate>


@property (nonatomic, strong) AVAudioRecorder *voiceRecorder;

@property (nonatomic, strong) AVAudioRecorder *monitor;

@property (nonatomic, strong) NSURL *recordURL;

@property (nonatomic, strong) NSURL *monitorURL;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation AVAudioManager

+ (instancetype)shareAudioManager
{
    static AVAudioManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[AVAudioManager alloc]init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    [self setupRecorder];
    return self;
}

- (void)setupRecorder {

    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:NULL];
    
    NSDictionary *recordSettings = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    [NSNumber numberWithFloat: 14400.0], AVSampleRateKey,
                                    [NSNumber numberWithInt: kAudioFormatAppleIMA4], AVFormatIDKey,
                                    [NSNumber numberWithInt: 2], AVNumberOfChannelsKey,
                                    [NSNumber numberWithInt: AVAudioQualityMax], AVEncoderAudioQualityKey,
                                    nil];
    
    NSString *recordPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"record.caf"];
    _recordURL = [NSURL fileURLWithPath:recordPath];
    
    _voiceRecorder = [[AVAudioRecorder alloc] initWithURL:_recordURL settings:recordSettings error:NULL];
    
    NSString *monitorPath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"monitor.caf"];
    _monitorURL = [NSURL fileURLWithPath:monitorPath];
    _monitor = [[AVAudioRecorder alloc] initWithURL:_monitorURL settings:recordSettings error:NULL];
    _monitor.meteringEnabled = YES;
}

- (void)setupTimer {
    [self.monitor record];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
}


- (void)updateTimer {

    [self.monitor updateMeters];

    float power = [self.monitor peakPowerForChannel:0];
    
    //        NSLog(@"%f", power);
    if (power > -20) {
        if (!self.voiceRecorder.isRecording) {
            NSLog(@"start recording");
            [self.voiceRecorder record];
        }
    } else {
        if (self.voiceRecorder.isRecording) {
            NSLog(@"stop recording");
            [self.voiceRecorder stop];
            
            [self recognition];
        }
    }
}



- (void)recognition {

    [self.timer invalidate];

    [self.monitor stop];

    [self.monitor deleteRecording];
    

    SFSpeechRecognizer *rec = [[SFSpeechRecognizer alloc]initWithLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];
    //            SFSpeechRecognizer *rec = [[SFSpeechRecognizer alloc]initWithLocale:[NSLocale localeWithLocaleIdentifier:@"en_ww"]];
    

    SFSpeechRecognitionRequest * request = [[SFSpeechURLRecognitionRequest alloc]initWithURL:_recordURL];
    [rec recognitionTaskWithRequest:request delegate:self];
}

- (void)speechRecognitionTask:(SFSpeechRecognitionTask *)task didFinishRecognition:(SFSpeechRecognitionResult *)recognitionResult
{
    NSLog(@"%s",__FUNCTION__);
    NSLog(@"%@",recognitionResult.bestTranscription.formattedString);
//    self.showLabel.text = recognitionResult.bestTranscription.formattedString;
//    NSTimeInterval cao = [[NSDate date]timeIntervalSince1970] - self.delay;
    [[NSNotificationCenter defaultCenter]postNotificationName:SPEECH_RECOGNITION_MSG object:nil userInfo:@{@"msg":recognitionResult.bestTranscription.formattedString}];
    [self setupTimer];
}

- (void)startRecording{
    [self setupTimer];
}

- (void)stopRecording{
    [self.timer invalidate];
}

@end
