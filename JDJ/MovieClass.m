//
//  MovieClass.m
//  JDJ
//
//  Created by Mac Laren on 04/01/16.
//  Copyright © 2016 hmsphr. All rights reserved.
//

#import "MovieClass.h"
#import "ConfigConst.h"
#import "AppDelegate.h"

@implementation MovieClass

@synthesize movie1view, movie2view;

//###########################################################
// INIT

- (id) init
{
    use1 = YES;
    
    movieLoad = nil;
    movieCurrent = nil;
    
    //Create PLAYER 1 view
    movie1view = [[UIView alloc] initWithFrame:CGRectMake(0,0,100,100)];
    movie1view.backgroundColor = [UIColor clearColor];
    movie1view.alpha=1;
    
    [self loopMedia:FALSE];
    [self setVolume:100];
    [self muteSound:FALSE];
    
    return [super init];
}


//###########################################################
// MOVIE PLAYER CONTROLS

//LOAD
-(void) load:(NSString*)file {
    if ([file length]>=1) movieLoad = file;
}

//PLAY
-(void) play{
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    //if ([[appDelegate.disPlay resolution]  isEqual: @"noscreen"]) return;
    if (movieLoad == nil) return;
    
    if ([movieLoad isEqualToString:@"*"] && (movieCurrent != nil)) {
        movieLoad = [movieCurrent copy];
        return;
    }
    
    if ([movieLoad isEqualToString:@"stop"]) {
        [self stop];
        return;
    }
    
    //if same movie just rewind
    if ([movieCurrent isEqualToString:movieLoad]) [self restart];
    
    //else create new player
    else {
        
        // Create the AVAsset
        AVAsset *asset = [AVAsset assetWithURL:[appDelegate.filesManager url:movieLoad]];
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset];
        
        //Player
        player = [AVPlayer playerWithPlayerItem:playerItem];
        player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
        
        //auto-loop
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(movieDidEnd:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:[player currentItem]];
        
        //Layer
        AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:player];
        
        //select View
        UIView *view;
        if (use1) view = movie1view;
        else view = movie2view;
        
        //Attach Layer
        layer.frame = movie1view.layer.bounds;
        view.layer.sublayers = nil;
        [view.layer addSublayer:layer];
        
        //bring to front
        [appDelegate.disPlay.movieview bringSubviewToFront:view];
        
        movieCurrent = [movieLoad copy];
        
        //let's play
        [self start];
        use1 = !use1;
        
        //Releaser of previous player
        if (Releaser != nil) [Releaser invalidate];
        Releaser = [NSTimer scheduledTimerWithTimeInterval:TIMER_RELMOVIE
                                                    target:self selector:@selector(releaseMovie) userInfo:nil repeats:NO];
        
        
        [appDelegate.disPlay music:[appDelegate.disPlay musiced]];
    }
}

//MOVIE END OBSEREVER (auto loop)
- (void)movieDidEnd:(NSNotification *)notification {
    if (autoloop)
    {
        AVPlayerItem *p = [notification object];
        [p seekToTime:kCMTimeZero];
    }
    else [self stop];
}

//START
-(void) start {
    
    if (![self isPlaying]) return;
    
    [player play];
    paused = NO;
}

//RESTART (from beginning)
-(void) restart {
    [self skip:0];
    [self start];
}

//STOP
-(void) stop{
    
    movie1view.layer.sublayers = nil;
    movie2view.layer.sublayers = nil;
    
    paused = NO;
    
    if ([movieLoad isEqualToString:@"*"] && (movieCurrent != nil)) movieLoad = [movieCurrent copy];
    movieCurrent = nil;
    
}

//LOOP
-(void) loopMedia:(BOOL)loop{
    autoloop = loop;
}

//LOOP
-(BOOL) isLoop{
    return autoloop;
}

//SWITCH LOOP
-(void) switchLoop{
    [self loopMedia:!autoloop];
}

//MUTE
-(void) muteSound:(BOOL)muteMe {
    mute = muteMe;
    [self applyVolume];
}

//VOLUME
-(void) setVolume:(int)vol{
    volume = vol;
    [self applyVolume];
}

//VOLUME
-(int) getVolume{
    return volume;
}

//VOLUME
-(void) applyVolume{
    
    if (![self isPlaying]) return;
    
    float vol;
    if (mute) vol = 0.0;
    else vol = volume/100.0;
    
    if ([player respondsToSelector:@selector(setVolume:)]) {
        player.volume = vol;
    }else {
        NSArray *audioTracks = player.currentItem.asset.tracks;
        
        // Mute all the audio tracks
        NSMutableArray *allAudioParams = [NSMutableArray array];
        for (AVAssetTrack *track in audioTracks) {
            AVMutableAudioMixInputParameters *audioInputParams =[AVMutableAudioMixInputParameters audioMixInputParameters];
            [audioInputParams setVolume:vol atTime:kCMTimeZero];
            [audioInputParams setTrackID:[track trackID]];
            [allAudioParams addObject:audioInputParams];
        }
        AVMutableAudioMix *audioMix = [AVMutableAudioMix audioMix];
        [audioMix setInputParameters:allAudioParams];
        
        [player.currentItem setAudioMix:audioMix];
    }
}

//PAUSE
-(void) pause{
    
    if (![self isPlaying]) return;
    
    [player pause];
    paused = YES;
}

//UNPAUSE
-(void) unpause{
    [self start];
}

-(BOOL) isPause{
    return paused;
}

//SWITCH PAUSE
-(void) switchpause{
    if (paused) [self unpause];
    else [self pause];
}

//SKIP
-(void) skip:(int) playbacktimeWanted{
    
    if (![self isPlaying]) return;
    
    if ( CMTimeGetSeconds(player.currentItem.duration) > (playbacktimeWanted/1000)) {
        //TODO Optimize seekToTime, and seekToTime 0 (rewind)
        [player seekToTime:CMTimeMake(playbacktimeWanted, 1000) toleranceBefore: kCMTimeZero toleranceAfter: kCMTimeZero];
        [self start];
    }
    else {
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate.runMachine dispatch:@"/stopmovie"];
        //TODO REPLACE with [self stop]; but carefully   - direct call from dispatcher : stop is not allowed !
    }
}

//CURRENT MOVIE
-(NSString*) movie{
    if ([self isPlaying]) return movieCurrent;
    else return nil;
}


//IS PLAYING
-(BOOL) isPlaying{
    return (movieCurrent != nil);
}

//DURATION
-(CMTime) duration{
    if ([self isPlaying]) return [[player currentItem] duration];
    else return CMTimeMakeWithSeconds(0, 1);
}

//CURRENT TIME
-(CMTime) currentTime{
    if ([self isPlaying]) return [player currentTime];
    else return CMTimeMakeWithSeconds(0, 1);
}

//RELEASE PLAYER
- (void) releaseMovie {
    
    if (use1) movie1view.layer.sublayers = nil;
    else movie2view.layer.sublayers = nil;
    
    Releaser = nil;
}

@end
