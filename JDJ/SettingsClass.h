//
//  SettingsClass.h
//  JDJ
//
//  Created by Mac Laren on 17/02/16.
//  Copyright © 2016 hmsphr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingsClass : NSObject

+ (NSInteger) getInt: (NSString*) key defValue: (NSInteger) def;
+ (NSString*) getString: (NSString*) key;
+ (NSDictionary*) getDict: (NSString*) key;
+ (NSArray*) getArray: (NSString*) key;

+ (void) setInt: (NSString*) key Value: (NSInteger) val;
+ (void) setString: (NSString*) key Value: (NSString*) val;
+ (void) setDict: (NSString*) key Value: (NSDictionary*) val;
+ (void) setArray: (NSString*) key Value: (NSArray*) val;

@end



