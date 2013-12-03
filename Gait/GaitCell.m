//
//  GaitCell.m
//  Gait
//
//  Created by Kai Kunze on 02/12/2013.
//  Copyright (c) 2013 Kai Kunze. All rights reserved.
//

#import "GaitCell.h"

@implementation GaitCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _progressView.showShadow = false;
        _progressView.progressFillColor =self.tintColor;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setSteps:(NSString *)steps
{
    _details.text = steps;
}

- (void)setName:(NSString*)name
{
    _heading.text  = name;
}

- (void)applyStyle{
    _progressView.showShadow = false;
    _progressView.progressFillColor = [UIColor whiteColor];
    _progressView.textColor = [UIColor whiteColor];
}

- (void)setProgress:(double)percentage
{
    _progressView.progress = percentage;
}


@end
