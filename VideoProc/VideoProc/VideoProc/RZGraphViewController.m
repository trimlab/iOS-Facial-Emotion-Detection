//
//  RZGraphViewController.m
//  VideoProc
//
//  Created by RM on 6/24/14.
//  Copyright (c) 2014 Ruimin Zhang. All rights reserved.
//

#import "RZGraphViewController.h"
#import "RZGraphView.h"

@interface RZGraphViewController ()

@end

@implementation RZGraphViewController

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
    self.myScrollView.contentSize = CGSizeMake(kDefaultGraphWidth*2, kGraphHeight*2);
    // Pass data to graph view
    ((RZGraphView *)[self.view viewWithTag:2]).happies = self.happies ;    
    ((RZGraphView *)[self.view viewWithTag:2]).surprises = self.surprises ;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return YES;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
