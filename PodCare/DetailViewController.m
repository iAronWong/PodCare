//
//  DetailViewController.m
//  PodCare
//
//  Created by iAron on 13-6-7.
//  Copyright (c) 2013年 iAron. All rights reserved.
//

#import "DetailViewController.h"
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"
@interface DetailViewController ()
- (void)configureView;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
    NSString *urlString = self.reviewerURI;
    NSLog(@"%@",urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    [self setAsiRequest:[ASIHTTPRequest requestWithURL:url]];
    [self.asiRequest setUserAgentString:@"iTunes/11.0.3 (Macintosh; OS X 10.8.2) AppleWebKit/536.26.14"];
    [ASIHTTPRequest setShouldUpdateNetworkActivityIndicator:YES];
    
    [self.asiRequest startAsynchronous];
    self.asiRequest.delegate = self;
   
    
}
#pragma -- ASIHttp Delegate
- (void)requestFinished:(ASIHTTPRequest *)request
{

    [self.webView loadHTMLString:self.asiRequest.responseString baseURL:self.asiRequest.url];
    NSLog(@"sss");

}

- (void)requestFailed:(ASIHTTPRequest *)request
{
   /* NSString *result = [[self.asiRequest error] localizedDescription];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Notice" message:result delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];*/
   // something is wrong here;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setWebView:nil];
    [super viewDidUnload];
}
@end
