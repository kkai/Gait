//
//  ViewController.m
//  Gait
//
//  Created by Kai Kunze on 24/11/2013.
//  Copyright (c) 2013 Kai Kunze. All rights reserved.
//
//
//  ViewController.m
//  activitylog
//
//  Created by Kai Kunze on 23/11/2013.
//  Copyright (c) 2013 Kai Kunze. All rights reserved.
//

#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>

@interface ViewController ()
@property (nonatomic, strong) CMStepCounter *stepCounter;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.stepCounter = [[CMStepCounter alloc] init];
    
    if (![CMStepCounter isStepCountingAvailable]) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Activity Tracking Co-Processor available"
                                                    message:@"To run this program and track your steps, you need an iPhone 5s or a newer device with a M7 co-processor."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
        [alert show];
    }
    _todayProgressView.showShadow = false;
    _todayProgressView.progressFillColor =self.view.tintColor;
    
    _yesterdayProgressView.showShadow = false;
    _yesterdayProgressView.progressFillColor =self.view.tintColor;
    
    _thisWeekProgressView.showShadow = false;
    _thisWeekProgressView.progressFillColor =self.view.tintColor;
    
    _lastWeekProgressView.showShadow = false;
    _lastWeekProgressView.progressFillColor =self.view.tintColor;
    
    _thisMonthProgressView.showShadow = false;
    _thisMonthProgressView.progressFillColor =self.view.tintColor;
    
    // setup the pogress views on the right

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)updateSteps:(id)sender{
    __weak typeof(self) weakSelf = self;
    if ([CMStepCounter isStepCountingAvailable]) {
        NSDate *now = [NSDate date];
        NSCalendar *gregorian = [[NSCalendar alloc]
                                 initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *comps = [gregorian components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour fromDate:now];
        [comps setHour:0];
        NSDate *today = [gregorian dateFromComponents:comps];
        
        
        
        NSCalendar *cal = [NSCalendar currentCalendar];
        NSDateComponents *components = [cal components:( NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit ) fromDate:[[NSDate alloc] init]];
        
        [components setHour:-[components hour]];
        [components setMinute:-[components minute]];
        [components setSecond:-[components second]];
        
        [components setHour:-24];
        [components setMinute:0];
        [components setSecond:0];
        NSDate *yesterday = [cal dateByAddingComponents:components toDate: today options:0];
        
        components = [cal components:NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit fromDate:[[NSDate alloc] init]];
        
        [components setDay:([components day] - ([components weekday] - 1))];
        NSDate *thisWeek  = [cal dateFromComponents:components];
        
        [components setDay:([components day] - 7)];
        NSDate *lastWeek  = [cal dateFromComponents:components];
        
        [components setDay:([components day] - ([components day] -1))];
        NSDate *thisMonth = [cal dateFromComponents:components];
        
        //[components setMonth:([components month] - 1)];
        //NSDate *lastMonth = [cal dateFromComponents:components];
        
        //NSLog(@"today=%@",today);
        //NSLog(@"yesterday=%@",yesterday);
        //NSLog(@"thisWeek=%@",thisWeek);
        //NSLog(@"lastWeek=%@",lastWeek);
        //NSLog(@"thisMonth=%@",thisMonth);
        //NSLog(@"lastMonth=%@",lastMonth);
        
        
        [self.stepCounter queryStepCountStartingFrom:today
                                                  to:now
                                             toQueue:[NSOperationQueue mainQueue]
                                         withHandler:^(NSInteger numberOfSteps, NSError *error) {
                                             
                                             _todayProgressView.progress = numberOfSteps / 10000.0;
                                             //[weakSelf fadeAnimationVisible:YES];
                                             weakSelf.todayStepsLabel.text = [@(numberOfSteps) stringValue];
                                         }];
        
        
        [self.stepCounter queryStepCountStartingFrom:yesterday
                                                  to:today
                                             toQueue:[NSOperationQueue mainQueue]
                                         withHandler:^(NSInteger numberOfSteps, NSError *error) {
                                           
                                             _yesterdayProgressView.progress = numberOfSteps / 10000.0;

                                             //[weakSelf fadeAnimationVisible:YES];
                                             weakSelf.yesterdayStepsLabel.text = [@(numberOfSteps) stringValue];
                                         }];
        [self.stepCounter queryStepCountStartingFrom:thisWeek
                                                  to:now
                                             toQueue:[NSOperationQueue mainQueue]
                                         withHandler:^(NSInteger numberOfSteps, NSError *error) {
                                             
                                             _thisWeekProgressView.progress = numberOfSteps / 70000.0;

                                             //[weakSelf fadeAnimationVisible:YES];
                                             weakSelf.thisWeekStepsLabel.text = [@(numberOfSteps) stringValue];
                                         }];
        [self.stepCounter queryStepCountStartingFrom:lastWeek
                                                  to:thisWeek
                                             toQueue:[NSOperationQueue mainQueue]
                                         withHandler:^(NSInteger numberOfSteps, NSError *error) {
                                             
                                             //[weakSelf fadeAnimationVisible:YES];
                                             _lastWeekProgressView.progress = numberOfSteps / 70000.0;

                                             weakSelf.lastWeekStepsLabel.text = [@(numberOfSteps) stringValue];
                                         }];
        [self.stepCounter queryStepCountStartingFrom:thisMonth
                                                  to:now
                                             toQueue:[NSOperationQueue mainQueue]
                                         withHandler:^(NSInteger numberOfSteps, NSError *error) {
                                             
                                             //[weakSelf fadeAnimationVisible:YES];
                                             _thisMonthProgressView.progress = numberOfSteps / 300000.0;

                                             weakSelf.thisMonthStepsLabel.text = [@(numberOfSteps) stringValue];
                                         }];
        
    }else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Activity Tracking Co-Processor available"
                                                        message:@"To run this program and track your steps, you need an iPhone 5s or a newer device with a M7 co-processor."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }

    
}

@end