//
//  StartViewController.m
//  Gait
//
//  Created by Kai Kunze on 02/12/2013.
//  Copyright (c) 2013 Kai Kunze. All rights reserved.
//

#import "StartViewController.h"
#import <CoreMotion/CoreMotion.h>

@interface StartViewController ()

@end

@implementation StartViewController

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
    // Do any additional setup after loading the view from its nib.
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    //[self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if([CMStepCounter isStepCountingAvailable] && [CMMotionActivityManager isActivityAvailable])
    {
        [self performSegueWithIdentifier:@"toMainView" sender:self];
    }else{
        [self performSegueWithIdentifier:@"toNoM7View" sender:self];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
