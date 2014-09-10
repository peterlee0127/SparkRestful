//
//  PLLoginViewController.m
//  SparkRestful
//
//  Created by Peterlee on 2/19/14.
//  Copyright (c) 2014 Peterlee. All rights reserved.
//

#import "PLLoginViewController.h"
#import "PLWebViewController.h"
#import <MBProgressHUD.h>

@interface PLLoginViewController ()
{
    PLUserModel *userModel;
    IBOutlet UITextField *emailField;
    IBOutlet UITextField *passwordField;
}
@end

@implementation PLLoginViewController

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
      self.screenName = @"Login";
    
    userModel=[PLUserModel shareInstance];
    
    self.networkManager=[PLNetworkManager shareInstance];
    self.networkManager.delegate=self;
    
    if(![userModel.plistDict[@"account"] isEqualToString:@""])
    {
        emailField.text= [userModel loadAccount];
        passwordField.text= [userModel loadPassword];
    }
   
    
    // Do any additional setup after loading the view from its nib.
}
-(IBAction) loginPressed:(id)sender
{
    if([emailField.text isEqualToString:@""] || [passwordField.text isEqualToString:@""])
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Email or Password is null" message:@"Please check again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        [userModel saveUserData:emailField.text :passwordField.text];
    
        [self startLogin];
    }
}
-(IBAction) signUpPressed:(id)sender
{
    PLWebViewController *webVC =[[PLWebViewController alloc] initWithNibName:@"PLWebViewController" bundle:nil];
    webVC.url = [NSURL URLWithString:@"https://www.spark.io"];
    [self.navigationController pushViewController:webVC animated:YES];
}
-(void) startLogin
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading";
    
    [self.networkManager Userlogin:emailField.text :passwordField.text];
}
#pragma mark - NetworkManager Delegate
-(void) userLoginSuccess:(id) result
{
    NSArray *res=(NSArray *)result;
    NSMutableArray *tempArr = [[NSMutableArray alloc] init];
    for (int i=0; i<res.count; i++) {
        NSDictionary *dict = (NSDictionary *)res[i];
        if([dict[@"client"] isEqualToString:@"user"])
            [tempArr addObject:dict];
    }
    res = tempArr;
    
    if(res.count>0)
    {
        [self.delegate usersCore:res];
        [[PLUserModel shareInstance] saveDevices:res];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
}
-(void) userLoginFailed:(NSError *) error;
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Bad request, please check your Network or Email/Password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
 
}


-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

-(IBAction) closeKeyboard:(id)sender
{
    [emailField resignFirstResponder];
    [passwordField resignFirstResponder];
}

@end
