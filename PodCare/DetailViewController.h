//
//  DetailViewController.h
//  PodCare
//
//  Created by iAron on 13-6-7.
//  Copyright (c) 2013年 iAron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ASIWebPageRequest.h"
@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (strong,nonatomic) ASIHTTPRequest *asiRequest;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong,nonatomic) NSMutableArray *list;
@property (strong,nonatomic) NSString *reviewerURI;
@end
