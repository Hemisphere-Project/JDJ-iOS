//
//  FilesClass.h
//  JDJ
//
//  Created by Mac Laren on 04/01/16.
//  Copyright © 2016 hmsphr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FilesClass : NSObject {
    
    NSString *docPath;
    NSArray *mediaList;
    
}

@property (readwrite, retain) NSString* docPath;

- (NSString *) platform;
- (NSArray *) list;
- (NSArray *) mediaList;
- (BOOL) find:(NSString *) file;
- (NSString *) after:(NSString *) file;
- (NSString *) before:(NSString *) file;
- (NSURL*) url:(NSString *) file;
- (NSURL*) urlnew:(NSString *) file;

@end
