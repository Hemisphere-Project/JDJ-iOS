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
// DISPATCH RECIEVED COMMANDS

// Dispatch recieved orders : some actions can be performed directly
// but some actions must be performed by the BEAT clocked function
- (void) dispatch:(NSString*) rcvCommand {
    //NSLog(rcvCommand);
    if (rcvCommand == nil) return;
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSArray *pieces = [rcvCommand componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([pieces count] < 1) return;
    
    NSString *command = [pieces objectAtIndex:0];
    
    NSMutableArray *orders;
    orders = [NSMutableArray arrayWithArray: pieces];
    [orders removeObjectAtIndex:0]; //remove command
    
    //DISPLAY MESSAGE
    if ([command isEqualToString: @"/message"]) {
        if ([orders count] >= 1)
        {
            message = [[orders componentsJoinedByString:@" "] copy];
            gomessage=YES;
        }
    }
        
    //LOAD & PLAY MOVIE
    else if (([command isEqualToString: @"/loadmovie"]) || ([command isEqualToString: @"/playmovie"]) || ([command isEqualToString: @"/playstream"])) {
        
        if ([orders count] >= 1) [appDelegate.moviePlayer load: [[orders componentsJoinedByString:@" "] copy]];
        else NSLog(@"dry playmovie");
        playmovie = ([command isEqualToString: @"/playmovie"] || [command isEqualToString: @"/playstream"]);
    }
    
    //SKIP AT TIME
    else if ([command isEqualToString: @"/attime"]) {
        if ([orders count] >= 1) [appDelegate.moviePlayer skip:[[orders objectAtIndex:0] intValue]];
    }
    
    //STOP MOVIE
    else if ([command isEqualToString: @"/stopmovie"]) {
        stopmovie = YES;
    }
    
    //LOOP
    else if ([command isEqualToString: @"/loop"]) {
        [appDelegate.moviePlayer loopMedia:TRUE];
    }
    
    //UNPAUSE
    else if ([command isEqualToString: @"/unloop"]) {
        [appDelegate.moviePlayer loopMedia:FALSE];
    }
    
    //PAUSE
    else if ([command isEqualToString: @"/pause"]) {
        [appDelegate.moviePlayer pause];
    }
    
    //UNPAUSE
    else if ([command isEqualToString: @"/unpause"]) {
        [appDelegate.moviePlayer unpause];
    }
    
    //MUTE
    else if ([command isEqualToString: @"/mute"]) gomute = YES;
    
    //UNMUTE
    else if ([command isEqualToString: @"/unmute"]) gounmute = YES;
    
    //UNKNOW ORDER
    //else [appDelegate.comPort sendError:command];
    
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
    //play movie
    if (playmovie) [appDelegate.moviePlayer play];
    
    //stop movie
    if (stopmovie) [appDelegate.moviePlayer stop];
    
    //volume
    //if (gomute) [appDelegate.disPlay mute:YES];
    //if (gounmute) [appDelegate.disPlay mute:NO];
    
    //don't execute video related order if no screen
    //if (![[appDelegate.disPlay resolution]  isEqual: @"noscreen"])
    
    //IMPORTANT : if use of a new command BOOL, don't forget to register it in clear function !!!!
    [self clear];
}

//clear pennding actions
- (void) clear {
    
    playmovie = NO;
    stopmovie = NO;
    
    gomute = NO;
    gounmute = NO;
    govolume = NO;
    newvolume = 0;
    gomessage = NO;
}


@end
