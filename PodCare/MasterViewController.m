//
//  MasterViewController.m
//  PodCare
//
//  Created by iAron on 13-6-7.
//  Copyright (c) 2013年 iAron. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"

#import "JSON.h"

@interface MasterViewController () {
    NSInteger ii;
    
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
    [self loadDataForPage:1];
    
    __weak MasterViewController *weakSelf = self;
    
    // setup pull-to-refresh
    /*[self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf insertRowAtTop];
    }];*/
    
    // setup infinite scrolling
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf insertRowAtBottom];
    }];
    //self.request.delegate = self;
    
   

    
}

- (void)insertRowAtTop {
    /*__weak MasterViewController *weakSelf = self;
    
    int64_t delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [weakSelf.tableView beginUpdates];
        [weakSelf.dataSource insertObject:[NSDate date] atIndex:0];
        [weakSelf.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
        [weakSelf.tableView endUpdates];
        
        [weakSelf.tableView.pullToRefreshView stopAnimating];
    });*/
}


- (void)insertRowAtBottom {
        
    __weak MasterViewController *weakSelf = self;
    int64_t delayInSeconds = 1.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        ii++;
        [self loadDataForPage:(ii+1)];

       
    [weakSelf.tableView.infiniteScrollingView stopAnimating];
    });
    /*__weak MasterViewController *weakSelf = self;
    
    int64_t delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [weakSelf.tableView beginUpdates];
        [weakSelf.dataSource addObject:[weakSelf.dataSource.lastObject dateByAddingTimeInterval:-90]];
        [weakSelf.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:weakSelf.dataSource.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
        [weakSelf.tableView endUpdates];
        
        [weakSelf.tableView.infiniteScrollingView stopAnimating];
    });*/
}

#pragma mark - loadData

- (void)loadDataForPage:(NSInteger)page
{
    [self.request clearDelegatesAndCancel];
    
    NSString *urlString = [NSString stringWithFormat:@"http://itunes.apple.com/%@/rss/customerreviews/id=%@/page=%@/json",self.countryString,self.collectionId,[NSString stringWithFormat:@"%d",page]];
    //http://itunes.apple.com/CN/rss/customerreviews/id=463407457/page=2/xml
    NSLog(@"%@",urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    [self setRequest:[ASIHTTPRequest requestWithURL:url]];
    [ASIHTTPRequest setShouldUpdateNetworkActivityIndicator:YES];
    self.request.delegate = self;
    [self.request startAsynchronous];
    
    

    

}


- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *str = [request responseString];
    NSLog(@"%@",str);
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
                
            }
        }
    }
    else
    {
        
    }
    [self.tableView reloadData];
    

}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSString *result = [[request error] localizedDescription];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Notice" message:result delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
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
     NSString *content = [NSString stringWithFormat:@"%@",[[self.list objectAtIndex:indexPath.row] objectForKey:@"content"]];
    cell.authorlabel.text = [[self.list objectAtIndex:indexPath.row] objectForKey:@"author"];
    cell.commentCell.text = content;
    cell.commentTitleLable.text = [[self.list objectAtIndex:indexPath.row] objectForKey:@"title"];
    cell.xuhao.text = [NSString stringWithFormat:@"%d",(indexPath.row+1)];
    NSInteger number =[[[self.list objectAtIndex:indexPath.row] objectForKey:@"star"] intValue];
    if (number == 1)
    {
        cell.star1.image = [UIImage imageNamed:@"star.png"];
        cell.star2.image = [UIImage imageNamed:@"star-empty.png"];
        cell.star3.image = [UIImage imageNamed:@"star-empty.png"];
        cell.star4.image = [UIImage imageNamed:@"star-empty.png"];
        cell.star5.image = [UIImage imageNamed:@"star-empty.png"];
    }
    else if (number == 2)
    {
        cell.star1.image = [UIImage imageNamed:@"star.png"];
        cell.star2.image = [UIImage imageNamed:@"star.png"];
        cell.star3.image = [UIImage imageNamed:@"star-empty.png"];
        cell.star4.image = [UIImage imageNamed:@"star-empty.png"];
        cell.star5.image = [UIImage imageNamed:@"star-empty.png"];
    }
    else if (number == 3)
    {
        cell.star1.image = [UIImage imageNamed:@"star.png"];
        cell.star2.image = [UIImage imageNamed:@"star.png"];
        cell.star3.image = [UIImage imageNamed:@"star.png"];
        cell.star4.image = [UIImage imageNamed:@"star-empty.png"];
        cell.star5.image = [UIImage imageNamed:@"star-empty.png"];
    }
    else if (number == 4)
    {
        cell.star1.image = [UIImage imageNamed:@"star.png"];
        cell.star2.image = [UIImage imageNamed:@"star.png"];
        cell.star3.image = [UIImage imageNamed:@"star.png"];
        cell.star4.image = [UIImage imageNamed:@"star.png"];
        cell.star5.image = [UIImage imageNamed:@"star-empty.png"];
    }
    else
    {
        cell.star1.image = [UIImage imageNamed:@"star.png"];
        cell.star2.image = [UIImage imageNamed:@"star.png"];
        cell.star3.image = [UIImage imageNamed:@"star.png"];
        cell.star4.image = [UIImage imageNamed:@"star.png"];
        cell.star5.image = [UIImage imageNamed:@"star.png"];
    }
    
    return cell;
}

- (void)setStar:(NSInteger)number 
{
    if (number == 1) {
        
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = [[self.list objectAtIndex:indexPath.row] objectForKey:@"title"];
    NSString *content = [[self.list objectAtIndex:indexPath.row] objectForKey:@"content"];
    UIAlertView *aView = [[UIAlertView alloc]initWithTitle:title message:content delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [aView show];
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
    [self.request clearDelegatesAndCancel];
    [super viewDidUnload];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.request clearDelegatesAndCancel];
}
@end
