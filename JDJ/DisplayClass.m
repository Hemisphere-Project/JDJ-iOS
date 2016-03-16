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

@synthesize _secondWindow,screenResolution;
@synthesize webview, movieview, textview;

//###########################################################
// DISPLAY : screen / views

- (id) init
{
    screenResolution = @"noscreen";
    
    return [super init];
}

//###########################################################
//VIEWS MANAGER

//LOADER SHUTTER
-(void) loader:(BOOL)loadMe {
    
    if (loaderview) {
        if (loadMe) loaderview.alpha = 1;
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


//###########################################################
//SCREEN MANAGER

//get resolution
- (NSString*) resolution {
    return screenResolution;
}

//Create EXTERNAL window on SCREEN 1
-(void) createWindow {
    
    if ([[UIScreen screens] count] < 2) return;
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    //select Screen
    UIScreen*   secondScreen = [[UIScreen screens] objectAtIndex: 1];
    
    //create WINDOW (full sized for second screen)
    _secondWindow = [[UIWindow alloc] initWithFrame:secondScreen.bounds];
    
    //ATTACH TO CURRENT ACTIVE SCREEN
    _secondWindow.screen = secondScreen;
    
    // Add a black background to the window
    UIView* backField = [[UIView alloc] initWithFrame:secondScreen.bounds];
    backField.backgroundColor = [UIColor blackColor];
    [_secondWindow addSubview:backField];
    
    //MOVIE PLAYER
    movieview = [[UIView alloc] initWithFrame:secondScreen.bounds];
    movieview.backgroundColor = [UIColor clearColor];
    movieview.alpha=1;
    [_secondWindow addSubview:movieview];
    
        //Attach PLAYER subviews
        [movieview addSubview: appDelegate.moviePlayer.movie1view];
    
        //Resize PLAYER subviews
        CGRect frame = movieview.frame;
        appDelegate.moviePlayer.movie1view.frame = frame;
    
    //AUDIO MASK
    //Create Masks (musicview)
    musicview = [[UIView alloc] initWithFrame:secondScreen.bounds];
    musicview.backgroundColor = [UIColor greenColor];
    musicview.alpha=0;
    [_secondWindow addSubview:musicview];
    
    //WEB PLAYER
    webview = [[UIView alloc] initWithFrame:secondScreen.bounds];
    webview.backgroundColor = [UIColor clearColor];
    webview.alpha=1;
    [_secondWindow addSubview:webview];
    
        //Attach PLAYER subviews
        [webview addSubview: appDelegate.webPlayer.webview];
    
        //Resize PLAYER subviews
        CGRect frame2 = webview.frame;
        appDelegate.webPlayer.webview.frame = frame2;
    
    //TEXT PLAYER
    textview = [[UIView alloc] initWithFrame:secondScreen.bounds];
    textview.backgroundColor = [UIColor clearColor];
    textview.alpha=1;
    [_secondWindow addSubview:textview];
    
        //Attach PLAYER subviews
        [textview addSubview: appDelegate.textPlayer.textview];
    
        //Resize PLAYER subviews
        CGRect frame3 = textview.frame;
        appDelegate.textPlayer.textview.frame = frame3;
    
    //LOADER MASK
    //Create Masks (loaderview)
    loaderview = [[UIView alloc] initWithFrame:secondScreen.bounds];
    loaderview.backgroundColor = [UIColor blueColor];
    loaderview.alpha=0;
    [_secondWindow addSubview:loaderview];
    
    
    // Go ahead and show the window.
    _secondWindow.hidden = NO;
    
    //init View visibility
    //[self music: VIEW_MUSIC];
}

//check screen
- (BOOL) checkScreen{
    
    //last known resolution
    NSString* newRes = [screenResolution copy];
    
    
    //external screen plugged
    if ([[UIScreen screens] count] > 1)
    {
        //new external screen
        if ([newRes isEqualToString: @"noscreen"])
        {
            //initialize window
            if (!_secondWindow) [self createWindow];
            
            //get resolution
            newRes =  [NSString stringWithFormat: @"%.0f x %.0f",_secondWindow.bounds.size.width,_secondWindow.bounds.size.height];
        }
    }
    //external screen removed
    else if (![newRes isEqualToString: @"noscreen"]) newRes = @"noscreen";
    
    //if resolution changed, send TRUE
    if (![newRes isEqualToString: screenResolution]) {
        screenResolution = [newRes copy];
        return TRUE;
    }
    
    return FALSE;
}


@end
