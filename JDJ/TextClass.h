//
//  TextClass.h
//  JDJ
//
//  Created by Mac Laren on 16/03/16.
//  Copyright © 2016 hmsphr. All rights reserved.
//

#import "TextClass.h"
#import <UIKit/UIKit.h>

@interface TextClass : NSObject {
    
    UIView* textview;
    UILabel* player;
    NSString* content;
}

@property (nonatomic,retain) UIView *textview;

-(void) load:(NSString*)content Time:(NSNumber*)atTime;
-(void) play;
-(void) stop;

@end
