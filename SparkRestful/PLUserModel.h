//
//  PLUserModel.h
//  SparkRestful
//
//  Created by Peterlee on 2/18/14.
//  Copyright (c) 2014 Peterlee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PLUserModel : NSObject



+(instancetype) shareInstance;
@property (nonatomic,strong) NSMutableDictionary *plistDict;


-(void) saveUserData:(NSString *) account :(NSString *) password;
-(NSString *) loadAccount;
-(NSString *) loadPassword;

-(void) saveDevices:(NSArray *) devices;
-(NSArray *) getDevices;

@end
