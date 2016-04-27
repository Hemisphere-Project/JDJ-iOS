//
//  ViewController.h
//  JDJ
//
//  Created by Mac Laren on 25/03/16.
//  Copyright © 2016 hmsphr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *SettingsBtn;
@property (weak, nonatomic) IBOutlet UITextField *versionNum;
@property (weak, nonatomic) IBOutlet UIView *updateView;
@property (weak, nonatomic) IBOutlet UITextField *updateText;
@property (weak, nonatomic) IBOutlet UITextView *textCom;

- (void)updateAvailable:(BOOL)switcher;
- (void)infoCom:(NSString*)info;
- (IBAction)gotoJournal:(id)sender;
- (IBAction)gotoTeam:(id)sender;
- (IBAction)gotoFunding:(id)sender;

@end
