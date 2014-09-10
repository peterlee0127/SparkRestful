//
//  PLWebViewController.m
//  SparkRestful
//
//  Created by Peterlee on 8/19/14.
//  Copyright (c) 2014 Peterlee. All rights reserved.
//

#import "PLWebViewController.h"
#import <MBProgressHUD.h>

@interface PLWebViewController () <UIWebViewDelegate>

@property (nonatomic,strong) IBOutlet UIWebView *webView;

@end

@implementation PLWebViewController

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
    self.url = [NSURL URLWithString:@"https://www.spark.io"];
    self.title = @"Spark Core";
    
   self.screenName = @"SparkCoreWeb";
    // Do any additional setup after loading the view from its nib.
}
-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.webView.frame = self.view.frame;
    

    NSURLRequest *requst = [[NSURLRequest alloc] initWithURL:self.url];
    [self.webView loadRequest:requst];
    
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Loading";
  
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    if(!self.webView.isLoading)
    {
        [self hideHUD];
    }

}
-(void) hideHUD
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"%@",error);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
