//
//  FirstViewController.h
//  PodCare
//
//  Created by iAron on 13-6-10.
//  Copyright (c) 2013年 iAron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountryViewController : UIViewController <UIPickerViewDataSource,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *contryPicker;
@property (strong, nonatomic) NSDictionary *podcastInfo;

@end
