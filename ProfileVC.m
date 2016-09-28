//
//  ProfileVC.m
//  CarApp
//
//  Created by Appypie Inc on 26/09/15.
//  Copyright (c) 2015 ons. All rights reserved.
//

#import "ProfileVC.h"
#import "XDKAirMenuController.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageDownloader.h"
#import "ANBlurredImageView.h"
#import "CustomNavigationBar.h"
#import "SplashViewController.h"
#import "profile.h"
#import "HomeViewController.h"
#import "AccountViewController.h"
#import "PriveMdAppDelegate.h"

@interface ProfileVC () <CustomNavigationBarDelegate,UITableViewDataSource,UITableViewDelegate>
@property (strong) IBOutlet ANBlurredImageView *imageView;
@property(nonatomic,strong)profile *user;
@property(nonatomic,weak) IBOutlet UITableView *tableView;
@property(nonatomic,strong) UIImageView *profileImage;
@property(nonatomic,strong) UIImage *pickedImage;
@property(nonatomic,assign)BOOL isEditingModeOn;
@end

@implementation ProfileVC


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = YES;
    
        
    self.view.backgroundColor = BG_Color;
    
    
// UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
// [self.view addGestureRecognizer:tapGesture];
// View
    
    DriverView.layer.cornerRadius = 40 ;
    DriverView.layer.borderWidth = 1;
    DriverView.layer.borderColor = [UIColor whiteColor].CGColor;
    DriverView.clipsToBounds = true;
    
    CarView.layer.cornerRadius = 40;
    CarView.layer.borderWidth = 1;
    CarView.layer.borderColor = [UIColor whiteColor].CGColor;
    CarView.clipsToBounds = true;
    
    
    StatiticsView.layer.cornerRadius = 40;
    StatiticsView.layer.borderWidth = 1;
    StatiticsView.layer.borderColor = [UIColor whiteColor].CGColor;
    StatiticsView.clipsToBounds = true;

    [self addCustomNavigationBar];
    [[TELogger getInstance] initiateFileLogging];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark ButtonAction Methods -

- (void)menuButtonPressedAccount
{
    XDKAirMenuController *menu = [XDKAirMenuController sharedMenu];
    
    if (menu.isMenuOpened)
        [menu closeMenuAnimated];
    else
        [menu openMenuAnimated];
}


- (void)setSelectedButtonByIndex:(NSInteger)index {
    
}

#pragma mark Custom Methods -

- (void) addCustomNavigationBar
{
    CustomNavigationBar *customNavigationBarView = [[CustomNavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    customNavigationBarView.tag = 78;
    customNavigationBarView.delegate = self;
    [customNavigationBarView setTitle:@"PROFILE"];
    
    [customNavigationBarView setBackgroundColor:NavBarTint_Color];
    // [customNavigationBarView setRightBarButtonTitle:@"Edit"];
    [self.view addSubview:customNavigationBarView];
    
}

-(void)rightBarButtonClicked:(UIButton *)sender{
    
    if ([sender tag] == 200) {
        _isEditingModeOn = NO;
        sender.tag = 100;
        
        [sender setTitle:@"Edit" forState:UIControlStateNormal];
       
        
    }
    else{
        _isEditingModeOn = YES;
        sender.tag = 200;
        [sender setTitle:@"Update" forState:UIControlStateNormal];
    }
    
}
-(void)leftBarButtonClicked:(UIButton *)sender{
    [self menuButtonPressedAccount];
}
-(IBAction)accountview_action:(id)sender{
    
    PriveMdAppDelegate *appDelegate = (PriveMdAppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.sectionIndex=[sender tag];
    
    UIStoryboard *storyboard = self.storyboard;
    UIViewController *vc = nil;
    vc.view.autoresizesSubviews = TRUE;
    vc.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    vc = [storyboard instantiateViewControllerWithIdentifier:@"ViewController2"];
 
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
        if ([[segue identifier] isEqualToString:@"ViewController2"])
       {
           ///TermsnConditionViewController *TNCVC = (TermsnConditionViewController*)[segue destinationViewController];
           
           NSLog(@"123");

    
       }
    
}



@end
