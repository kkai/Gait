//
//  ViewController.h
//  Gait
//
//  Created by Kai Kunze on 24/11/2013.
//  Copyright (c) 2013 Kai Kunze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PICircularProgressView.h"

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *todayStepsLabel;
@property (weak, nonatomic) IBOutlet UILabel *yesterdayStepsLabel;
@property (weak, nonatomic) IBOutlet UILabel *thisWeekStepsLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastWeekStepsLabel;
@property (weak, nonatomic) IBOutlet UILabel *thisMonthStepsLabel;

@property (weak, nonatomic) IBOutlet PICircularProgressView  *todayProgressView;
@property (weak, nonatomic) IBOutlet PICircularProgressView  *yesterdayProgressView;
@property (weak, nonatomic) IBOutlet PICircularProgressView  *thisWeekProgressView;
@property (weak, nonatomic) IBOutlet PICircularProgressView  *lastWeekProgressView;
@property (weak, nonatomic) IBOutlet PICircularProgressView  *thisMonthProgressView;


@end
