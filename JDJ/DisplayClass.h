//
//  DisplayClass.h
//  JDJ
//
//  Created by Mac Laren on 04/01/16.
//  Copyright © 2016 hmsphr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DisplayClass : NSObject {
    
    UIView *mainView;
    
    //views
    UIView *welcomeview;
    UIView *movieview;
    UIView *webview;
    UIView *textview;
    UIView *musicview;
    UIView *loaderview;
    UIView *replayview;
    
}

@property (nonatomic,retain) UIView *mainView;
@property (nonatomic,retain) UIView *welcomeview;
@property (nonatomic,retain) UIView *movieview;
@property (nonatomic,retain) UIView *webview;
@property (nonatomic,retain) UIView *textview;
@property (nonatomic,retain) UIView *replayview;

-(void) createViews;

-(void) music:(BOOL)musicMe;
-(void) loader:(BOOL)loadMe;
-(void) replay:(BOOL)replayMe;

@end
