//
//  PLControlViewController.m
//  SparkRestful
//
//  Created by Peterlee on 2/19/14.
//  Copyright (c) 2014 Peterlee. All rights reserved.
//

#import "PLControlViewController.h"
#import "PLNetworkManager.h"
#import <MBProgressHUD.h>

@interface PLControlViewController () <PLNetworkManagerDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSArray *headerTitle;

@end

@implementation PLControlViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.sendButton = [[UIButton alloc] init];
    self.functionField = [[UITextField alloc] init];
    self.argumentField = [[UITextField alloc] init];
    self.headerTitle = @[@"Core Information",@"functions",@"variables"];
    self.functions = @[];
    self.variables = @[];
    [self.sendButton setTitle:@"Send" forState:UIControlStateNormal];
    self.sendButton.backgroundColor = [UIColor grayColor];
    [self.sendButton addTarget:self action:@selector(sendArguments:) forControlEvents:UIControlEventTouchDown];
    
    self.screenName = @"Control";
    self.title= @"Spark Cloud";
    self.navigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc]
                                                                         initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    [PLNetworkManager shareInstance].delegate = self;
    [[PLNetworkManager shareInstance] getDeviceInf:self.dict[@"token"]];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Refresh" style:UIBarButtonItemStylePlain target:self action:@selector(refresh)];
    
    
  
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closekeyboard)];
    tapGesture.numberOfTapsRequired = 1;
    [self.tableView addGestureRecognizer:tapGesture];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.client=[NSString stringWithFormat:@"client:%@",self.dict[@"client"]];
    self.expiredtime=[NSString stringWithFormat:@"expires_at:%@",self.dict[@"expires_at"]];
    self.token=[NSString stringWithFormat:@"token:%@",self.dict[@"token"]];
    
   MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
   hud.labelText = @"Loading Device";
    [self.tableView reloadData];
}
-(void) refresh
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"Loading Device";
    [[PLNetworkManager shareInstance] getDeviceInf:self.dict[@"token"]];
}
#pragma mark - UITableView DataSource

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SparkCore"];
    if(!cell){
        cell = [[UITableViewCell alloc] init];
        switch (indexPath.section) {
            case 0:
            {
                switch (indexPath.row) {
                    case 0:
                    {
                        cell.textLabel.text = [NSString stringWithFormat:@"Name:%@",self.coreName];
                        break;
                    }
                    case 1:
                    {
                        cell.textLabel.text = self.client;
                        break;
                    }
                    case 2:
                    {
                        cell.textLabel.text = [NSString stringWithFormat:@"deviceID:%@",self.deviceID];
                        break;
                    }
                    case 3:
                    {
                        cell.textLabel.text = self.token;
                        break;
                    }
                    case 4:
                    {
                        cell.textLabel.text = self.expiredtime;
                        break;
                    }
                    case 5:
                    {
                        if([self.connected isEqualToString:@"isConnected"])
                            cell.textLabel.textColor = [UIColor greenColor];
                        else
                            cell.textLabel.textColor = [UIColor redColor];
                        
                        cell.textLabel.text = self.connected;
                        break;
                    }
                    case 6:
                    {
                        cell.textLabel.text = self.core_version;
                        break;
                    }
                    default:
                        break;
                }
                break;
            }
            case 1:
            {
                cell.textLabel.text = self.functions[indexPath.row];
                break;
            }
            case 2:
            {
                cell.textLabel.text = self.variables[indexPath.row];
                break;
            }
        }
    }
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        {
            return 7;
        }
        case 1:
        {
            return self.functions.count;
        }
        default:
        {
            if(self.variables.count>0)
                return self.variables.count-1;
            else
                return 0;
        }
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section==0){
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 160)];
        headerView.backgroundColor = [UIColor colorWithWhite:0.953 alpha:1.000];
    
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.text = self.headerTitle[section];
        [headerView addSubview:textLabel];

        self.functionField.frame = CGRectMake(self.view.frame.size.width*0.1, 50, self.view.frame.size.width*0.6, 30);
        self.functionField.placeholder = @"function";
        self.functionField.backgroundColor = [UIColor whiteColor];
        self.argumentField.frame = CGRectMake(self.view.frame.size.width*0.1, 100, self.view.frame.size.width*0.6, 30);
        self.argumentField.placeholder = @"args";
        self.argumentField.backgroundColor = [UIColor whiteColor];
        
        self.sendButton.frame = CGRectMake(self.view.frame.size.width*0.75, 60, self.view.frame.size.width*0.2, 50);
        [headerView addSubview:self.sendButton];
        
        [headerView addSubview:self.functionField];
        [headerView addSubview:self.argumentField];
    
        return headerView;
    }
    else{
       UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
       headerView.backgroundColor = [UIColor colorWithWhite:0.953 alpha:1.000];
       
        UILabel *textLabel = [[UILabel alloc] initWithFrame:headerView.frame];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.text = self.headerTitle[section];
        [headerView addSubview:textLabel];
        
        return headerView;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==0)
        return 160;
    else
        return 40;
}

#pragma marl - UITableView Delegate


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
        [tableView deselectRowAtIndexPath:indexPath animated:NO];

}
-(void)getDeviceInfSuccess:(NSDictionary *)dict
{
//    NSLog(@"getDeviceInfSuccess:%@",dict);
    self.deviceID = dict[@"id"];
    self.core_version = [NSString stringWithFormat:@"cc3000_patch_version:%@",dict[@"cc3000_patch_version"]];
    BOOL connect = dict[@"connected"];
    if(connect){
        self.connected = @"isConnected";
    }else{
        self.connected = @"notConnected";
    }
    
    NSString *func = [NSString stringWithFormat:@"%@",dict[@"functions"]];
    func = [func stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    func = [func stringByReplacingOccurrencesOfString:@"(" withString:@""];
    func = [func stringByReplacingOccurrencesOfString:@")" withString:@""];
    self.functions = [func componentsSeparatedByString:@","];
    
    NSString *variable = [NSString stringWithFormat:@"%@",dict[@"variables"]];
    variable = [variable stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    variable = [variable stringByReplacingOccurrencesOfString:@"{" withString:@""];
    variable = [variable stringByReplacingOccurrencesOfString:@"}" withString:@""];
    self.variables  = [variable componentsSeparatedByString:@";"];
    
    self.coreName = dict[@"name"];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        [self.tableView reloadData];
    });
}
-(void)getDeviceInfFail
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    });
}

// Sent
-(void) sentActionSuccess:(NSString *)successString
{
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Send Success" message:successString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}
-(void) sentActionFail:(NSString *)errorString
{
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Send fail" message:errorString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}
-(IBAction) sendArguments:(id)sender
{
    [self.argumentField resignFirstResponder];
    [self.functionField resignFirstResponder];
    
    if([self.functionField.text isEqualToString:@""] || [self.argumentField.text isEqualToString:@""] || [self.deviceID isEqualToString:@"fetching DeviceID"])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Please check again :(" message:@"TextField can't not be null." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    hud.labelText = @"Sending Action to Spark Cloud";
    hud.detailsLabelText = @"Please wait...";
    [[PLNetworkManager shareInstance] SentAction:self.dict[@"token"] deviceId:self.deviceID func:self.functionField.text args:self.argumentField.text];

}
-(void) closekeyboard
{
    [self.argumentField resignFirstResponder];
    [self.functionField resignFirstResponder];
}

@end
