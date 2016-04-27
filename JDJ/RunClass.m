//
//  RunClass.m
//  JDJ
//
//  Created by Mac Laren on 17/02/16.
//  Copyright © 2016 hmsphr. All rights reserved.
//

#import "RunClass.h"
#import "ConfigConst.h"
#import "AppDelegate.h"
#import <AudioToolbox/AudioServices.h>

@implementation RunClass

@synthesize stopall;

//###########################################################
// INIT

- (id) init
{
    [self clear];
    
    torchOn = NO;
    stopStrobe = NO;
    
    return [super init];
}

//###########################################################
// UTILITIES

- (BOOL) notNull: (NSObject*) obj {
    if ([obj isEqual:[NSNull null]]) return NO;
    else return (obj != nil);
}

//###########################################################
// TORCH

- (void) setTorchOn:(BOOL)isOn
{
    AVCaptureDevice* device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [device lockForConfiguration:nil];
    [device setTorchMode:isOn ? AVCaptureTorchModeOn : AVCaptureTorchModeOff];
    [device unlockForConfiguration];
}

- (void) toggleTorch{
    if (stopStrobe){
        [strobTime invalidate];
        return;
    }
    torchOn = !torchOn;
    [self setTorchOn:torchOn];
}

- (void) startFlashing{
    stopStrobe = NO;
    strobTime = [NSTimer scheduledTimerWithTimeInterval:0.1f
                                                  target:self
                                                selector:@selector(toggleTorch)
                                                userInfo:nil
                                                 repeats:YES];
}

//###########################################################
// DISPATCH RECIEVED COMMANDS

// Dispatch recieved orders : some actions can be performed directly
// but some actions must be performed by the BEAT clocked function
- (void) dispatch:(NSDictionary*) task {
    
    NSLog(@"RUN: Dispatching action %@", task);
    
    NSString* action = [task objectForKey:@"action"];
    if (![self notNull:action]) return NSLog(@"RUN: Action missing.. BREAK");
    
    NSString* engine = [task objectForKey:@"category"];
    if (![self notNull:action]) return NSLog(@"RUN: Engine missing.. BREAK");
    
    NSNumber* atTime = [task objectForKey:@"atTime"];
    if (![self notNull:atTime]) atTime = 0;
    
    NSString* payload = [task objectForKey:@"hls"];
    if (![self notNull:payload]) payload = [task objectForKey:@"url"];
    if (![self notNull:payload]) payload = @"";
    
    NSString* param1 = [task objectForKey:@"param1"];
    if (![self notNull:param1]) param1 = @"";
    
    NSString* content = [task objectForKey:@"content"];
    if (![self notNull:content]) content = @"";
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if ([action isEqualToString: @"play"])
    {
        
        if ([engine isEqualToString: @"video"] || [engine isEqualToString: @"audio"]) {
            [appDelegate.moviePlayer load: [payload copy] Mask:[engine isEqualToString: @"audio"] Time:atTime];
            playmovie = TRUE;
        }
        else if ([engine isEqualToString: @"web"]) {
            [appDelegate.webPlayer load: [payload copy] Time:atTime];
            playweb = TRUE;
        }
        else if ([engine isEqualToString: @"text"]) {
            [appDelegate.textPlayer load: [content copy] Time:atTime];
            playtext = TRUE;
        }
        else if ([engine isEqualToString: @"phone"]) {
            if ([param1 isEqualToString:@"lightOn"]) playlighton = TRUE;
            else if ([param1 isEqualToString:@"lightOff"]) playlightoff = TRUE;
            else if ([param1 isEqualToString:@"lightStrobe"]) playlightstrobe = TRUE;
            else if ([param1 isEqualToString:@"vibre"]) playvibre = TRUE;
        }
        else return NSLog(@"RUN: Unknown engine.. BREAK");
        
    }
    else if ([action isEqualToString: @"stop"]) {
        
        stopall = TRUE;
        
        
    }
    else return NSLog(@"RUN: Unknown action.. BREAK");
    
}


//###########################################################
// WORKER TIMER

// start Runner timer
-(void) start {
    timerRunner = [NSTimer scheduledTimerWithTimeInterval:TIMER_RUN
                                                   target:self
                                                 selector:@selector(beat)
                                                 userInfo:nil
                                                  repeats:YES];
}

// Runner command executed on each timer beat
- (void) beat{
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    //SCHEDULED ORDERS
    if (playmovie || playweb || playtext) stopall = TRUE;
    
    //stop movie
    if (stopall) {
        [appDelegate.moviePlayer stop];
        [appDelegate.webPlayer stop];
        [appDelegate.textPlayer stop];
        
        NSLog(@"RUN: All stop");
    }
    
    //play movie
    if (playmovie) {
        [appDelegate.moviePlayer play];
        NSLog(@"RUN: Movie play");
    }
    
    //play web
    if (playweb) {
        [appDelegate.webPlayer play];
        NSLog(@"RUN: Web play");
    }
    
    //play text
    if (playtext) {
        [appDelegate.textPlayer play];
        NSLog(@"RUN: Text play");
    }
    
    //light ON
    if (playlighton) {
        stopStrobe = YES;
        [self setTorchOn:YES];
        NSLog(@"RUN: Light ON");
    }
    
    //light OFF
    if (playlightoff) {
        stopStrobe = YES;
        [self setTorchOn:NO];
        NSLog(@"RUN: Light OFF");
    }
    
    //light OFF
    if (playlightstrobe) {
        [self startFlashing];
        NSLog(@"RUN: Light STROBE");
    }
    
    //Vibrate
    if (playvibre) {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        NSLog(@"RUN: Vibrate");
    }
    
    //IMPORTANT : if use of a new command BOOL, don't forget to register it in clear function !!!!
    [self clear];
}



//clear pennding actions
- (void) clear {
    
    playmovie = NO;
    playweb = NO;
    playtext = NO;
    stopall = NO;
    
    playlighton = NO;
    playlightoff = NO;
    playlightstrobe = NO;
    playvibre = NO;
    
}


@end
