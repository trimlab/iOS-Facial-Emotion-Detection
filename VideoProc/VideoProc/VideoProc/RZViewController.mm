//
//  RZViewController.m
//  VideoProc
//
//  Created by RM on 5/6/14.
//  Copyright (c) 2014 Ruimin Zhang. All rights reserved.
//

#import "RZViewController.h"
#import "RZGraphViewController.h"
#import <CoreImage/CoreImage.h> 
#import <ImageIO/ImageIO.h>

@interface RZViewController ()

@end

@implementation RZViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    /*
    int **detection;
    detection = (int **)malloc(120*sizeof(int *));
    for(int i=0;i<120;i++){
        detection[i] = (int *)malloc(2*sizeof(int));
    }
    
    id = 0;
    for(int i=0;i<120;i++){
        for(int j=0;j<2;j++){
            detection[i][j] = 0;
        }
    }
     */
    
    surprises = [[NSMutableArray alloc] init];
    happies = [[NSMutableArray alloc] init];
     
    
    self.laughPlayer = [[YMCAudioPlayer alloc] init];
    [self.laughPlayer initPlayer:@"shortLaugh" fileExtension:@"wav"];
    self.surprisePlayer = [[YMCAudioPlayer alloc] init];
    [self.surprisePlayer initPlayer:@"surprise" fileExtension:@"wav"];
    
    videoCamera = [[CvVideoCamera alloc] initWithParentView:self.imageView];
    videoCamera.delegate = self;
    videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionFront;
    videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset352x288;
    videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    videoCamera.defaultFPS = 15;
    videoCamera.grayscaleMode = NO;
    isCapturing = NO;
    
    // Load cascade classifier of face from the XML file
    NSString* cascadePath_forFace = [[NSBundle mainBundle]      pathForResource:@"opencv_data_haarcascades_haarcascade_frontalface_alt2" ofType:@"xml"];
    faceDetector.load([cascadePath_forFace UTF8String]);
    
    // Load cascade classifier of happy from the XML file
    NSString* cascadePath_forHappy = [[NSBundle mainBundle]      pathForResource:@"haarcascade_8400pos_happy" ofType:@"xml"];
    happyDetector.load([cascadePath_forHappy UTF8String]);
    
    // Load cascade classifier of surprise from the XML file
    NSString* cascadePath_forSurprise = [[NSBundle mainBundle]      pathForResource:@"haarcascade_surprise_final" ofType:@"xml"];
    surpriseDetector.load([cascadePath_forSurprise UTF8String]);
    
    // Load cascade classifier of angry from the XML file
    NSString* cascadePath_forAnger = [[NSBundle mainBundle]      pathForResource:@"haarcascade_anger_final" ofType:@"xml"];
    angerDetector.load([cascadePath_forAnger UTF8String]);
    
    // Load cascade classifier of fear from the XML file
    NSString* cascadePath_forFear = [[NSBundle mainBundle]      pathForResource:@"fear-lbp-24x24-8000" ofType:@"xml"];
    fearDetector.load([cascadePath_forFear UTF8String]);
    
    // Load cascade classifier of disgust from the XML file
    NSString* cascadePath_forDisgust = [[NSBundle mainBundle]      pathForResource:@"disgust-haar" ofType:@"xml"];
    disgustDetector.load([cascadePath_forDisgust UTF8String]);
    
    // Load cascade classifier of sad from the XML file
    NSString* cascadePath_forSad = [[NSBundle mainBundle]      pathForResource:@"sadness-haar" ofType:@"xml"];
    sadDetector.load([cascadePath_forSad UTF8String]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if(isCapturing){  // Force to stop the camera when the application is closing
        [videoCamera stop]; 
    }
    
}

- (void) prepareForSegue: (UIStoryboardSegue *)segue sender:(id)sender{

    if ([segue.identifier isEqualToString:@"segue1"]){
        RZGraphViewController *graphViewController = (RZGraphViewController *)segue.destinationViewController;
        graphViewController.surprises = surprises;
        graphViewController.happies = happies;
    }     
}

#pragma mark - Navigation

/* 
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

 
- (IBAction)startCaptureButtonPressed:(id)sender {
    [videoCamera start];
    isCapturing = YES;
    NSLog(@"video camera starts!");
    
}
- (IBAction)stopCaptureButtonPressed:(id)sender {
    [videoCamera stop];
    isCapturing = NO;
    NSLog(@"video camera stops!");
}


-(void)processImage:(cv::Mat&)image{
    id++; // track the frame #
    
    Mat gray;
    cvtColor(image, gray, CV_BGR2GRAY);
    std::vector<cv::Rect> faces;
    
  /*  faceDetector.detectMultiScale(gray, faces, 1.1, 2, 0|CV_HAAR_SCALE_IMAGE, cv::Size(30,30));
    
    // Draw detected faces
    for(unsigned int i=0; i<faces.size(); i++){
        const cv::Rect& face = faces[i];
        // Get top-left and bottom-right corner points
        cv::Point t1(face.x, face.y);
        cv::Point br = t1 + cv::Point(face.width, face.height);
        // Draw rectangle around the face
        cv::Scalar magenta = cv::Scalar(255, 0, 255);
        cv::rectangle(image, t1, br, magenta, 4, 8, 0);
        //cv::putText(image, "face", t1, FONT_HERSHEY_COMPLEX, 0.8, cvScalar(200,200,250));
        
        // Detect fear emotion on the face
        cv::Rect myROI(face.x, face.y, face.width, face.height);
        cv::Mat croppedImage = image(myROI);
        std::vector<cv::Rect> facials;
        fearDetector.detectMultiScale(gray, facials, 1.1, 2, 0|CV_HAAR_SCALE_IMAGE, cv::Size(3,30));
        if(facials.size() > 0){
           cv::putText(image, "fear", t1, FONT_HERSHEY_COMPLEX, 0.8, cvScalar(200,200,250));   
        }
    }
    
    //if (faces.size() > 0){
    //    printf("A happy face is detected.\n");
        
    //}
   */

    /*  temporarily comment out detection of happy and surprise to test angry emotion  
    // Detect faces of happy
    happyDetector.detectMultiScale(gray, faces, 1.1, 2, 0|CV_HAAR_SCALE_IMAGE, cv::Size(30,30));
        
    // Draw detected faces
    for(unsigned int i=0; i<faces.size(); i++){
        const cv::Rect& face = faces[i];
        // Get top-left and bottom-right corner points
        cv::Point t1(face.x, face.y);
        cv::Point br = t1 + cv::Point(face.width, face.height);
        // Draw rectangle around the face
        cv::Scalar magenta = cv::Scalar(255, 0, 255);
        cv::rectangle(image, t1, br, magenta, 4, 8, 0);
        cv::putText(image, "happy", t1, FONT_HERSHEY_COMPLEX, 0.8, cvScalar(200,200,250));
    }
    
    if (faces.size() > 0){
        printf("A happy face is detected.\n");
        [self.laughPlayer playAudio];
        [happies addObject:@"1"];
    }else{
        [happies addObject:@"0"];
    }
    
    // Detect faces of surprise
    surpriseDetector.detectMultiScale(gray, faces, 1.1, 2, 0|CV_HAAR_SCALE_IMAGE, cv::Size(30,30));
    
    // Draw detected faces
    for(unsigned int i=0; i<faces.size(); i++){
        const cv::Rect& face = faces[i];
        // Get top-left and bottom-right corner points
        cv::Point t1(face.x, face.y);
        cv::Point br = t1 + cv::Point(face.width, face.height);
        // Draw rectangle around the face
        cv::Scalar magenta = cv::Scalar(255, 0, 255);
        cv::rectangle(image, t1, br, magenta, 4, 8, 0);
        cv::putText(image, "surprise", t1, FONT_HERSHEY_COMPLEX, 0.8, cvScalar(200,200,250));

    }
    
    if (faces.size() > 0){
        printf("A surprise face is detected.\n");
        [self.surprisePlayer playAudio];
        [surprises addObject:@"1"];
    }else{
        [surprises addObject:@"0"];
    }
    
    */
    // Detect faces of angry
    angerDetector.detectMultiScale(gray, faces, 1.1, 2, 0|CV_HAAR_SCALE_IMAGE, cv::Size(30,30));
    
    // Draw detected faces
    for(unsigned int i=0; i<faces.size(); i++){
        const cv::Rect& face = faces[i];
        // Get top-left and bottom-right corner points
        cv::Point t1(face.x, face.y);
        cv::Point br = t1 + cv::Point(face.width, face.height);
        // Draw rectangle around the face
        cv::Scalar magenta = cv::Scalar(255, 0, 255);
        cv::rectangle(image, t1, br, magenta, 4, 8, 0);
        cv::putText(image, "angry", t1, FONT_HERSHEY_COMPLEX, 0.8, cvScalar(200,200,250));
    }
    
    if (faces.size() > 0){
        printf("A angry face is detected.\n");
    }
    
   /*
    // TODO: This fear classifier's misalarm rate is too high 
    // Detect faces of fear
    fearDetector.detectMultiScale(gray, faces, 1.1, 2, 0|CV_HAAR_SCALE_IMAGE, cv::Size(30,30));
    
    // Draw detected faces
    for(unsigned int i=0; i<faces.size(); i++){
        const cv::Rect& face = faces[i];
        // Get top-left and bottom-right corner points
        cv::Point t1(face.x, face.y);
        cv::Point br = t1 + cv::Point(face.width, face.height);
        // Draw rectangle around the face
        cv::Scalar magenta = cv::Scalar(255, 0, 255);
        cv::rectangle(image, t1, br, magenta, 4, 8, 0);
        cv::putText(image, "fear", t1, FONT_HERSHEY_COMPLEX, 0.8, cvScalar(200,200,250));
    }
    
    if (faces.size() > 0){
        printf("A fear face is detected.\n");
    }

*/  
/*    
    // Detect faces of fear
    fearDetector.detectMultiScale(gray, faces, 1.1, 2, 0|CV_HAAR_SCALE_IMAGE, cv::Size(30,30));
    // Draw detected faces
    for(unsigned int i=0; i<faces.size(); i++){
        const cv::Rect& face = faces[i];
        // Get top-left and bottom-right corner points
        cv::Point t1(face.x, face.y);
        cv::Point br = t1 + cv::Point(face.width, face.height);
        // Draw rectangle around the face
        cv::Scalar magenta = cv::Scalar(255, 0, 255);
        cv::rectangle(image, t1, br, magenta, 4, 8, 0);
        cv::putText(image, "fear", t1, FONT_HERSHEY_COMPLEX, 0.8, cvScalar(200,200,250));
    }
    
    if (faces.size() > 0){
        printf("A fear face is detected.\n");
    } 

 */
   
    
}


@end
