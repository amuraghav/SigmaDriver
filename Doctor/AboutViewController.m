//
//  AboutViewController.m
//  Roadyo
//
//  Created by Rahul Sharma on 25/06/14.
//  Copyright (c) 2014 3Embed. All rights reserved.
//

#import "AboutViewController.h"
#import "XDKAirMenuController.h"
#import "CustomNavigationBar.h"
#import "WebViewController.h"
#import "TermsnConditionViewController.h"

@interface AboutViewController () <CustomNavigationBarDelegate>

@end

@implementation AboutViewController
@synthesize topView;
@synthesize topLabel;
@synthesize bottomLabel;
@synthesize likeButton;
@synthesize rateButton;
@synthesize legalButton;
@synthesize compantyDetailsButton;

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
	// Do any additional setup after loading the view.
    [self addCustomNavigationBar];
     self.view.backgroundColor = BG_Color;
}

-(void)viewWillAppear:(BOOL)animated
{
   //[self.view setBackgroundColor:[UIColor whiteColor]];
    
    
    
    [Helper setToLabel:topLabel Text:@"Your Car, We'll Drive" WithFont:Robot_Regular FSize:13 Color:[UIColor blackColor]];
    [Helper setToLabel:bottomLabel Text:@"www.sigma.com" WithFont:Robot_Regular FSize:11 Color:[UIColor blueColor]];
    
    
    [Helper setButton:rateButton Text:@"RATE US IN THE APP STORE" WithFont:Robot_Regular FSize:15 TitleColor:[UIColor blackColor] ShadowColor:nil];
    rateButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    rateButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [rateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [rateButton setBackgroundColor:BUTTON_Color];
    // [rateButton setBackgroundImage:[UIImage imageNamed:@"about_cell_selector"] forState:UIControlStateHighlighted];
    
    [Helper setButton:likeButton Text:@"LIKE US ON FACEBOOK" WithFont:Robot_Regular FSize:15 TitleColor:[UIColor blackColor] ShadowColor:nil];
    likeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    likeButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [likeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [likeButton setBackgroundColor:BUTTON_Color];
    //[likeButton setBackgroundImage:[UIImage imageNamed:@"about_cell_selector"] forState:UIControlStateHighlighted];
    
    [Helper setButton:legalButton Text:@"LEGAL" WithFont:Robot_Regular FSize:15 TitleColor:[UIColor blackColor] ShadowColor:nil];    legalButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    legalButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [legalButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [legalButton setBackgroundColor:BUTTON_Color];
    
// [legalButton setBackgroundImage:[UIImage imageNamed:@"about_cell_selector"] forState:UIControlStateHighlighted];
//    [Helper setButton:compantyDetailsButton Text:@"COMPANY DETAILS" WithFont:Robot_Regular FSize:15 TitleColor:[UIColor blackColor] ShadowColor:nil];    compantyDetailsButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    compantyDetailsButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
//    [compantyDetailsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
//    //COMPANY DETAILS
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Custom Methods -

- (void) addCustomNavigationBar{
    
    CustomNavigationBar *customNavigationBarView = [[CustomNavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    customNavigationBarView.tag = 78;
    customNavigationBarView.delegate = self;
    [customNavigationBarView setTitle:@"ABOUT"];
    [customNavigationBarView setBackgroundColor:NavBarTint_Color];
    [self.view addSubview:customNavigationBarView];
    
}
-(void)leftBarButtonClicked:(UIButton *)sender{
    [self menuButtonPressedAccount];
}

- (void)menuButtonPressedAccount
{
    XDKAirMenuController *menu = [XDKAirMenuController sharedMenu];
    
    if (menu.isMenuOpened)
        [menu closeMenuAnimated];
    else
        [menu openMenuAnimated];
}

- (IBAction)rateButtonClicked:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@""]];
    WebViewController *webView = [self.storyboard instantiateViewControllerWithIdentifier:@"webView"];
    webView.titleStr = @"App store";
    webView.weburl = @"http://www.google.com";
    [self.navigationController pushViewController:webView animated:YES];
}
- (IBAction)likeonFBButtonClicked:(id)sender {
  
    WebViewController *webView = [self.storyboard instantiateViewControllerWithIdentifier:@"webView"];
    webView.titleStr = @"Facebook";
    webView.weburl = @"https://www.facebook.com/RideOne";
    [self.navigationController pushViewController:webView animated:YES];
}

- (IBAction)legalButtonClicked:(id)sender {
   
    TermsnConditionViewController *webView = [self.storyboard instantiateViewControllerWithIdentifier:@"termsVC"];
    [self.navigationController pushViewController:webView animated:YES];
}

- (IBAction)detailbuttonClicked:(id)sender {

    WebViewController *webView = [self.storyboard instantiateViewControllerWithIdentifier:@"webView"];
    webView.titleStr = @"Company Details";
    webView.weburl = @"http://twynsllcapp.onsisdev.info/company.php";
    [self.navigationController pushViewController:webView animated:YES];
}


@end
