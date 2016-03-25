//
//  ViewController.h
//  JDJ
//
//  Created by Mac Laren on 25/03/16.
//  Copyright © 2016 hmsphr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIPickerViewDataSource,UIPickerViewDelegate>

@property (strong, nonatomic) IBOutlet UIPickerView *picker;
@property (strong, nonatomic)          NSArray *showList;

@end
