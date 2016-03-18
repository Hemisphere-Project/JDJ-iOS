//
//  TextClass.m
//  JDJ
//
//  Created by Mac Laren on 16/03/16.
//  Copyright © 2016 hmsphr. All rights reserved.
//

#import "TextClass.h"
#import "ConfigConst.h"
#import "AppDelegate.h"

@implementation TextClass

@synthesize textview;

//###########################################################
// INIT

- (id) init
{
    //Create PLAYER 1 view
    textview = [[UIView alloc] initWithFrame:CGRectMake(0,0,100,100)];
    textview.backgroundColor = [UIColor clearColor];
    textview.alpha=1;
    
    content = @"";
    
    return [super init];
}


//###########################################################
// MOVIE PLAYER CONTROLS

//LOAD
-(void) load:(NSString*)txt Time:(NSNumber*)atTime {
    content = txt;
}

//PLAY
-(void) play {
    
    [self stop];
    
    //Create UILabel
    player = [ [UILabel alloc ] initWithFrame:textview.frame ];
    player.textAlignment =  NSTextAlignmentCenter;
    player.textColor = [UIColor whiteColor];
    player.backgroundColor = [UIColor blackColor];
    player.font = [UIFont fontWithName:@"Arial" size:(20.0)];
    player.numberOfLines = 0;
    player.text = content;
    
    //push to View
    [textview addSubview:player];
}

//STOP
-(void) stop{
    NSArray *toRemove = [textview subviews];
    for (UIView *v in toRemove) [v removeFromSuperview];
    player = nil;
}

@end
