//
//  PLRequestViewController.m
//  SparkRestful
//
//  Created by Peterlee on 9/10/14.
//  Copyright (c) 2014 Peterlee. All rights reserved.
//

#import "PLRequestViewController.h"
#import "PLNetworkManager.h"

@interface PLRequestViewController () <PLNetworkManagerDelegate>

@property (nonatomic,strong) PLNetworkManager *manager;

@end

@implementation PLRequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc]
                                                                         initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    self.title = @"GetVariableRequest";
    self.manager = [[PLNetworkManager alloc] init];
    self.manager.delegate = self;
    // Do any additional setup after loading the view from its nib.
}
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self startGetRequest];
}
-(void) startGetRequest
{
  [self.manager GetVariableRequest:self.access_token andDeviceID:self.deviceID];
}

-(void)GetVariableRequestSuccess:(NSDictionary *)dict
{
//    NSLog(@"%@",dict);
    [self performSelector:@selector(startGetRequest) withObject:nil afterDelay:5];
    
    self.resultLabel.text = [NSString stringWithFormat:@"%@",dict[@"result"]];
}
-(void)GetVariableRequestFail
{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    
    [self performSelector:@selector(startGetRequest) withObject:nil afterDelay:2];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
