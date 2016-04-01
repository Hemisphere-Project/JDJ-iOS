//
//  SettingsController.m
//  JDJ
//
//  Created by Mac Laren on 01/04/16.
//  Copyright © 2016 hmsphr. All rights reserved.
//

#import "SettingsController.h"
#import "AppDelegate.h"
#import "SettingsClass.h"

@interface SettingsController ()

@end

@implementation SettingsController

- (BOOL) notNull: (NSObject*) obj {
    if ([obj isEqual:[NSNull null]]) return NO;
    else return (obj != nil);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Stop edit when tap outside
    UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc]
                                      initWithTarget:self action:@selector(handleSingleTap:)];
    tapper.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapper];
    
    //Show list
    NSArray* sList = [SettingsClass getArray:@"showlist"];
    if ([self notNull:sList]) self.showList = sList;
    else {
        NSDictionary *eList = @{
                                @"id" : [NSNumber numberWithInt:-1],
                                @"date" : @"",
                                @"place" : @"Aucun spectacle disponible"
                                };
        self.showList = [[NSArray alloc] initWithObjects:eList, nil];
    }
    
    //Selected show
    NSDictionary* myEvent = [SettingsClass getDict:@"event"];
    if ([self notNull:myEvent] && [self.showList count] > 0) {
        int row = 0;
        for (id obj in self.showList) {
            if ([obj[@"id"] intValue] == [myEvent[@"id"] intValue]) {
                [self.picker reloadAllComponents];
                [self.picker selectRow:row inComponent:0 animated:YES];
            }
            row++;
        }
    }
    
    // Fill phone
    self.phoneField.text = [SettingsClass getString:@"phone"];
    
    // Display error
    NSString* error = [SettingsClass getString:@"error"];
    if ([error length] > 0) {
        self.disclaimer.text = error;
        self.disclaimer.textColor = [UIColor redColor];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleSingleTap:(UITapGestureRecognizer *) sender
{
    [self.view endEditing:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{
    return [self.showList count];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc] init];
    label.text = [self.showList objectAtIndex:row][@"place"];
    label.text = [label.text stringByAppendingString:@" - "];
    label.text = [label.text stringByAppendingString:[self.showList objectAtIndex:row][@"date"]];
    label.textColor = [UIColor whiteColor];
    label.font=[label.font fontWithSize:22];
    [label setTextAlignment:NSTextAlignmentCenter];
    return label;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row  inComponent:(NSInteger)component
{
    
}

- (IBAction)SettingsOK:(UIButton *)sender {
    
    //Do Register
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSInteger row = [self.picker selectedRowInComponent:0];
    NSNumber *showid = [self.showList objectAtIndex:row][@"id"];
    int selectedid = -1;
    if ([self notNull:showid]) selectedid = [showid integerValue];
    [appDelegate.comPort doRegister:self.phoneField.text ShowID:selectedid];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
