//
//  CustomCell.h
//  PodCare
//
//  Created by iAron on 13-6-10.
//  Copyright (c) 2013年 iAron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *commentCell;
@property (weak, nonatomic) IBOutlet UILabel *authorlabel;
@property (weak, nonatomic) IBOutlet UILabel *commentTitleLable;

@property (weak, nonatomic) IBOutlet UILabel *starCell;
@property (weak, nonatomic) IBOutlet UIImageView *star1;
@property (weak, nonatomic) IBOutlet UIImageView *star2;
@property (weak, nonatomic) IBOutlet UIImageView *star3;
@property (weak, nonatomic) IBOutlet UIImageView *star4;
@property (weak, nonatomic) IBOutlet UIImageView *star5;
@property (weak, nonatomic) IBOutlet UILabel *xuhao;

@end
