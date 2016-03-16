//
//  MovieClass.h
//  JDJ
//
//  Created by Mac Laren on 04/01/16.
//  Copyright © 2016 hmsphr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@interface MovieClass : NSObject {
    
    AVPlayer* player;
    UIView *movie1view;
    
    BOOL paused;
    BOOL autoloop;
    int volume;
    BOOL mute;
    
    NSString *movieLoad;
    NSString *movieCurrent;
    BOOL audioMask;
}

@property (nonatomic,retain) UIView *movie1view;

-(void) load:(NSString*)file Mask:(BOOL)audiomask Time:(NSNumber*)atTime;
-(void) play;
-(void) stop;
-(void) start;
-(void) restart;
-(void) movieDidEnd:(NSNotification *)notification;
-(void) loopMedia:(BOOL)loop;
-(void) switchLoop;
-(BOOL) isLoop;
-(void) pause;
-(void) muteSound:(BOOL)muteMe;
-(void) setVolume:(int)vol;
-(int)  getVolume;
-(void) applyVolume;
-(void) unpause;
-(BOOL) isPause;
-(void) switchpause;
-(void) skip:(int) playbacktimeWanted;
-(NSString*) movie;
-(BOOL) isPlaying;
-(CMTime) duration;
-(CMTime) currentTime;

@end
