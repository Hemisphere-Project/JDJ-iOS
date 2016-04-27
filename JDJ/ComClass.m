//
//  ComClass.m
//  JDJ
//
//  Created by Mac Laren on 17/02/16.
//  Copyright © 2016 hmsphr. All rights reserved.
//

#import "ComClass.h"
#import "AppDelegate.h"
#import "ConfigConst.h"
#import "SettingsClass.h"
#import "JDJ-Swift.h"

@implementation ComClass

@synthesize ipodName;

//###########################################################
// INIT & OPEN PORTS

- (id) init {
    
    //INIT
    connected = NO;
    player_ready = YES;
    last_stamp = 0;
    userid = [SettingsClass getInt:@"userid" defValue:-1];
    
    // CHECK CONNECTIVITY
    reach = [TMReachability reachabilityWithHostname:[SERVER_URL stringByAppendingString:@"/ping"]];
    reach.reachableOnWWAN = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    [reach startNotifier];
    
    // RETRY CONN
    timerChecker = [NSTimer scheduledTimerWithTimeInterval:TIMER_CHECK
                                                    target:self
                                                  selector:@selector(check)
                                                  userInfo:nil
                                                   repeats:YES];
    
    
    // SOCKET
    NSURL* url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@:%d", SERVER_URL, SERVER_PORT_CMD]];
    socket = [[SocketIOClient alloc] initWithSocketURL:url options:@{@"forcePolling": @NO, @"log": @NO, @"secure": @YES}];
    
    // CONNECT
    [socket on:@"connect" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSLog(@"COM: socket connected");
        // cancel stop timeout
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        connected = YES;
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate.mainController infoCom:@"Vous êtes connecté au Journal d'un seul Jour."];
    }];
    
    // WHOAREYOU
    [socket on:@"whoareyou" callback:^(NSArray* data, SocketAckEmitter* ack) {
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        if (userid > 0) dict[@"userid"] = @(userid);
        [socket emit:@"iam" withItems:@[dict]];
    }];
    
    // HELLO
    [socket on:@"hello" callback:^(NSArray* data, SocketAckEmitter* ack) {
        if ([data count] > 0 && [data[0] isKindOfClass:[NSDictionary class]]) {
            @synchronized(self) {
                [self processHello:data[0]];
            }
        }
    }];
    
    // TASK
    [socket on:@"task" callback:^(NSArray* data, SocketAckEmitter* ack) {
        if ([data count] > 0 && [data[0] isKindOfClass:[NSDictionary class]]) {
            @synchronized(self) {
                [self processCommand:data[0]];
            }
        }
    }];
    
    // DISCONNECT
    [socket on:@"disconnect" callback:^(NSArray* data, SocketAckEmitter* ack) {
        NSLog(@"COM: socket disconnected");
        connected = NO;
        
        // Timeout
        [self performSelector:@selector(loose) withObject:nil afterDelay:15];
    }];
    
    [socket connect];
    NSLog(@"COM: socket connecting..");

    
    return [super init];
}

//###########################################################
// UTILITIES

- (BOOL) notNull: (NSObject*) obj {
    if ([obj isEqual:[NSNull null]]) return NO;
    else return (obj != nil);
}

- (void) reachabilityChanged: (NSNotification*) notif {
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if (reach.isReachableViaWiFi || reach.isReachableViaWWAN) [self check];
    else [appDelegate.mainController infoCom:@"Impossible de joindre le serveur de spectacle,\n vérifiez votre connexion WIFI ou 3G/4G"];
}


- (void) check {
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if (!connected && (reach.isReachableViaWiFi || reach.isReachableViaWWAN)) {
        [appDelegate.mainController infoCom:@"Connexion au serveur de spectacle en cours ..."];
        [socket disconnect];
        [socket connect];
    }
}

-(void) loose {
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.runMachine.stopall = YES;
}

- (void) storeTask: (NSMutableDictionary*) dict {
    if ([self notNull:dict]) {
        [dict removeObjectForKey:@"timestamp"];
        if ([self notNull:[dict valueForKey:@"cache"]])
            if ([[dict valueForKey:@"cache"] boolValue]) {
                taskBuffer = dict;
                if ([self notNull:[dict valueForKey:@"action"]])
                    NSLog(@"COM: App need Attention !");
            }
    }
    else taskBuffer = nil;
}

// REGISTER user
- (void) doRegister: (NSString *) myphone ShowID:(int) showid {
    
    NSDictionary *obj = @{
                          @"userid" : [NSNumber numberWithLong:userid],
                          @"number" : myphone,
                          @"showid" : [NSNumber numberWithInt:showid],
                          @"os"     : @"ios",
                        };
    
    [socket emit:@"subscribe" withItems:@[obj]];
    
}

// HELLO
- (void) processHello: (NSDictionary *) data {
    //NSLog(@"COM: HELLO %@", data);

    // PARSE Hello
    NSDictionary *user = [data objectForKey:@"user"];
    if (!user) return;
    
    // INFO
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSString* info = [data objectForKey:@"info"];
    if ([self notNull:info]) [appDelegate.mainController infoCom:info];
    
    // USER id
    if ([self notNull:[user valueForKey:@"id"]]) {
        userid = [[user valueForKey:@"id"] integerValue];
        if (userid) [SettingsClass setInt:@"userid" Value:userid];
    }
    
    // PHONE number
    phone = [user objectForKey:@"number"];
    if ([self notNull:phone]) [SettingsClass setString:@"phone" Value:phone];
    
    // GROUP
    group = [user objectForKey:@"group"];
    if ([self notNull:group])
        [SettingsClass setString:@"group" Value:group];
    
    //SECTIONS
    section = [user objectForKey:@"section"];
    if ([self notNull:section])
        [SettingsClass setDict:@"section" Value:section];

    // ERROR
    error = [user objectForKey:@"error"];
    if ([self notNull:error]) [SettingsClass setString:@"error" Value:error];
    else [SettingsClass setString:@"error" Value:@""];
    
    // EVENT selected
    event = [user objectForKey:@"event"];
    if ([self notNull:event]) [SettingsClass setDict:@"event" Value:event];
    
    // EVENT LIST
    showlist = [data objectForKey:@"showlist"];
    if ([self notNull:showlist]) [SettingsClass setArray:@"showlist" Value:showlist];
    
    // SERVER VERSION
    serverVersion = [data objectForKey:@"version"];
    if ([self notNull:serverVersion]) [SettingsClass setDict:@"server" Value:serverVersion];
    
    // CHECK VERSION
    NSArray* myVersion = [APP_VERSION componentsSeparatedByString: @"."];
    
    // MAJOR BREAK
    if ([self notNull:[serverVersion valueForKey:@"main"]])
        if ([[serverVersion valueForKey:@"main"] integerValue] > [myVersion[0] integerValue]) {
            [appDelegate.mainController updateAvailable:TRUE];
            return;
        }
    if ([self notNull:[serverVersion valueForKey:@"major"]])
        if ([[serverVersion valueForKey:@"major"] integerValue] > [myVersion[1] integerValue]) {
            [appDelegate.mainController updateAvailable:TRUE];
            return;
        }
    
    // MISSING USER
    if (userid < 0 || [self notNull:error]) {
        NSLog(@"COM: User incomplete");
        [appDelegate showSettings];
        return;
    }
    
    // MINOR BREAK
    if ([self notNull:[serverVersion valueForKey:@"ios-minor"]])
        if ([[serverVersion valueForKey:@"ios-minor"] integerValue] > [myVersion[2] integerValue]) {
            [appDelegate.mainController updateAvailable:TRUE];
        }
    
    // SHOW STATE
    // TODO...
    
    // LVC
    [self processCommand: [data objectForKey:@"lvc"]];
    
}

// PROCESS COMMAND RECEIVED
- (void) processCommand: (NSDictionary *) task {
    
    //TODO
    // - check if file is available in local
    
    if (![self notNull:task]) return;
    // NSLog(@"COM: Task %@", task);
    
    //Clear command buffer
    //[self storeTask:nil];
    
    // Check if cmd already executed
    if ([self notNull:[task valueForKey:@"timestamp"]]) {
        NSInteger ts = [[task valueForKey:@"timestamp"] integerValue];
        if (ts == last_stamp) {
            NSLog(@"COM: command already executed");
            return;
        }
        else last_stamp = ts;
    }
    
    // Check GROUP
    NSString* task_group = [task objectForKey:@"group"];
    if ([self notNull:task_group] && ![task_group isEqualToString:group]) {
        NSLog(@"COM: not in the group.. ignoring");
        return;
    }
    
    // Check SECTION
    NSString* task_section = [task objectForKey:@"section"];
    if ([self notNull:task_section] && !section[task_section]) {
        NSLog(@"COM: not in the section.. ignoring");
        return;
    }
    
    //APP is not available
    //
    
    if (!player_ready) {
        [self storeTask:[task mutableCopy]];
        return;
    }
    
    // ACTION
    NSString* task_action = [task objectForKey:@"action"];
    if ([self notNull:task_action]) {
        //NSLog(@"COM: Dispatching action %@", task);
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [appDelegate.runMachine dispatch:task];
        
    }
    else NSLog(@"COM: Action missing !");
}


@end