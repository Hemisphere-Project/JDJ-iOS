//
//  CheckerClass.m
//  JDJ
//
//  Created by Mac Laren on 16/03/16.
//  Copyright © 2016 hmsphr. All rights reserved.
//

#import "CheckerClass.h"
#import "ConfigConst.h"
#import "AppDelegate.h"

@implementation CheckerClass

//###########################################################
// INIT

- (id) init
{
    lastSync = 1000;
    lastTab = 0;
    timeHere = 0;
    return [super init];
}

//###########################################################
// CHECKER LOOP

// start Runner timer
-(void) start {
    
    //LAUNCH BEAT REPEAT
    timerChecker = [NSTimer scheduledTimerWithTimeInterval:TIMER_CHECK
                                                    target:self
                                                  selector:@selector(beat)
                                                  userInfo:nil
                                                   repeats:YES];
}

// Runner command executed on each timer beat
- (void) beat{
    
    
    
    //CHECK IF WIFI CONNECTED
    //[appDelegate.interFace infoIP: [appDelegate.comPort getIPAddress]];
    
    //CHECK SERVER CONNECTION
    //NSString *serverIPstate = [appDelegate.comPort serverState];
    //[appDelegate.interFace infoServer: serverIPstate];
    
    //RE-ASK IP REGIE WHEN BROADCAST MODE
    /*if ([serverIPstate isEqualToString:@"broadcast"]) {
        if (TIMER_CHECK_BROAD > 0) broadcastRefresh++;
        if (broadcastRefresh > TIMER_CHECK_BROAD) {
            [appDelegate.comPort sendInfo];
            [appDelegate.comPort sendAskip];
            broadcastRefresh = 0;
        }
    }*/
    
    //UPDATE LINK STATE
    /*if (lastSync > 4)
    {
        [appDelegate.interFace infoLink: @"nolink"];
        [appDelegate.comPort sendInfo];
        //NSLog(@"nolink send sos");
    }
    else [appDelegate.interFace infoLink: @"OK"];
    if (lastSync < 1000) lastSync++; //security increaser
    
    //UPDATE PLAYER STATE
    if ([appDelegate.live2Player isLive]) {
        [appDelegate.interFace infoState:@"live"];
        [appDelegate.interFace infoMovie:@""];
    }
    else if ([appDelegate.moviePlayer isPlaying]) {
        if(appDelegate.interFace.mode==MANU)[appDelegate.interFace infoState:@"play manu"];
        if(appDelegate.interFace.mode==AUTO)[appDelegate.interFace infoState:@"play auto"];
        [appDelegate.interFace infoMovie:[appDelegate.moviePlayer movie]];
    }
    else {
        [appDelegate.interFace infoState:@"wait"];
        [appDelegate.interFace infoMovie:@""];
    }
    
    //UPDATE RECORDER STATE
    [appDelegate.interFace infoRec:[appDelegate.recOrder isRecording]];
    
    //UPDATE CTRL STATE
    if ([appDelegate.disPlay faded]) [appDelegate.interFace infoCtrl:@"faded"];
    else [appDelegate.interFace infoCtrl:@""];
    
    //UPDATE MOVIE SCROLLER
    if ([appDelegate.moviePlayer isPlaying])
        [appDelegate.interFace Bslide:[appDelegate.moviePlayer duration]:[appDelegate.moviePlayer currentTime]];
*/

    
}

- (void) userAct : (int) tim {
    //on manual action reset timeHere
    timeHere = tim;
}

- (void) syncAct {
    //on manual action reset timeHere
    lastSync = 0;
}

@end
