//
//  TextClass.m
//  JDJ
//
//  Created by Mac Laren on 16/03/16.
//  Copyright © 2016 hmsphr. All rights reserved.
//

#import "TextClass.h"
#import "ConfigConst.h"
#import "AppDelegate.h"
#import "SettingsClass.h"

@implementation TextClass

@synthesize textview;

//###########################################################
// INIT

- (id) init
{
    //Create PLAYER 1 view
    textview = [[UIView alloc] initWithFrame:CGRectMake(0,0,100,100)];
    textview.backgroundColor = [UIColor clearColor];
    textview.alpha=1;
    
    content = @"";
    
    return [super init];
}


//###########################################################
// MOVIE PLAYER CONTROLS

//LOAD
-(void) load:(NSString*)txt Time:(NSNumber*)atTime {
    NSArray* txts = [txt componentsSeparatedByString:@"@%%#"];
    NSMutableArray* txtuse = [[NSMutableArray alloc] init];
    for (id t in txts) {
        NSString* txtok = [t stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (![txtok isEqualToString:@""]) [txtuse addObject:txtok];
    }
    
    if ([txtuse count] > 0) {
        int userid = [SettingsClass getInt:@"userid" defValue:-1];
        int index = 0;
        if (userid > 0) index = userid%[txtuse count];
        txt = [txtuse objectAtIndex: index ];
    }

    content = txt;
}

//PLAY
-(void) play {
    
    [self stop];
    
    //Create UILabel
    player = [ [UILabel alloc ] initWithFrame:textview.frame ];
    player.textAlignment =  NSTextAlignmentCenter;
    player.textColor = [UIColor whiteColor];
    player.backgroundColor = [UIColor blackColor];
    player.font = [UIFont fontWithName:@"Arial" size:(20.0)];
    player.numberOfLines = 0;
    player.text = content;
    
    //push to View
    [textview addSubview:player];
    
    //show
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate.disPlay text:TRUE];
}

//STOP
-(void) stop{
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate.disPlay text:FALSE];
    
    NSArray *toRemove = [textview subviews];
    for (UIView *v in toRemove) [v removeFromSuperview];
    player = nil;
}

@end
