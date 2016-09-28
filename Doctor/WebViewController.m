//
//  WebViewController.m
//  Loupon
//
//  Created by Rahul Sharma on 08/01/14.
//  Copyright (c) 2014 3Embed. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

@synthesize webView,weburl,titleStr;
@synthesize backButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)backButtonclicked
{

    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}


- (void) addCustomNavigationBar
{
    
    UIView *customNavigationBarView = nil;
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0.0"))
    {
        customNavigationBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
        
    }else{
        customNavigationBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    }
    
    // Add navigationbar item
    
   // customNavigationBarView.backgroundColor = [UIColor blackColor];
    [customNavigationBarView setBackgroundColor:NavBarTint_Color];

    
    //Add title
    UILabel *labelTitle = nil;
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0.0"))
    {
        labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 320, 44)];
    }
    else
    {
        labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    }
    
    [Helper setToLabel:labelTitle Text:titleStr WithFont:Robot_Regular FSize:15 Color:[UIColor whiteColor]];
    [labelTitle setTextAlignment:NSTextAlignmentCenter];
    [customNavigationBarView addSubview:labelTitle];
    
    //Add right Navigation button
    
    UIButton *leftNavButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0.0"))
    {
        leftNavButton.frame = CGRectMake(10, 20,50, 44);
    }
    else
    {
        leftNavButton.frame = CGRectMake(10, 0, 50, 44);
    }
    
    [Helper setButton:leftNavButton Text:@"Back" WithFont:Robot_Regular FSize:11 TitleColor:[UIColor whiteColor] ShadowColor:nil];
    [leftNavButton addTarget:self action:@selector(gotoRootViewController) forControlEvents:UIControlEventTouchUpInside];
    [customNavigationBarView addSubview:leftNavButton];
    [self.view addSubview:customNavigationBarView];
    
    self.navigationController.navigationBarHidden=YES;
    
    
    
}



-(void)gotoRootViewController
{
   
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addCustomNavigationBar];
    webView.delegate= self;
    NSURL *url = [NSURL URLWithString:weburl];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [webView loadRequest:requestObj];
    ProgressIndicator *pi = [ProgressIndicator sharedInstance];
    [pi showPIOnView:self.view withMessage:@""];
    
}

- (void)viewDidUnload
{
 
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.webView stopLoading];
    self.webView.delegate = nil;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    ProgressIndicator *progressIndicator = [ProgressIndicator sharedInstance];
    [progressIndicator showPIOnView:self.view withMessage:@"Loading.."];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    ProgressIndicator *pi = [ProgressIndicator sharedInstance];
    [pi hideProgressIndicator];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    ProgressIndicator *pi = [ProgressIndicator sharedInstance];
    [pi hideProgressIndicator];
}



@end
