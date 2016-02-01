//
//  YMCAudioPlayer.m
//  AudioPlayerTemplate
//
//  Created by RM on 11/17/13.
//  Copyright (c) 2013 Ruimin Zhang. All rights reserved.
//

#import "YMCAudioPlayer.h"

@implementation YMCAudioPlayer

/*
 * Init the Player with Filename and FileExtension
 */ 
- (void) initPlayer:(NSString *) audioFile fileExtension:(NSString *) fileExtension
{
    NSURL *audioFileLocationURL = [[NSBundle mainBundle] URLForResource:audioFile withExtension:fileExtension];
    NSError *error;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:audioFileLocationURL error:&error];
}

/*
 * Simply fire the play event
 */
- (void)playAudio
{
    [self.audioPlayer play];
}

/*
 * Simply fire the pause event
 */
- (void) pauseAudio
{
    [self.audioPlayer pause];
}

/*
 * Format the float time values like duration
 * to format with minutes and seconds
 */
- (NSString *)timeFormat:(float)value
{
    float minutes = floor(lroundf(value)/60);
    float seconds = lroundf(value) - (minutes * 60);
    int roundedSeconds = lroundf(seconds);
    int roundedMinutes = lroundf(minutes);
    NSString *time = [[NSString alloc] initWithFormat:@"%d:%02d", roundedMinutes, roundedSeconds];
    return time;
}

/*
 * To set the current position of the playing audio file
 */
- (void)setCurrentAudioTime:(float)value
{
    [self.audioPlayer setCurrentTime:value];
}


/*
 * Get the time where audio is playing right now
 */
- (NSTimeInterval)getCurrentAudioTime
{
    return [self.audioPlayer currentTime];
}

/*
 * Get the whole length of the audio file
 */
- (float)getAudioDuration
{
    return [self.audioPlayer duration];
}

@end
