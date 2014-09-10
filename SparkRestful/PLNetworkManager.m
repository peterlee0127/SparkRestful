//
//  PLNetworkManager.m
//  SparkRestful
//
//  Created by Peterlee on 2/18/14.
//  Copyright (c) 2014 Peterlee. All rights reserved.
//

#import "PLNetworkManager.h"
#import <AFNetworking.h>

@implementation PLNetworkManager

+(instancetype) shareInstance
{
    static PLNetworkManager *shareInstance=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance=[[PLNetworkManager alloc] init];

    });
    return shareInstance;
}
-(void) Userlogin:(NSString *) account :(NSString *)password
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy.allowInvalidCertificates = NO;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];

    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:account password:password];
    [manager GET:@"https://api.spark.io/v1/access_tokens" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate userLoginSuccess:responseObject];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate userLoginFailed:error];
    }];
   
}
-(void) getDeviceInf:(NSString *) access_token
{
     AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
     NSString *urlString = [NSString stringWithFormat:@"https://api.spark.io/v1/devices/\?access_token=%@",access_token];
     [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
     
         NSDictionary *dict = (NSDictionary *)responseObject[0];
         if(dict[@"id"])
         {
             AFHTTPRequestOperationManager *manager= [AFHTTPRequestOperationManager manager];
             NSString *urlString = [NSString stringWithFormat:@"https://api.spark.io/v1/devices/%@/\?access_token=%@",dict[@"id"],access_token];
             manager.requestSerializer = [AFJSONRequestSerializer serializer];
             [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 NSDictionary *dict = (NSDictionary *)responseObject;
                 if(dict[@"id"]){
                     NSString *variables = @"";
                     if(dict[@"variables"]){
                         variables = dict[@"variables"];
                     }
                     [self.delegate getDeviceInfSuccess:dict];
                 }
                 
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 
                 [self.delegate getDeviceInfFail];
                 
             }];
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"get token fail");
         [self.delegate getDeviceInfFail];
     }];


}

-(void) GetVariableRequest:(NSString *) access_token andDeviceID:(NSString *) deviceID
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *urlString = [NSString stringWithFormat:@"https://api.spark.io/v1/devices/%@/%@\?access_token=%@",deviceID,@"var",access_token];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        [self.delegate GetVariableRequestSuccess:dict];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.delegate GetVariableRequestFail];

        
    }];

}

-(void) SentAction:(NSString *) access_token deviceId:(NSString *) deviceID func:(NSString *) func args:(NSString *)arg
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:access_token,@"access_token",arg,@"args",nil];
    NSString *urlString = [NSString stringWithFormat:@"https://api.spark.io/v1/devices/%@/%@",deviceID,func];
    [manager POST:urlString parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([responseObject[@"error"] isEqualToString:@"Timed out."])
        {
            [self.delegate sentActionFail:[NSString stringWithFormat:@"%@",@"Time out."]];
            return ;
        }
        [self.delegate sentActionSuccess:[NSString stringWithFormat:@"Result:%@",responseObject]];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"send action fail");
        [self.delegate sentActionFail:[NSString stringWithFormat:@"%@",[error description]]];
    }];

}


@end
