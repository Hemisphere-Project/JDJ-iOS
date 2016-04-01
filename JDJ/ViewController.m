//
//  ViewController.m
//  JDJ
//
//  Created by Mac Laren on 25/03/16.
//  Copyright © 2016 hmsphr. All rights reserved.
//

#import "ViewController.h"
#import "ConfigConst.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.versionNum.text = APP_VERSION;
    [self updateAvailable:FALSE];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)goBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)updateAvailable:(BOOL)switcher {
    if (switcher) {
        self.updateText.text = @"Une mise à jour est disponible sur l'App Store..";
        self.updateView.backgroundColor = [UIColor colorWithRed:0.882 green:0.251 blue:0.063 alpha:1];
    }
    else {
        self.updateText.text = @"";
        self.updateView.backgroundColor = [UIColor blackColor];
    }
}





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
