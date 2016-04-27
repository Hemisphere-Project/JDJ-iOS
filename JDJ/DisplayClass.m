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
#import "UIImage+animatedGIF.h"

@implementation DisplayClass

@synthesize mainView;
@synthesize replayview;

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
-(void) loader:(BOOL)show {
    
    if (loaderview) {
        if (show) {
            loaderview.alpha = 1;
            [self replay:false];
        }
        else loaderview.alpha = 0;
    }
}

//MOVIE VIEW
-(void) movie:(BOOL)show {
    
    if (movieview) {
        if (show) movieview.alpha = 1;
        else movieview.alpha = 0;
    }
}

//MUSIC SHUTTER
-(void) music:(BOOL)show {
    
    if (musicview) {
        if (show) musicview.alpha = 1;
        else musicview.alpha = 0;
    }
}

//WEB VIEW
-(void) web:(BOOL)show {
    
    if (webview) {
        if (show) webview.alpha = 1;
        else webview.alpha = 0;
    }
}

//MOVIE VIEW
-(void) text:(BOOL)show {
    
    if (textview) {
        if (show) textview.alpha = 1;
        else textview.alpha = 0;
    }
}

//MUSIC SHUTTER
-(void) replay:(BOOL)show {
    
    if (replayview) {
        if (show) replayview.alpha = 1;
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

    
    //MOVIE PLAYER
    movieview = [[UIView alloc] initWithFrame:mainView.bounds];
    movieview.backgroundColor = [UIColor blackColor];
    movieview.alpha=0;
    [mainView addSubview:movieview];
    
        //Attach PLAYER subviews
        [movieview addSubview: appDelegate.moviePlayer.movie1view];
        appDelegate.moviePlayer.movie1view.frame = movieview.frame;
    
    //AUDIO MASK
    //Create Masks (musicview)
    musicview = [[UIImageView alloc] initWithFrame:mainView.bounds];
    musicview.backgroundColor = [UIColor blackColor];
    musicview.alpha=0;
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"radio2" withExtension:@"gif"];
    musicview.image = [UIImage animatedImageWithAnimatedGIFData:[NSData dataWithContentsOfURL:url]];
    [mainView addSubview:musicview];
    
        /*UILabel* musiclabel = [ [UILabel alloc ] initWithFrame:musicview.frame ];
        musiclabel.textAlignment =  NSTextAlignmentCenter;
        musiclabel.textColor = [UIColor blackColor];
        musiclabel.backgroundColor = [UIColor greenColor];
        musiclabel.font = [UIFont fontWithName:@"Arial" size:(20.0)];
        musiclabel.numberOfLines = 0;
        musiclabel.text = @"Music Player";
    
        //push to View
        [musicview addSubview:musiclabel];*/
    
    //WEB PLAYER
    webview = [[UIView alloc] initWithFrame:mainView.bounds];
    webview.backgroundColor = [UIColor blackColor];
    webview.alpha=0;
    [mainView addSubview:webview];
    
        //Attach PLAYER subviews
        [webview addSubview: appDelegate.webPlayer.webview];
        appDelegate.webPlayer.webview.frame = webview.frame;
    
    //TEXT PLAYER
    textview = [[UIView alloc] initWithFrame:mainView.bounds];
    textview.backgroundColor = [UIColor blackColor];
    textview.alpha=0;
    [mainView addSubview:textview];
    
        //Attach PLAYER subviews
        [textview addSubview: appDelegate.textPlayer.textview];
        appDelegate.textPlayer.textview.frame = textview.frame;
    
    //LOADER MASK
    //Create Masks (loaderview)
    loaderview = [[UIView alloc] initWithFrame:mainView.bounds];
    loaderview.backgroundColor = [UIColor blackColor];
    loaderview.alpha=0;
    [mainView addSubview:loaderview];
    
        UIImage *logo = [UIImage imageNamed:@"Icon-Small-50"];
        UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, logo.size.width, logo.size.height)];
        [iv setImage:logo];
        [loaderview addSubview:iv];
        iv.center = CGPointMake(loaderview.frame.size.width  / 2,
                                     loaderview.frame.size.height / 2);
    
    
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
