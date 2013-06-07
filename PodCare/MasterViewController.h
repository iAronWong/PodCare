//
//  MasterViewController.h
//  PodCare
//
//  Created by iAron on 13-6-7.
//  Copyright (c) 2013年 iAron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"

@interface MasterViewController : UITableViewController
@property (nonatomic,strong) ASIHTTPRequest *request;
@end
