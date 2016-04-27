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
