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
@synthesize musicview, movieview;

//###########################################################
// DISPLAY : screen / views

- (id) init
{
    screenResolution = @"noscreen";
    
    return [super init];
}

//###########################################################
//VIEWS MANAGER

//MUSIC SHUTTER
-(void) music:(BOOL)musicMe {
    
    if (musicview) {
        if (musicMe) musicview.alpha = 1;
        else musicview.alpha = 0;
    }
}

-(BOOL) musiced {
    return (musicview.alpha == 1);
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
    backField.backgroundColor = [UIColor yellowColor];
    [_secondWindow addSubview:backField];
    
    //MOVIE PLAYER
    //Create Masks (movieview)
    movieview = [[UIView alloc] initWithFrame:secondScreen.bounds];
    movieview.backgroundColor = [UIColor clearColor];
    movieview.alpha=1;
    [_secondWindow addSubview:movieview];
    
    //Attach PLAYER subviews
    [movieview addSubview: appDelegate.moviePlayer.movie1view];
    [movieview addSubview: appDelegate.moviePlayer.movie2view];
    
    //Resize PLAYER subviews
    CGRect frame = movieview.frame;
    appDelegate.moviePlayer.movie1view.frame = frame;
    appDelegate.moviePlayer.movie2view.frame = frame;
    
    //Create Masks (musicview)
    musicview = [[UIView alloc] initWithFrame:secondScreen.bounds];
    musicview.backgroundColor = [UIColor yellowColor];
    musicview.alpha=0;
    [_secondWindow addSubview:musicview];
    
    // Center a label in the view.
    NSString*    noContentString = [NSString stringWithFormat:@" "];
    CGSize        stringSize = [noContentString sizeWithFont:[UIFont systemFontOfSize:18]];
    CGRect        labelSize = CGRectMake((secondScreen.bounds.size.width - stringSize.width) / 2.0,
                                         (secondScreen.bounds.size.height - stringSize.height) / 2.0,
                                         stringSize.width, stringSize.height);
    UILabel*    noContentLabel = [[UILabel alloc] initWithFrame:labelSize];
    noContentLabel.text = noContentString;
    noContentLabel.font = [UIFont systemFontOfSize:18];
    [musicview addSubview:noContentLabel];
    
    // Go ahead and show the window.
    _secondWindow.hidden = NO;
    
    //init View visibility
    [self music: VIEW_MUSIC];
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
