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

@implementation RunClass

//###########################################################
// INIT

- (id) init
{
    [self clear];
    return [super init];
}

//###########################################################
// UTILITIES

- (BOOL) notNull: (NSObject*) obj {
    if ([obj isEqual:[NSNull null]]) return NO;
    else return (obj != nil);
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
    if (playmovie || playweb || playtext) {
        appDelegate.disPlay.welcomeview.alpha = 0;
        stopall = TRUE;
    }
    else if (stopall) appDelegate.disPlay.welcomeview.alpha = 1;
    
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
    
    //IMPORTANT : if use of a new command BOOL, don't forget to register it in clear function !!!!
    [self clear];
}



//clear pennding actions
- (void) clear {
    
    playmovie = NO;
    playweb = NO;
    playtext = NO;
    stopall = NO;
    
}


@end
