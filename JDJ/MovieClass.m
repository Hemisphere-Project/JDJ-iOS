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

@synthesize movie1view;

//###########################################################
// INIT

- (id) init
{
    movieLoad = nil;
    movieCurrent = nil;
    audioMask = FALSE;
    playAtTime = 0;
    
    //Create PLAYER 1 view
    movie1view = [[UIView alloc] initWithFrame:CGRectMake(0,0,100,100)];
    movie1view.backgroundColor = [UIColor clearColor];
    movie1view.alpha=1;
    
    [self setVolume:100];
    [self muteSound:FALSE];
    
    return [super init];
}


//###########################################################
// MOVIE PLAYER CONTROLS

//LOAD
-(void) load:(NSString*)file Mask:(BOOL)audiomask Time:(NSNumber*)atTime {
    if ([file length]>=1) {
        movieLoad = file;
        audioMask = audiomask;
        playAtTime = ([atTime doubleValue]-210)/1000.;
    }
    
}

//PLAY
-(void) play{
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if (movieLoad == nil) return;
    
    //Loader view
    [appDelegate.disPlay loader:TRUE];
    
    //if same movie just rewind
    if ([movieCurrent isEqualToString:movieLoad]) [self restart];
    
    //else create new player
    else {
        
        if (player != nil && [player currentItem] != nil) {
            [[player currentItem] removeObserver:self forKeyPath:@"playbackBufferEmpty"];
            [[player currentItem] removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
        }
        
        // Create the AVAsset
        AVAsset *asset = [AVAsset assetWithURL:[appDelegate.filesManager url:movieLoad]];
        AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:asset];
        
        // Streaming observer
        [playerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
        [playerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];
        
        //Player
        player = [AVPlayer playerWithPlayerItem:playerItem];
        player.actionAtItemEnd = AVPlayerActionAtItemEndNone;
        
        //movie end observer
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(movieDidEnd:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:[player currentItem]];
        
        //Layer
        AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:player];
        
        //select View
        UIView *view;
        view = movie1view;
        
        //Attach Layer
        layer.frame = movie1view.layer.bounds;
        view.layer.sublayers = nil;
        [view.layer addSublayer:layer];
        
        //bring to front
        //[appDelegate.disPlay.movieview bringSubviewToFront:view];
        
        movieCurrent = [movieLoad copy];
        
        //let's play
        [self launch:playAtTime];
        //NSLog(@"now %f / attime %f",[[NSDate date] timeIntervalSince1970], playAtTime);
        
        [appDelegate.disPlay movie:TRUE];
        [appDelegate.disPlay music:audioMask];
    }
}

//MOVIE END OBSEREVER (auto loop)
- (void)movieDidEnd:(NSNotification *)notification {
    [self replay];
}

// RESUME AFTER BACKGROUNND
-(void) resume {
    if (![self isPlaying]) return;
    [self launch:0];
}

//LAUNCH
-(void) launch:(double) atTime {
    
    // cancel replay timeout
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stop) object:nil];
    didFreeze = NO;
    
    [player play];
    
    // seek to time audio
    if (atTime < [[NSDate date] timeIntervalSince1970] && audioMask && playAtTime > 0) {
        atTime = [[NSDate date] timeIntervalSince1970] + 1.5;
        [self skip: (atTime-playAtTime)];
    }
    
    // wait atTime
    if (atTime > [[NSDate date] timeIntervalSince1970]) {
        [player pause];
        if (([[NSDate date] timeIntervalSince1970] - atTime) > 10) atTime = [[NSDate date] timeIntervalSince1970]+10;
        [self performSelector:@selector(start) withObject:nil afterDelay:(atTime-[[NSDate date] timeIntervalSince1970])];
    }
    else [self start];
        
}

//START
-(void) start {
    
    if (![self isPlaying]) return;
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate.disPlay replay:FALSE];
    [appDelegate.disPlay loader:FALSE];
    
    [player play];
    paused = NO;
    
    //timeout (if never start)
    //[self performSelector:@selector(stop) withObject:nil afterDelay:10];
}

//RESTART (from beginning)
-(void) restart {
    
    // cancel replay timeout
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stop) object:nil];
    
    [self skip:0];
    [self start];
}

//REPLAY: show replay mask
-(void) replay {
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"replay.png"]];
    [imageView.layer setBorderWidth: 0];
    [appDelegate.disPlay.replayview addSubview:imageView];
    imageView.center = CGPointMake(appDelegate.disPlay.replayview.frame.size.width  / 2,
                                     appDelegate.disPlay.replayview.frame.size.height / 2);
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(restart)];
    singleTap.numberOfTapsRequired = 1;
    [imageView setUserInteractionEnabled:YES];
    [imageView addGestureRecognizer:singleTap];
    
    [appDelegate.disPlay replay:TRUE];
    
    // Timeout
    [self performSelector:@selector(stop) withObject:nil afterDelay:30];
}

//STOP
-(void) stop{
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate.disPlay movie:FALSE];
    movie1view.layer.sublayers = nil;
    if ([player currentItem] != nil) {
        [[player currentItem] removeObserver:self forKeyPath:@"playbackBufferEmpty"];
        [[player currentItem] removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    }
    
    player = nil;

    [appDelegate.disPlay music:FALSE];
    [appDelegate.disPlay replay:FALSE];
    [appDelegate.disPlay loader:FALSE];
    
    paused = NO;
    
    if ([movieLoad isEqualToString:@"*"] && (movieCurrent != nil)) movieLoad = [movieCurrent copy];
    movieCurrent = nil;
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context {
    if (!player)
    {
        return;
    }
    
    else if ([keyPath isEqualToString:@"playbackBufferEmpty"])
    {
        if ([player currentItem].playbackBufferEmpty) {
            NSLog(@"Buffer empty");
            [self performSelector:@selector(stop) withObject:nil afterDelay:15];
            didFreeze = YES;
        }
    }
    
    else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"])
    {
        if ([player currentItem].playbackLikelyToKeepUp) {
            NSLog(@"Buffer back again");
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(stop) object:nil];
            if (didFreeze) [player play];
        }
    }
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
-(void) skip:(double) playbacktimeWanted{
    
    //if (![self isPlaying]) return;
    /*NSLog(@"duration %@ %f",CMTimeGetSeconds(player.currentItem.duration), playbacktimeWanted);
    
    if ( CMTimeGetSeconds(player.currentItem.duration) > (playbacktimeWanted)) {
        [player seekToTime:CMTimeMake(playbacktimeWanted, 1) toleranceBefore: kCMTimeZero toleranceAfter: kCMTimeZero];
        NSLog(@"skipped");
    }
    else {
        //[self stop];
        [self replay];
    }*/
    //NSLog(@"duration %f %f",CMTimeGetSeconds(player.currentItem.duration), playbacktimeWanted);
    [player seekToTime:CMTimeMake((playbacktimeWanted*1000), 1000) toleranceBefore: kCMTimeZero toleranceAfter: kCMTimeZero];
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

@end
