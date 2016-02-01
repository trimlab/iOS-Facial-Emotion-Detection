//
//  YMCAudioPlayer.h
//  AudioPlayerTemplate
//
//  Created by RM on 11/17/13.
//  Copyright (c) 2013 Ruimin Zhang. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface YMCAudioPlayer : UIViewController

@property (nonatomic, retain) AVAudioPlayer *audioPlayer;

// Public mehtods
- (void) initPlayer: (NSString *) audioFile fileExtension:(NSString *) fileExtension;
- (void) playAudio;
- (void) pauseAudio;
- (void) setCurrentAudioTime:(float)value;
- (float) getAudioDuration;
- (NSString *) timeFormat: (float)value;
- (NSTimeInterval) getCurrentAudioTime;

@end
