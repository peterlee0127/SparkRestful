//
//  PLLoginViewController.h
//  SparkRestful
//
//  Created by Peterlee on 2/19/14.
//  Copyright (c) 2014 Peterlee. All rights reserved.
//

#import "PLXTopViewController.h"
#import "PLLoginViewController.h"
#import "PLUserModel.h"
#import "PLNetworkManager.h"

@protocol LoginViewDelegate ;


@interface PLLoginViewController : PLXTopViewController <PLNetworkManagerDelegate,UIAlertViewDelegate>

@property (nonatomic,strong) PLNetworkManager *networkManager;
@property (nonatomic,strong) id <LoginViewDelegate> delegate;


@end


@protocol LoginViewDelegate

-(void) usersCore:(NSArray *) array;

@end