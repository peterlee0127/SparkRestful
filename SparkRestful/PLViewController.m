//
//  PLViewController.m
//  SparkRestful
//
//  Created by Peterlee on 2/18/14.
//  Copyright (c) 2014 Peterlee. All rights reserved.
//

#import "PLViewController.h"
#import "PLSparkCell.h"
#import "PLUserModel.h"
#import "PLNetworkManager.h"
#import "PLControlViewController.h"
#import <MBProgressHUD.h>

@interface PLViewController () <PLNetworkManagerDelegate>

@property (nonatomic,assign) _Bool refreshing;


@end

@implementation PLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"SparkRestful";
    self.screenName = @"Main";
    self.refreshing = NO;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PLSparkCell" bundle:nil] forCellReuseIdentifier:@"MenuCell"];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
  
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Refresh" style:UIBarButtonItemStylePlain target:self action:@selector(refresh)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(showLoginVC)];
    
    if(![[PLUserModel shareInstance] getDevices].count>0)
        [self showLoginVC];
    else
        self.tableArray = [[PLUserModel shareInstance] getDevices];
	// Do any additional setup after loading the view, typically from a nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
-(void) showLoginVC
{
    [[PLUserModel shareInstance] saveDevices:@[]];
    
    PLLoginViewController *loginVC=[[PLLoginViewController alloc] initWithNibName:@"PLLoginViewController" bundle:nil];
    loginVC.delegate=self;
    UINavigationController *nav =[[UINavigationController alloc] initWithRootViewController:loginVC];
    [self presentViewController:nav animated:NO completion:nil];
}
-(void) refresh
{
    if(self.refreshing)
        return;
    
    PLUserModel *userModel=[PLUserModel shareInstance];
    
    PLNetworkManager *networkManager=[PLNetworkManager shareInstance];
    networkManager.delegate=self;
    
    [networkManager Userlogin:[userModel loadAccount] :[userModel loadPassword]];
     
   
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading";
    self.refreshing = YES;
}
-(void)userLoginSuccess:(id)result
{
    NSArray *res=(NSArray *)result;
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    for (int i=0; i<res.count; i++) {
        NSDictionary *dict = (NSDictionary *)res[i];
        if([dict[@"client"] isEqualToString:@"user"])
            [tempArr addObject:dict];
    }
    res = tempArr;
    [self usersCore:res];
    self.refreshing = NO;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    });
}
-(void) usersCore:(NSArray *)array
{
    self.tableArray=array;
    [self.tableView reloadData];
    [[PLUserModel shareInstance] saveDevices:array];
}
#pragma mark - UITableView DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PLSparkCell *cell=[self.tableView dequeueReusableCellWithIdentifier:@"MenuCell"];

    NSDictionary *dict=[self.tableArray objectAtIndex:indexPath.row];

    cell.clientLabel.text=[NSString stringWithFormat:@"client:%@",dict[@"client"]];
    cell.expiredtimeLabel.text=[NSString stringWithFormat:@"expires_at:%@",dict[@"expires_at"]];
    cell.tokenLabel.text=[NSString stringWithFormat:@"token:%@",dict[@"token"]];
    
    cell.expiredtimeLabel.adjustsFontSizeToFitWidth=YES;
    cell.tokenLabel.adjustsFontSizeToFitWidth=YES;
    /*
     {
     client = spark;
     "expires_at" = "2014-05-15T17:18:28.368Z";
     token = 42fdf88d4c943579f3805817e26d7b39d1ccdfdd;
     }
     */
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160.0;
}
#pragma mark - UITableView Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PLControlViewController *controlVC=[[PLControlViewController alloc] initWithNibName:@"PLControlViewController" bundle:nil];
    controlVC.dict=[self.tableArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:controlVC animated:YES];
}
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
@end
