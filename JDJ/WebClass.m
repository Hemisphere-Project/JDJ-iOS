//
//  WebClass.m
//  JDJ
//
//  Created by Mac Laren on 16/03/16.
//  Copyright © 2016 hmsphr. All rights reserved.
//

#import "WebClass.h"
#import "ConfigConst.h"
#import "AppDelegate.h"

@implementation WebClass

@synthesize webview;

//###########################################################
// INIT

- (id) init
{
    urlLoad = nil;
    urlCurrent = nil;
    
    //Create PLAYER 1 view
    webview = [[UIView alloc] initWithFrame:CGRectMake(0,0,100,100)];
    webview.backgroundColor = [UIColor clearColor];
    webview.alpha=1;
    
    return [super init];
}


//###########################################################
// MOVIE PLAYER CONTROLS

//LOAD
-(void) load:(NSString*)url Time:(NSNumber*)atTime {
    if ([url length]>=1) {
        urlLoad = url;
    }
    
}

//PLAY
-(void) play{
    
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if (urlLoad == nil) return;
    
    //if same url just reload
    if ([urlCurrent isEqualToString:urlLoad] && player!=nil) [player reload];
    
    //else create new player
    else {
        
        // clear
        [self stop];
        
        // Create the NSURL and request
        NSURL *asset = [NSURL URLWithString:urlLoad];
        NSURLRequest *nsrequest = [NSURLRequest requestWithURL:asset];
        
        //Player
        player = [[UIWebView alloc] initWithFrame:webview.frame];
        player.scrollView.scrollEnabled = TRUE;
        player.scalesPageToFit = TRUE;
        [player loadRequest:nsrequest];
        
        //push to View
        [webview addSubview:player];
        
        urlCurrent = [urlLoad copy];
    }
}

//STOP
-(void) stop{
    NSArray *toRemove = [webview subviews];
    for (UIView *v in toRemove) [v removeFromSuperview];
    player = nil;
    urlCurrent = nil;
}

@end
