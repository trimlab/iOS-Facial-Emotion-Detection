//
//  RZGraphView.h
//  VideoProc
//
//  Created by RM on 6/24/14.
//  Copyright (c) 2014 Ruimin Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kGraphHeight 300
#define kDefaultGraphWidth 1210
#define kOffsetX 10
#define kStepX 10
#define kGraphBottom 300
#define kGraphTop 0
#define kStepY 50
#define kOffsetY 10
#define kCircleRadius 3

@interface RZGraphView : UIView

@property NSMutableArray *happies, *surprises;
@end
