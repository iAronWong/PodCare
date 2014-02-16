//
//  FirstViewController.m
//  PodCare
//
//  Created by iAron on 13-6-10.
//  Copyright (c) 2013年 iAron. All rights reserved.
//

#import "CountryViewController.h"
#import "MasterViewController.h"

@interface CountryViewController ()

@property (strong,nonatomic) NSArray *arr1;
@property (strong,nonatomic) NSArray *arr2;
@end

@implementation CountryViewController
@synthesize arr1 = _arr1;
@synthesize arr2 = _arr2;

- (NSArray *)arr1
{
    if (!_arr1) {
        _arr1 = @[@"AU",@"BR",@"CA",@"CN",@"DE",@"GB",@"FR",@"HK",@"IN",@"IE",@"IT",@"JP",@"MO",@"SG",@"TW",@"US"];
    }
    return _arr1;
}

- (NSArray *)arr2
{
    if (!_arr2) {
        _arr2 = @[@"Australia",@"Brazil",@"Canada",@"中国",@"Germany",@"UnitedKingdom",@"France",@"HongKong",@"India",@"Ireland",@"Italia",@"Japan",@"澳門",@"Singapore",@"台灣",@"United States"];
    }
    return _arr2;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

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
    return self.arr1.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        return self.arr2[row];
    }
    else
    {
        return self.arr1[row];
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
        NSString *tmpStr = self.arr1[selectedRow];
        NSString *collectionId = [[NSString alloc]initWithFormat:@"%@",[self.podcastInfo objectForKey:@"collectionId"]];
        [[segue destinationViewController] setCountryString:tmpStr];
        [[segue destinationViewController] setCollectionId:collectionId];
        
    }
}
@end
