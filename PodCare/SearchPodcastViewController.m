//
//  SearchPodcastViewController.m
//  PodCare
//
//  Created by iAron on 13-6-13.
//  Copyright (c) 2013年 iAron. All rights reserved.
//

#import "SearchPodcastViewController.h"
#import "ASIHTTPRequest.h"
#import "SBJson.h"
@interface SearchPodcastViewController ()
{
    
}
@end

@implementation SearchPodcastViewController
@synthesize asiRequest = _asiRequest;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.asiRequest.delegate = self;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startSearch:(id)sender
{
    NSString *str = self.searchTextBox.text;
    //NSStringEncoding enc =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *str2 = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
   
    NSString *urlString = [NSString stringWithFormat:@"http://ax.itunes.apple.com/WebObjects/MZStoreServices.woa/wa/wsSearch?country=cn&entity=podcast&limit=50&term=%@",str2];
    NSLog(@"%@",urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    [self setAsiRequest:[ASIHTTPRequest requestWithURL:url]];
    //self.request.delegate = self;
    //self.asiRequest set
    [self.asiRequest startSynchronous];
    [ASIHTTPRequest setShouldUpdateNetworkActivityIndicator:YES];
    NSLog(@"sss");
    if (self.asiRequest) {
        if ([self.asiRequest error]) {
            NSString *result = [[self.asiRequest error] localizedDescription];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:result delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        } else if ([self.asiRequest responseString]) {
            NSString *result = [self.asiRequest responseString];
            if([result isEqualToString:@"40023"] || [result isEqualToString:@"40024"])
            {
                
            }else{
                NSDictionary *mydict = [result JSONValue];
                NSDictionary *mydict1 = [mydict objectForKey:@"results"];
                //NSDictionary *mydict2 = [mydict1 objectForKey:@"entry"];
                NSArray *resultArr = (NSArray *)mydict1;
                NSMutableDictionary *tmpDict;
                for (NSInteger i = 0;i<resultArr.count;i++) {

                        NSDictionary *item = resultArr[i];
                        NSString *collectionId = [item objectForKey:@"collectionId"];
                        NSString *collectionName = [item objectForKey:@"collectionName"];
                        NSString *artistName = [item objectForKey:@"artistName"];
                        NSString *podcastURL = [item objectForKey:@"collectionViewUrl"];
                        NSString *feedURL = [item objectForKey:@"feedUrl"];
                        NSString *artworkUrl100 = [item objectForKey:@"artworkUrl100"];
                        NSLog(@"%@",feedURL);
                        tmpDict = [[NSMutableDictionary alloc] init];
                        [tmpDict setValue:collectionId forKey:@"collectionId"];
                        [tmpDict setValue:collectionName forKey:@"collectionName"];
                        [tmpDict setValue:artistName forKey:@"artistName"];
                        [tmpDict setValue:podcastURL forKey:@"podcastURL"];
                        [tmpDict setValue:artworkUrl100 forKey:@"artworkUrl100"];
                        [self.list addObject:tmpDict];
                        
                    }
                /*NSArray *resultArr = (NSArray *)mydict1;
                 //NSArray *resultArr = (NSArray *)mydict;
                 for (NSDictionary *item in resultArr) {
                 tmpDict = [[NSMutableDictionary alloc] init];
                 [tmpDict setValue:[item objectForKey:@"city_en"] forKey:@"city_en"];
                 //[tmpDict setValue:[item objectForKey:@"x_pic"] forKey:@"x_pic"];
                 [self.list addObject:tmpDict];
                 
                 }*/
            }
        }
    }else{
        
    }
    
    
    

}
- (void)viewDidUnload {
    [self setSearchTextBox:nil];
    [super viewDidUnload];
}

#pragma -- Tableview datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *searchResultCell = [tableView dequeueReusableCellWithIdentifier:@"SearchResultCell"];
    searchResultCell.textLabel.text = @"OK";
    return searchResultCell;
}
@end
