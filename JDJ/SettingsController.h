//
//  SettingsController.h
//  JDJ
//
//  Created by Mac Laren on 01/04/16.
//  Copyright © 2016 hmsphr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsController : UIViewController <UIPickerViewDataSource,UIPickerViewDelegate>

@property (strong, nonatomic) IBOutlet UIPickerView *picker;
@property (strong, nonatomic)          NSArray *showList;

@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextView *disclaimer;

- (IBAction)SettingsOK:(UIButton *)sender;

@end
