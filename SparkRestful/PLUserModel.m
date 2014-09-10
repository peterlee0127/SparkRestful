//
//  PLUserModel.m
//  SparkRestful
//
//  Created by Peterlee on 2/18/14.
//  Copyright (c) 2014 Peterlee. All rights reserved.
//

#import "PLUserModel.h"
const static NSString *settingPlistFile = @"/setting.plist";

@implementation PLUserModel
{
    NSString *filePath;
}

+(instancetype) shareInstance
{
    static PLUserModel *shareInstance=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance=[[PLUserModel alloc] init];
    });
    return shareInstance;
}

-(id)init
{
    self=[super init];
    if(self)
    {
        [self loadPlist];
    }
    return self;
}
-(void) loadPlist
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    filePath = [documentsDirectory stringByAppendingString:(NSString *)settingPlistFile];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath: filePath])
    {
        self.plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];  // load from plist
    }
    else
    {
        self.plistDict = [[NSMutableDictionary alloc] init];                             // create
    }
}
-(void) saveUserData:(NSString *) account :(NSString *) password
{
    self.plistDict[@"account"]=account;
    self.plistDict[@"password"]=password;
    [self saveToPlist];
}
-(NSString *) loadAccount
{
    return self.plistDict[@"account"];
}
-(NSString *)loadPassword
{
    return self.plistDict[@"password"];
}
-(void) saveToPlist
{
    if([self.plistDict writeToFile:filePath atomically:NO])
    {
//        NSLog(@"success");
    }
}
-(void) saveDevices:(NSArray *) devices
{
    self.plistDict[@"devices"] = devices;
    [self saveToPlist];
}
-(NSArray *) getDevices
{
    return self.plistDict[@"devices"];
}

@end
