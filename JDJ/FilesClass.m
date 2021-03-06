//
//  FilesClass.m
//  JDJ
//
//  Created by Mac Laren on 04/01/16.
//  Copyright © 2016 hmsphr. All rights reserved.
//

#import "FilesClass.h"
#include <sys/sysctl.h>
#import "AppDelegate.h"

@implementation FilesClass

@synthesize docPath;

//###########################################################
// INIT

- (id) init
{
    //les vidéos sont dorénavent a placer dans le dossier Documents de l'App KXKM
    //ne pas activer icloud sous peine de synchronisation des vidéos (ralentissement)
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docPath = [[paths objectAtIndex:0] copy];
    
    //simulator path (dev only)
    if ([[self platform] isEqualToString:@"i386"] || [[self platform] isEqualToString:@"x86_64"]) docPath = @"/Media/Video/";
    
    //make list
    [self mediaList];
    
    return [super init];
}

//###########################################################
// UTILITIES

- (NSString *) platform{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    if (machine!=nil)
    {
        NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
        free(machine);
        return platform;
    }
    return @"ipod";
}

//###########################################################
// FILES MANAGER

//MEDIA list
- (NSArray *)list{
    
    //list compatible video files
    NSArray *extensions = [NSArray arrayWithObjects:@"mp4", @"mov", @"m4v", @"mp3", @"aif", @"aac", nil];
    NSArray *dirContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:docPath error:nil];
    NSArray *mL = [dirContents filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"pathExtension IN %@", extensions]];
    
    return mL;
}

//UPDATE MEDIA LIST
- (NSArray *) mediaList
{
    //make list
    mediaList = [[self list] copy];
    return mediaList;
}

//SEARCH A MEDIA
- (BOOL) find:(NSString *) file {
    
    if ([mediaList count] > 0)
        if ([mediaList containsObject:file]) return YES;
    
    
    return NO;
}

//SEARCH NEXT MEDIA
- (NSString *) after:(NSString *) file {
    
    if ([self find:file]) {
        int index = [mediaList indexOfObject:file]+1;
        if (index < [mediaList count]) return [mediaList objectAtIndex:index];
    }
    
    return nil;
}

//SEARCH PREVIOUS MEDIA
- (NSString *) before:(NSString *) file {
    
    if ([self find:file]) {
        int index = [mediaList indexOfObject:file]-1;
        if (index >= 0) return [mediaList objectAtIndex:index];
    }
    
    return nil;
}

//GET URL
//RETURN LOCAL URL or STREAM SERVER URL
- (NSURL*) url:(NSString *) file {
    
    NSURL* myURL;
    NSString* path;
    
    //LOCAL FILE
    if ([self find:file]) {
        path = [docPath stringByAppendingString:@"/"];
        path = [path stringByAppendingString:file];
        myURL = [NSURL fileURLWithPath:path];
        //NSLog(@"local file");
        return myURL;
    }
    
    //REMOTE FILE
    else {
        path = file;
        myURL = [NSURL URLWithString:path];
        
    }
    return myURL;
}

//MAKE URL
- (NSURL*) urlnew:(NSString *) file {
    
    NSURL* myURL;
    NSString* path;
    
    //LOCAL FILE
    path = [docPath stringByAppendingString:@"/"];
    path = [path stringByAppendingString:file];
    myURL = [NSURL fileURLWithPath:path];
    return myURL;
}


@end
