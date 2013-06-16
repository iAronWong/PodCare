//
//  FirstViewController.m
//  PodCare
//
//  Created by iAron on 13-6-10.
//  Copyright (c) 2013年 iAron. All rights reserved.
//

#import "FirstViewController.h"
#import "MasterViewController.h"

@interface FirstViewController ()
{
    NSArray *arr;
}
@end

@implementation FirstViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //self.title = @"Select A Country";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    arr = [[NSArray alloc]initWithObjects:@"JP",@"CN",@"US",nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setContryPicker:nil];
    [super viewDidUnload];
}

#pragma -- Picker View
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return arr.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return arr[row];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"beginCheck"]) {
        NSInteger selectedRow=[self.contryPicker selectedRowInComponent:0];
        //当前picker View选择的行号
        NSString *tmpStr = arr[selectedRow];
        NSString *collectionId = [[NSString alloc]initWithFormat:@"%@",[self.podcastInfo objectForKey:@"collectionId"]];
        [[segue destinationViewController] setCountryString:tmpStr];
        [[segue destinationViewController] setCollectionId:collectionId];
        
    }
}
@end
