//
//  ComClass.h
//  JDJ
//
//  Created by Mac Laren on 17/02/16.
//  Copyright © 2016 hmsphr. All rights reserved.
//

//
//  ComClass.h
//  KXKM
//
//  Created by Snow Leopard User on 08/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TMReachability.h"

@class SocketIOClient;

@interface ComClass : NSObject {
    
    //ID
    NSString* ipodName;
    
    //PORT & IP
    int outPort;
    int inPort;
    
    //SOCKET
    SocketIOClient* socket;
    
    //TASK
    NSDictionary* taskBuffer;
    NSInteger last_stamp;
    
    //INFO
    NSInteger       userid;
    NSString*       phone;
    NSString*       group;
    NSDictionary*   section;
    NSString*       error;
    NSDictionary*   event;
    NSArray*        showlist;
    NSDictionary*   serverVersion;

    //STATE
    TMReachability* reach;
    BOOL connected;
    BOOL player_ready;
    NSTimer *timerChecker;
}

@property (readwrite, retain) NSString* ipodName;

- (void) storeTask: (NSMutableDictionary*) dict;
- (void) doRegister: (NSString *)phone ShowID:(int) showid;
- (void) processHello: (NSDictionary *) data;
- (void) processCommand: (NSDictionary *) data;
- (void) check;
- (void) loose;

@end
