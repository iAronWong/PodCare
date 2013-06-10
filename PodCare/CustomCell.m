//
//  CustomCell.m
//  PodCare
//
//  Created by iAron on 13-6-10.
//  Copyright (c) 2013年 iAron. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell
@synthesize commentCell = _commentCell;
@synthesize starCell = _starCell;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
