//
//  GaitTableViewController.m
//  Gait
//
//  Created by Kai Kunze on 02/12/2013.
//  Copyright (c) 2013 Kai Kunze. All rights reserved.
//

#import "GaitTableViewController.h"
#import "GaitCell.h"
#import <CoreMotion/CoreMotion.h>

@interface GaitTableViewController ()
@property (strong, nonatomic) CMStepCounter *stepCounter;

@end

@implementation GaitTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]
                                        init];
    refreshControl.tintColor = self.view.tintColor;
    self.refreshControl = refreshControl;
    [refreshControl addTarget:self action:@selector(updateSteps) forControlEvents:UIControlEventValueChanged];

    _stepCounter = [[CMStepCounter alloc] init];

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.000 green:0.478 blue:1.000 alpha:1.000]];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:0.000 green:0.478 blue:1.000 alpha:1.000]];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.hidesBackButton = YES;

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 240.0, 44.0)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont fontWithName:@"Avenir" size:25];
    titleLabel.text = @"Gait";
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleLabel;
    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void) updateSteps{
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"GaitCell";
    
    //[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"GaitCell"];

    GaitCell *cell = (GaitCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDate *now = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [gregorian components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour fromDate:now];
    [comps setHour:0];
    NSDate *today = [gregorian dateFromComponents:comps];
    
    [cell applyStyle];
    cell.totalSteps.text = @"of 12000";
    
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

    //very bad hack (just want to see how it looks
    //TODO remove the NSDate Calculations and the indexPath.row if statements
    //Refactor!!
    
    if(indexPath.row == 0){
        [cell setName:@"Step Count Today"];
        [self.stepCounter queryStepCountStartingFrom:today
                                                  to:now
                                             toQueue:[NSOperationQueue mainQueue]
                                         withHandler:^(NSInteger numberOfSteps, NSError *error) {
                                             [cell setProgress:numberOfSteps / 12000.0];
                                             
                                             //[weakSelf fadeAnimationVisible:YES];
                                             [cell setSteps:[@(numberOfSteps) stringValue]];
                                         }];

        
    }else if (indexPath.row == 1){
        [cell setName:@"Step Count Yesterday"];
        [self.stepCounter queryStepCountStartingFrom:yesterday
                                                  to:today
                                             toQueue:[NSOperationQueue mainQueue]
                                         withHandler:^(NSInteger numberOfSteps, NSError *error) {
                                             [cell setProgress:numberOfSteps / 12000.0];
                                             
                                             //[weakSelf fadeAnimationVisible:YES];
                                             [cell setSteps:[@(numberOfSteps) stringValue]];
                                         }];
    }else if (indexPath.row == 2){
        [cell setName:@"Step Count This Week"];
        [self.stepCounter queryStepCountStartingFrom:thisWeek
                                              to:now
                                         toQueue:[NSOperationQueue mainQueue]
                                         withHandler:^(NSInteger numberOfSteps, NSError *error) {
                                         [cell setProgress:numberOfSteps / (7*12000.0)];
                                         
                                         //[weakSelf fadeAnimationVisible:YES];
                                         [cell setSteps:[@(numberOfSteps) stringValue]];
                                     }];
    }else if (indexPath.row == 3){
        [cell setName:@"Step Count Last Week"];
        [self.stepCounter queryStepCountStartingFrom:lastWeek
                                                  to:thisWeek
                                             toQueue:[NSOperationQueue mainQueue]
                                         withHandler:^(NSInteger numberOfSteps, NSError *error) {
                                             [cell setProgress:numberOfSteps / (7*12000.0)];
                                             
                                             //[weakSelf fadeAnimationVisible:YES];
                                             [cell setSteps:[@(numberOfSteps) stringValue]];
                                         }];
    }else if (indexPath.row == 4){
        [cell setName:@"Step Count This Month"];
        [self.stepCounter queryStepCountStartingFrom:thisMonth
                                                  to:now
                                             toQueue:[NSOperationQueue mainQueue]
                                         withHandler:^(NSInteger numberOfSteps, NSError *error) {
                                             
                                             NSCalendar *cal = [NSCalendar currentCalendar];
                                             NSRange rng = [cal rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:[NSDate date]];
                                             NSUInteger numberOfDaysInMonth = rng.length;
                                             [cell setProgress:numberOfSteps / (numberOfDaysInMonth*12000.0)];
                                             
                                             //[weakSelf fadeAnimationVisible:YES];
                                             [cell setSteps:[@(numberOfSteps) stringValue]];
                                         }];
    }
    
    if(indexPath.row != 0){
        cell.contentView.backgroundColor = [UIColor colorWithRed:0.126 green:0.593 blue:1.000 alpha:1.000];
    }
   
    

    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
