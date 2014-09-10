//
//  PLViewController.h
//  SparkRestful
//
//  Created by Peterlee on 2/18/14.
//  Copyright (c) 2014 Peterlee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PLXTopViewController.h"
#import "PLNetworkManager.h"
#import "PLLoginViewController.h"

@interface PLViewController : PLXTopViewController <UITableViewDataSource,UITableViewDelegate,LoginViewDelegate>

@property (nonatomic,strong) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSArray *tableArray;

@end
