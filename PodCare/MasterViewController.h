//
//  MasterViewController.h
//  PodCare
//
//  Created by iAron on 13-6-7.
//  Copyright (c) 2013年 iAron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
//@class ASIHTTPRequest;
#import "CustomCell.h"
#import "SVPullToRefresh.h"
@interface MasterViewController : UITableViewController<ASIHTTPRequestDelegate>
@property (nonatomic,strong) ASIHTTPRequest *request;
@property (nonatomic,strong) NSData *receivedData;
@property (nonatomic,strong) NSMutableArray *list;
@property (nonatomic,strong) NSString *countryString;
@property (nonatomic,strong) NSString *collectionId;
@end
