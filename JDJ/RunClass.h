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
    BOOL stopmovie;
    
    BOOL gomute;
    BOOL gounmute;
    BOOL govolume;
    int  newvolume;
    
    BOOL gomessage;

    NSString* message;
}

- (void) dispatch:(NSString*) rcvCommand;

- (void) start;
- (void) beat;
- (void) clear;

@end
