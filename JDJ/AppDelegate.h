//
//  AppDelegate.h
//  JDJ
//
//  Created by Mac Laren on 04/01/16.
//  Copyright © 2016 hmsphr. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FilesClass.h"
#import "MovieClass.h"
#import "DisplayClass.h"
#import "RunClass.h"
#import "ComClass.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    
    //INTERFACE
    UIWindow *window;
    
    //OBJECTS
    DisplayClass *disPlay;      //Second Screen
    ComClass *comPort;          //Communication
    RunClass *runMachine;       //Running commands
    //CheckerClass *checkMachine; //Check states
    FilesClass *filesManager;   //Files Manager
    MovieClass *moviePlayer;    //Movie Player
    //InterfaceClass *interFace;  //User Interface
    
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) DisplayClass *disPlay;
@property (nonatomic, retain) ComClass *comPort;
@property (nonatomic, retain) RunClass *runMachine;
//@property (nonatomic, retain) CheckerClass *checkMachine;
@property (nonatomic, retain) FilesClass *filesManager;
@property (nonatomic, retain) MovieClass *moviePlayer;
//@property (nonatomic, retain) InterfaceClass *interFace;

@end

