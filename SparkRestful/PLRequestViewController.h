//
//  PLRequestViewController.h
//  SparkRestful
//
//  Created by Peterlee on 9/10/14.
//  Copyright (c) 2014 Peterlee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PLRequestViewController : UIViewController



@property (nonatomic,strong) IBOutlet UILabel *resultLabel;

@property (nonatomic,strong) NSString *deviceID;
@property (nonatomic,strong) NSString *access_token;


@end
