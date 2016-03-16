//
//  WebClass.h
//  JDJ
//
//  Created by Mac Laren on 16/03/16.
//  Copyright © 2016 hmsphr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WebClass : NSObject {
    
    UIView *webview;
    UIWebView *player;

    NSString *urlLoad;
    NSString *urlCurrent;
}

@property (nonatomic,retain) UIView *webview;

-(void) load:(NSString*)url Time:(NSNumber*)atTime;
-(void) play;
-(void) stop;

@end
