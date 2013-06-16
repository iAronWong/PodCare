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
    NSArray *arr1,*arr2;
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
    arr2 = [[NSArray alloc]initWithObjects:@"AU",@"BR",@"CA",@"CN",@"DE",@"GB",@"FR",@"HK",@"IN",@"IE",@"IT",@"JP",@"MO",@"SG",@"TW",@"US",nil];
    arr1 = [[NSArray alloc]initWithObjects:@"Australia",@"Brazil",@"Canada",@"中国",@"Germany",@"UnitedKingdom",@"France",@"HongKong",@"India",@"Ireland",@"Italia",@"Japan",@"澳門",@"Singapore",@"台灣",@"United States",nil];

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
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return arr1.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        return arr2[row];
    }
    else
    {
        return arr1[row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        [pickerView selectRow:row inComponent:1 animated:YES];
    }
    else
    {
        [pickerView selectRow:row inComponent:0 animated:YES];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"beginCheck"]) {
        NSInteger selectedRow=[self.contryPicker selectedRowInComponent:0];
        //当前picker View选择的行号
        NSString *tmpStr = arr2[selectedRow];
        NSString *collectionId = [[NSString alloc]initWithFormat:@"%@",[self.podcastInfo objectForKey:@"collectionId"]];
        [[segue destinationViewController] setCountryString:tmpStr];
        [[segue destinationViewController] setCollectionId:collectionId];
        
    }
}
@end
