//
//  MasterViewController.m
//  PodCare
//
//  Created by iAron on 13-6-7.
//  Copyright (c) 2013年 iAron. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"
//#import "ASIHTTPRequest.h"
#import "JSON.h"

@interface MasterViewController () {
    //NSMutableArray *_objects;
}
@end

@implementation MasterViewController
@synthesize request = _request;
@synthesize list = _list;

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;

    //UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    //self.navigationItem.rightBarButtonItem = addButton;
    self.list = [[NSMutableArray alloc]init];
    [self loadData];
    
    

    
}
#pragma mark - loadData

- (void)loadData
{
    
    NSString *urlString = [NSString stringWithFormat:@"http://itunes.apple.com/%@/rss/customerreviews/id=%@/page=1/json",self.countryString,self.collectionId];
    //http://itunes.apple.com/CN/rss/customerreviews/id=463407457/page=2/xml
    NSLog(@"%@",urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    [self setRequest:[ASIHTTPRequest requestWithURL:url]];
    //self.request.delegate = self;
    [self.request startSynchronous];
    [ASIHTTPRequest setShouldUpdateNetworkActivityIndicator:YES];
    NSLog(@"sss");
    if (self.request) {
        if ([self.request error]) {
            NSString *result = [[self.request error] localizedDescription];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:result delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        } else if ([self.request responseString]) {
            NSString *result = [self.request responseString];
            if([result isEqualToString:@"40023"] || [result isEqualToString:@"40024"])
            {
                
            }else{
                NSDictionary *mydict = [result JSONValue];
                NSDictionary *mydict1 = [mydict objectForKey:@"feed"];
                NSDictionary *mydict2 = [mydict1 objectForKey:@"entry"];
                NSArray *resultArr = (NSArray *)mydict2;
                NSMutableDictionary *tmpDict;
                for (NSInteger i = 0;i<resultArr.count;i++) {
                    if (i != 0) {
                        
                        
                        NSDictionary *item = resultArr[i];
                        NSDictionary *mydict3 = [item objectForKey:@"author"];
                        NSDictionary *mydict4 = [mydict3 objectForKey:@"name"];                        
                        NSString *author = [mydict4 objectForKey:@"label"];
                        NSDictionary *mydict8 = [mydict3 objectForKey:@"uri"];
                        NSString *reviewerURI = [mydict8 objectForKey:@"label"];
                        //NSArray *result = (NSArray *)mydict4;
                        NSDictionary *mydict5 = [item objectForKey:@"im:rating"];
                        NSString *star = [mydict5 objectForKey:@"label"];
                        NSDictionary *mydict6 = [item objectForKey:@"title"];
                        NSString *title = [mydict6 objectForKey:@"label"];
                        NSDictionary *mydict7 = [item objectForKey:@"content"];
                        NSString *content= [mydict7 objectForKey:@"label"];
                        NSLog(@"%@",content);
                        tmpDict = [[NSMutableDictionary alloc] init];
                        [tmpDict setValue:author forKey:@"author"];
                        [tmpDict setValue:star forKey:@"star"];
                        [tmpDict setValue:title forKey:@"title"];
                        [tmpDict setValue:content forKey:@"content"];
                        [tmpDict setValue:reviewerURI forKey:@"reviewerURI"];
                        [self.list addObject:tmpDict];
                        
                    }}
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

- (void)request:(ASIHTTPRequest *)request didReceiveData:(NSData *)data
{
    NSString *result = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"1:%@",result);
    char chr = data;
    
    
}


- (void)requestFinished:(ASIHTTPRequest *)request
{
    //NSString *str = [request responseString];
    //NSLog(@"%@",str);
    /*if (request)
    {
        if ([request error])
        {
            NSString *result = [[request error] localizedDescription];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:result delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
        else if ([request responseString])
        {
            NSString *result = [request responseString];
            if([result isEqualToString:@"40023"] || [result isEqualToString:@"40024"])
            {
                
            }
            else
            {
                NSLog(@"%@",[request responseString]);
                
            }
            
        }
        
    }
    NSString *str = [[NSString alloc]initWithData:[request responseData] encoding:NSUTF8StringEncoding];
     */
    //NSString *str = [[NSString alloc]initWithData:request.responseData encoding:NSUTF8StringEncoding];
    //NSLog(@"1:%@",str);
    //NSLog(@"finish :%@ ,%d" ,str,request.responseEncoding);
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSString *result = [[request error] localizedDescription];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:result delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
    
    
}

- (void)requestStarted:(ASIHTTPRequest *)request
{
    NSLog(@"Start");
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}
*/

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.list.count;//_objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    //NSDate *object = _objects[indexPath.row];
    //cell.textLabel.text = @"test";//[object description];
    //cell.contentView.backgroundColor = [UIColor colorWithRed:123 green:0 blue:123 alpha:1];
    //cell.backgroundColor = [UIColor colorWithRed:123 green:0 blue:123 alpha:1];
    //cell.c
     NSString *content = [NSString stringWithFormat:@"%d.Author:%@  Star:%@  CommentTitle:%@  Content:%@",indexPath.row+1,[[self.list objectAtIndex:indexPath.row] objectForKey:@"author"],[[self.list objectAtIndex:indexPath.row] objectForKey:@"star"],[[self.list objectAtIndex:indexPath.row] objectForKey:@"title"],[[self.list objectAtIndex:indexPath.row] objectForKey:@"content"]];
    cell.commentCell.text = content;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

/*- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = @"2011-1-1";//_objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
        [[segue destinationViewController] setReviewerURI:[[self.list objectAtIndex:indexPath.row] objectForKey:@"reviewerURI"]];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}
@end
