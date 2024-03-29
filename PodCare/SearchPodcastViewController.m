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
#import "EGOImageView.h"
#import "CountryViewController.h"

@interface SearchPodcastViewController ()
@end

@implementation SearchPodcastViewController
@synthesize asiRequest = _asiRequest;
@synthesize list = _list;

- (ASIHTTPRequest *)asiRequest
{
    if (!_asiRequest) {
        _asiRequest = [[ASIHTTPRequest alloc]init];
    }
    return _asiRequest;
}

- (NSArray *)list
{
    if (!_list) {
        _list = [[NSMutableArray alloc]init];
    }
    return _list;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.searchTextBox.delegate = self;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.searchTextBox resignFirstResponder];
    [self startSearch:nil];
    return YES;
}

- (IBAction)startSearch:(id)sender
{
    [self.searchTextBox resignFirstResponder];
    NSString *str1 = self.searchTextBox.text;
    NSString *str2 = [str1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
   
    NSString *urlString = [NSString stringWithFormat:@"http://ax.itunes.apple.com/WebObjects/MZStoreServices.woa/wa/wsSearch?country=us&entity=podcast&limit=50&term=%@",str2];
    NSLog(@"%@",urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    [self setAsiRequest:[ASIHTTPRequest requestWithURL:url]];

    [ASIHTTPRequest setShouldUpdateNetworkActivityIndicator:YES];
    self.asiRequest.delegate = self;
    [self.asiRequest startAsynchronous];
    

}
- (void)viewDidUnload {
    [self setSearchTextBox:nil];
    [super viewDidUnload];
}

#pragma -- Tableview datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.list.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *searchResultCell = [tableView dequeueReusableCellWithIdentifier:@"SearchResultCell"];
    UILabel *podcastName = (UILabel *)[searchResultCell viewWithTag:2];
    UILabel *podcastArtists = (UILabel *)[searchResultCell viewWithTag:3];
    podcastName.text = [[self.list objectAtIndex:indexPath.row] objectForKey:@"collectionName"];
    podcastArtists.text = [[NSString alloc]initWithFormat:@"Artists: %@",[[self.list objectAtIndex:indexPath.row] objectForKey:@"artistName"]];
    EGOImageView *eGOImageView = [[EGOImageView alloc]initWithPlaceholderImage:[UIImage imageNamed:@"PodCare114.png"]];
    NSURL *url = [NSURL URLWithString:[[self.list objectAtIndex:indexPath.row] objectForKey:@"artworkUrl100"]];
    eGOImageView.frame = CGRectMake(2,2,70,70);
    [searchResultCell addSubview:eGOImageView];
    eGOImageView.imageURL = url;
    
    
    return searchResultCell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showSearchDetail"]) {
        NSIndexPath *indexPath = [(UITableView *)[self.view viewWithTag:1] indexPathForSelectedRow];
        NSDictionary *tmpDict = [self.list objectAtIndex:indexPath.row];
        [[segue destinationViewController] setPodcastInfo:tmpDict];
    }
}

#pragma -- ASIHttp Delegate
- (void)requestFinished:(ASIHTTPRequest *)request
{
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
                NSArray *resultArr = (NSArray *)mydict1;
                NSMutableDictionary *tmpDict;
                self.list = [[NSMutableArray alloc]init];
                for (NSInteger i = 0;i<resultArr.count;i++) {                    
                    NSDictionary *item = resultArr[i];
                    NSString *collectionId = [item objectForKey:@"collectionId"];
                    NSString *collectionName = [item objectForKey:@"collectionName"];
                    NSString *artistName = [item objectForKey:@"artistName"];
                    NSString *podcastURL = [item objectForKey:@"collectionViewUrl"];
                    NSString *feedURL = [item objectForKey:@"feedUrl"];
                    NSString *artworkUrl100 = [item objectForKey:@"artworkUrl100"];
                    NSString *artworkUrl60 = [item objectForKey:@"artworkUrl60"];
                    NSLog(@"%@",artworkUrl100);
                    tmpDict = [[NSMutableDictionary alloc] init];
                    [tmpDict setValue:collectionId forKey:@"collectionId"];
                    [tmpDict setValue:collectionName forKey:@"collectionName"];
                    [tmpDict setValue:artistName forKey:@"artistName"];
                    [tmpDict setValue:feedURL forKey:@"feedUrl"];
                    [tmpDict setValue:podcastURL forKey:@"podcastURL"];
                    [tmpDict setValue:artworkUrl100 forKey:@"artworkUrl100"];
                    [tmpDict setValue:artworkUrl60 forKey:@"artworkUrl60"];
                    [self.list addObject:tmpDict];
                    
                }
                
            }
        }
    }else{
        
    }
    [(UITableView *)[self.view viewWithTag:1] reloadData];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSString *result = [[self.asiRequest error] localizedDescription];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Notice" message:result delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.asiRequest clearDelegatesAndCancel];
}
@end
