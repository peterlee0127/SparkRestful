//
//  PLNetworkManager.h
//  SparkRestful
//
//  Created by Peterlee on 2/18/14.
//  Copyright (c) 2014 Peterlee. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PLNetworkManagerDelegate;

@interface PLNetworkManager : NSObject


@property (nonatomic,weak) id <PLNetworkManagerDelegate> delegate;

+(instancetype) shareInstance;
-(void) Userlogin:(NSString *) account :(NSString *)password;
-(void) getDeviceInf:(NSString *) access_token;
-(void) GetVariableRequest:(NSString *) access_token andDeviceID:(NSString *) deviceID;
-(void) SentAction:(NSString *) access_token deviceId:(NSString *) deviceID func:(NSString *) func args:(NSString *)arg;

@end


@protocol PLNetworkManagerDelegate

-(void) userLoginSuccess:(id) result;
-(void) userLoginFailed:(NSError *) error;

-(void) getDeviceInfSuccess:(NSDictionary *) dict;
-(void) getDeviceInfFail;

-(void) GetVariableRequestSuccess:(NSDictionary *) dict;
-(void) GetVariableRequestFail;


-(void) sentActionSuccess:(NSString *) successString;
-(void) sentActionFail:(NSString *) errorString;


@end