//
//  SearchPodcastViewController.h
//  PodCare
//
//  Created by iAron on 13-6-13.
//  Copyright (c) 2013年 iAron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
@interface SearchPodcastViewController : UIViewController<ASIHTTPRequestDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
- (IBAction)startSearch:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *searchTextBox;
@property (strong,nonatomic) ASIHTTPRequest *asiRequest;
@property (strong,nonatomic) NSMutableArray *list;
@end
