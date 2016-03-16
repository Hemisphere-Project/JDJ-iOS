//
//  SettingsClass.m
//  JDJ
//
//  Created by Mac Laren on 17/02/16.
//  Copyright © 2016 hmsphr. All rights reserved.
//

#import "SettingsClass.h"

@implementation SettingsClass

+ (NSInteger) getInt: (NSString*) key defValue: (NSInteger) def {
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    NSInteger value = [settings integerForKey:key];
    if (value) return value;
    return def;
}

+ (NSString*) getString: (NSString*) key {
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    NSString* value = [settings stringForKey:key];
    if (value) return value;
    return nil;
}

+ (NSDictionary*) getDict: (NSString*) key {
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    NSDictionary* value = [settings dictionaryForKey:key];
    if (value) return value;
    return nil;
}

+ (NSArray*) getArray: (NSString*) key {
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    NSArray* value = [settings arrayForKey:key];
    if (value) return value;
    return nil;
}


+ (void) setInt: (NSString*) key Value: (NSInteger) val {
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    [settings setInteger:val forKey:key];
    [settings synchronize];
}

+ (void) setString: (NSString*) key Value: (NSString*) val {
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    [settings setObject:val forKey:key];
    [settings synchronize];
}

+ (void) setDict: (NSString*) key Value: (NSDictionary*) val {
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    [settings setObject:val forKey:key];
    [settings synchronize];
}

+ (void) setArray: (NSString*) key Value: (NSArray*) val {
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    [settings setObject:val forKey:key];
    [settings synchronize];
}

@end