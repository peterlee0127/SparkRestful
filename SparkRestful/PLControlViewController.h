//
//  PLControlViewController.h
//  SparkRestful
//
//  Created by Peterlee on 2/19/14.
//  Copyright (c) 2014 Peterlee. All rights reserved.
//

#import "PLXTopViewController.h"

@interface PLControlViewController : PLXTopViewController

@property (nonatomic,strong)  NSString *coreName;
@property (nonatomic,strong)  NSString *deviceID;
@property (nonatomic,strong)  NSString *client;
@property (nonatomic,strong)  NSString *expiredtime;
@property (nonatomic,strong)  NSString *token;
@property (nonatomic,strong)  NSString *connected;
@property (nonatomic,strong)  NSString *core_version;

@property (nonatomic,strong)  NSArray *functions;
@property (nonatomic,strong)  NSArray *variables;


@property (nonatomic,strong)  UIButton *sendButton;
@property (nonatomic,strong)  UITextField *argumentField;
@property (nonatomic,strong)  UITextField *functionField;




@property (nonatomic,strong) NSDictionary *dict;

@end
