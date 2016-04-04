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
    UIView *settingsview;
    UIView *movieview;
    UIView *webview;
    UIView *textview;
    UIImageView *musicview;
    UIView *loaderview;
    UIView *replayview;
    
}

@property (nonatomic,retain) UIView *mainView;
@property (nonatomic,retain) UIView *replayview;

-(void) createViews;

-(void) movie:(BOOL)show;
-(void) music:(BOOL)show;
-(void) text:(BOOL)show;
-(void) web:(BOOL)show;
-(void) loader:(BOOL)show;
-(void) replay:(BOOL)show;

@end
