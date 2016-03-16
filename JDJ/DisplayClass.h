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
    
    UIWindow *_secondWindow;
    NSString *screenResolution;
    
    //views
    UIView *movieview;
    UIView *webview;
    UIView *textview;
    UIView *musicview;
    UIView *loaderview;
    
}

@property (nonatomic, retain) IBOutlet UIWindow *_secondWindow;
@property (nonatomic, retain) NSString *screenResolution;

@property (nonatomic,retain) UIView *movieview;
@property (nonatomic,retain) UIView *webview;
@property (nonatomic,retain) UIView *textview;

-(BOOL) checkScreen;
-(void) createWindow;
-(NSString*) resolution;

-(void) music:(BOOL)musicMe;
-(void) loader:(BOOL)loadMe;

@end
