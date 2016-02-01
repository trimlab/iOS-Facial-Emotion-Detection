//
//  RZViewController.h
//  VideoProc
//
//  Created by RM on 5/6/14.
//  Copyright (c) 2014 Ruimin Zhang. All rights reserved.
//


#import <opencv2/videoio/cap_ios.h>
#import "opencv2/highgui/ios.h"
using namespace cv;

#import <UIKit/UIKit.h>

#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

#import "YMCAudioPlayer.h"




@interface RZViewController : UIViewController <CvVideoCameraDelegate>
{
    
    CvVideoCamera* videoCamera;
    BOOL isCapturing;
    
    CascadeClassifier faceDetector,happyDetector, surpriseDetector, angerDetector, 
        fearDetector,
        disgustDetector,
        sadDetector;
    UIImageView* resultView;
    int **detection;
    NSMutableArray *surprises, *happies;
    
    int id;
    
}

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
//@property (nonatomic, strong) CvVideoCamera* videoCamera;
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *startCaptureButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *stopCaptureButton;

@property (strong, nonatomic) UIImage *myimage;
@property (nonatomic, retain) YMCAudioPlayer *laughPlayer, *surprisePlayer;

-(IBAction)startCaptureButtonPressed:(id)sender;
-(IBAction)stopCaptureButtonPressed:(id)sender;




//@property (nonatomic, weak) IBOutlet UIImageView *imageView;

@end
