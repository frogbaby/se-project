//
//  AVAudioManager.h
//  SXSpeechRecognitionTwoWays
//
//  Created by dongshangxian on 2016/12/15.
//  Copyright © 2016年 Sankuai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AVAudioManager : NSObject

+ (instancetype)shareAudioManager;

- (void)startRecording;
- (void)stopRecording;

@end
