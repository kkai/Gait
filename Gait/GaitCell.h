//
//  GaitCell.h
//  Gait
//
//  Created by Kai Kunze on 02/12/2013.
//  Copyright (c) 2013 Kai Kunze. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PICircularProgressView.h"

@interface GaitCell : UITableViewCell

@property (weak, nonatomic) IBOutlet PICircularProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *heading;
@property (weak, nonatomic) IBOutlet UILabel *details;
@property (weak, nonatomic) IBOutlet UILabel *totalSteps;


- (void)setName:(NSString*)name;
- (void)setSteps:(NSString*)steps;
- (void)applyStyle;
- (void)setProgress:(double)percentage;

@end
