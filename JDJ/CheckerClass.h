//
//  CheckerClass.h
//  JDJ
//
//  Created by Mac Laren on 16/03/16.
//  Copyright © 2016 hmsphr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CheckerClass : NSObject {
    
    NSTimer *timerChecker;
    
    int lastSync;
    int lastTab;
    int timeHere;
    int batteryRefresh;
    int broadcastRefresh;
}


- (void) start;
- (void) beat;
- (void) userAct: (int) tim;
- (void) syncAct;

@end
