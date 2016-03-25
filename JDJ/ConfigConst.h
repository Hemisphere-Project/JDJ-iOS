//
//  ConfigConst.h
//  JDJ
//
//  Created by Mac Laren on 04/01/16.
//  Copyright © 2016 hmsphr. All rights reserved.
//

#ifndef ConfigConst_h
#define ConfigConst_h

//###########################################################
// CONFIGURATION & CONSTANTS

//APP
#define APP_VERSION         @"0.1.0"

//SERVER
#define SERVER_URL          @"https://app.journaldunseuljour.fr"
#define SERVER_PORT_CMD     8081
#define SERVER_PORT_TIME    8082

//PLAYER
#define STREAM_UNKNOWN_MOVIE  YES    //When /playmovie unknown file try to stream it (like playstream)

//TIMERS
#define TIMER_RUN           0.1  //10ms   Runner : recieved orders
#define TIMER_CHECK         0.8  //800ms  Checker : IP / Screen / ..
#define TIMER_RELMOVIE      0.4  //400ms  Movie Releaser (remove movie in the back)

//PLAYER TYPES
#define PLAYER_LOCAL       0
#define PLAYER_STREAM      1

//VIEWS INIT
#define VIEW_MUSIC      YES

//DEBUG
#define DEBUG_PLAYERS   NO   //separate and colorize rotative players views

#endif /* ConfigConst_h */
