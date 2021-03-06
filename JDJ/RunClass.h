//
//  RunClass.h
//  JDJ
//
//  Created by Mac Laren on 17/02/16.
//  Copyright © 2016 hmsphr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RunClass : NSObject {
    
    NSTimer *timerRunner;
    
    BOOL playmovie;
    BOOL playweb;
    BOOL playtext;
    BOOL stopall;
    BOOL playlighton;
    BOOL playlightoff;
    BOOL playlightstrobe;
    BOOL playvibre;
    
    BOOL torchOn;
    BOOL stopStrobe;
    NSTimer *strobTime;

}

@property BOOL stopall;

- (void) dispatch:(NSDictionary*) task;

- (void) start;
- (void) beat;
- (void) clear;

@end
