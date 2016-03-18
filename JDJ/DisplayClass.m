//
//  DisplayClass.m
//  JDJ
//
//  Created by Mac Laren on 04/01/16.
//  Copyright © 2016 hmsphr. All rights reserved.
//

#import "DisplayClass.h"
#import "ConfigConst.h"
#import "AppDelegate.h"

@implementation DisplayClass

@synthesize mainView;
@synthesize welcomeview, webview, movieview, textview, replayview;

//###########################################################
// DISPLAY : screen / views

- (id) init
{
    [self createViews];
    return [super init];
}

//###########################################################
//VIEWS MANAGER

//LOADER SHUTTER
-(void) loader:(BOOL)loadMe {
    
    if (loaderview) {
        if (loadMe) {
            loaderview.alpha = 1;
            [self replay:false];
        }
        else loaderview.alpha = 0;
    }
}

//MUSIC SHUTTER
-(void) music:(BOOL)musicMe {
    
    if (musicview) {
        if (musicMe) musicview.alpha = 1;
        else musicview.alpha = 0;
    }
}

//MUSIC SHUTTER
-(void) replay:(BOOL)replayMe {
    
    if (replayview) {
        if (replayMe) replayview.alpha = 1;
        else {
            replayview.alpha = 0;
            for (id viewToRemove in [replayview subviews]){
                if ([viewToRemove isMemberOfClass:[UIView class]])
                    [viewToRemove removeFromSuperview];
            }
        }
    }
}



//###########################################################
//SCREEN MANAGER

//Create EXTERNAL window on SCREEN 1
-(void) createViews {
    
    // SELECT MAIN VIEW
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    mainView = [appDelegate.window.rootViewController view];
    mainView.backgroundColor = [UIColor blackColor];
    
    //WELCOME VIEW
    welcomeview = [[UIView alloc] initWithFrame:mainView.bounds];
    welcomeview.backgroundColor = [UIColor clearColor];
    welcomeview.alpha=1;
    [mainView addSubview:welcomeview];
    
        UILabel* welcomelabel = [ [UILabel alloc ] initWithFrame:welcomeview.frame ];
        welcomelabel.textAlignment =  NSTextAlignmentCenter;
        welcomelabel.textColor = [UIColor whiteColor];
        welcomelabel.backgroundColor = [UIColor clearColor];
        welcomelabel.font = [UIFont fontWithName:@"Arial" size:(20.0)];
        welcomelabel.numberOfLines = 0;
        welcomelabel.text = @"Journal d'un seul Jour";
    
        //push to View
        [welcomeview addSubview:welcomelabel];
    
    //MOVIE PLAYER
    movieview = [[UIView alloc] initWithFrame:mainView.bounds];
    movieview.backgroundColor = [UIColor clearColor];
    movieview.alpha=1;
    [mainView addSubview:movieview];
    
        //Attach PLAYER subviews
        [movieview addSubview: appDelegate.moviePlayer.movie1view];
        appDelegate.moviePlayer.movie1view.frame = movieview.frame;
    
    //AUDIO MASK
    //Create Masks (musicview)
    musicview = [[UIView alloc] initWithFrame:mainView.bounds];
    musicview.backgroundColor = [UIColor clearColor];
    musicview.alpha=0;
    [mainView addSubview:musicview];
    
        UILabel* musiclabel = [ [UILabel alloc ] initWithFrame:musicview.frame ];
        musiclabel.textAlignment =  NSTextAlignmentCenter;
        musiclabel.textColor = [UIColor blackColor];
        musiclabel.backgroundColor = [UIColor greenColor];
        musiclabel.font = [UIFont fontWithName:@"Arial" size:(20.0)];
        musiclabel.numberOfLines = 0;
        musiclabel.text = @"Music Player";
    
        //push to View
        [musicview addSubview:musiclabel];
    
    //WEB PLAYER
    webview = [[UIView alloc] initWithFrame:mainView.bounds];
    webview.backgroundColor = [UIColor clearColor];
    webview.alpha=1;
    [mainView addSubview:webview];
    
        //Attach PLAYER subviews
        [webview addSubview: appDelegate.webPlayer.webview];
        appDelegate.webPlayer.webview.frame = webview.frame;
    
    //TEXT PLAYER
    textview = [[UIView alloc] initWithFrame:mainView.bounds];
    textview.backgroundColor = [UIColor clearColor];
    textview.alpha=1;
    [mainView addSubview:textview];
    
        //Attach PLAYER subviews
        [textview addSubview: appDelegate.textPlayer.textview];
        appDelegate.textPlayer.textview.frame = textview.frame;
    
    //LOADER MASK
    //Create Masks (loaderview)
    loaderview = [[UIView alloc] initWithFrame:mainView.bounds];
    loaderview.backgroundColor = [UIColor blueColor];
    loaderview.alpha=0;
    [mainView addSubview:loaderview];
    
    
    //REPLAY MASK
    //Create Masks (musicview)
    replayview = [[UIView alloc] initWithFrame:mainView.bounds];
    replayview.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    replayview.alpha=0;
    [mainView addSubview:replayview];
    //init View visibility
    //[self music: VIEW_MUSIC];
}


@end
