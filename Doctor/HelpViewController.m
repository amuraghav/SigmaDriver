//
//  HelpViewController.m
//  privMD
//
//  Created by Rahul Sharma on 11/02/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import "HelpViewController.h"
#import "SignInViewController.h"
#import "SignUpViewController.h"
#import "Helper.h"
#import "Fonts.h"

//#import <Canvas/CSAnimationView.h>

@interface HelpViewController ()

@end

@implementation HelpViewController
@synthesize bottomContainerView;
@synthesize signInBtn;
@synthesize registerBtn;
@synthesize mainScrollView;
@synthesize pageControl;
@synthesize orLbl;

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
    
    //[[UIApplication sharedApplication] setStatusBarHidden:YES];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (IS_IPHONE_5) {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"320X567.png"]];
    }
    else if(IS_IPHONE_6)
    {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"375X667.png"]];
    }
else if (IS_IPHONE_6_Plus)
{
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"414x736.png"]];
}
    else {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"320X480.png"]];
    }
    
    
 
    
    
    
  
    [self.view bringSubviewToFront:bottomContainerView];
    [self.view bringSubviewToFront:pageControl];
    
    bottomContainerView.frame = CGRectMake(0,568, 320,65);
    bottomContainerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"roadyo_footer.png"]];
    
    //    NSMutableArray * colors = [[NSMutableArray alloc]initWithObjects: [UIImage imageNamed:@"roadyo_bg-568h.png"],
    //                               [UIImage imageNamed:@"roadyo_bg-568h.png"],
    //                               [UIImage imageNamed:@"roadyo_bg-568h.png"],
    //                               [UIImage imageNamed:@"roadyo_bg-568h.png"],
    //                               [UIImage imageNamed:@"roadyo_bg-568h.png"],nil];
    //
    //
    //    CGRect screen =  [[UIScreen mainScreen]bounds];
    //    mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320,screen.size.height)];
    //    [self.view addSubview:mainScrollView];
    //
    //    self.mainScrollView.delegate = self;
    //    self.mainScrollView.contentSize = CGSizeMake(self.mainScrollView.frame.size.width, self.mainScrollView.frame.size.height * 5);
    //    self.mainScrollView.backgroundColor = [UIColor clearColor];
    //
    //    for (int i = 0; i < 5; i++)
    //    {
    //
    //        CGRect frame;
    //        frame.origin.x = 0;
    //        frame.origin.y = self.mainScrollView.frame.size.height * i;
    //        frame.size = self.mainScrollView.frame.size;
    //        UIImageView *imgView = [[UIImageView alloc] initWithFrame:frame];
    //        imgView.image = [colors objectAtIndex:i];
    //
    //        [self.mainScrollView addSubview:imgView];
    //    }
    //
    //    [mainScrollView setPagingEnabled:YES];
    //    [self.mainScrollView setScrollEnabled:YES];
    //    mainScrollView.backgroundColor = [UIColor clearColor];
    //
    //    pageControl.transform = CGAffineTransformMakeRotation(M_PI/2.0);
    //topView.backgroundColor = [UIColor redColor];
    [self.view bringSubviewToFront:bottomContainerView];
    // [self.view bringSubviewToFront:middleView];
    

    
    [Helper setButton:signInBtn Text:@"SIGN IN" WithFont:Robot_Regular FSize:15 TitleColor:WHITE_COLOR ShadowColor:nil];
    signInBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [signInBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateHighlighted];
    signInBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [signInBtn setBackgroundImage:[UIImage imageNamed:@"roadyo_btn_signin_btn"] forState:UIControlStateHighlighted];
    
    
    [Helper setButton:registerBtn Text:@"SIGN UP" WithFont:Robot_Regular FSize:15 TitleColor:WHITE_COLOR ShadowColor:nil];
    [registerBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateHighlighted];
    registerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    registerBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [registerBtn setBackgroundImage:[UIImage imageNamed:@"roadyo_btn_register_btn"] forState:UIControlStateHighlighted];
    
      _swpLabel.frame = CGRectMake(240,[UIScreen mainScreen].bounds.size.height-64-50,60,30);
    orLbl.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"roadyo_btn_or_on.png"]];
    [self.view bringSubviewToFront:_swpLabel];
    [Helper setToLabel:_swpLabel Text:@"swipe up" WithFont:Robot_Regular FSize:14 Color:UIColorFromRGB(0xffffff)];
    
//    pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(280,[UIScreen mainScreen].bounds.size.height-64-50,50,20)];
//    pageControl.numberOfPages = 5;
//    pageControl.currentPage = 0;
//    pageControl.backgroundColor = CLEAR_COLOR;
//    pageControl.pageIndicatorTintColor = [UIColor colorWithRed:0.972 green:0.814 blue:0.050 alpha:1.000];
//    pageControl.currentPageIndicatorTintColor = [UIColor colorWithWhite:0.922 alpha:1.000];;
//    [pageControl addTarget:self action:@selector(pageControlClicked:) forControlEvents:UIControlEventValueChanged];
//    pageControl.transform = CGAffineTransformMakeRotation(M_PI / 2);
//    [pageControl setHidden:YES];
//    
//    [self.view addSubview:pageControl];
}

-(void)viewDidAppear:(BOOL)animated;
{
    [self startAnimationUp];
  
}

-(void)startAnimationDown
{
    [UIView animateWithDuration:0.1
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^
     {
         CGRect frame = bottomContainerView.frame;
         frame.origin.y = [[UIScreen mainScreen] bounds].size.height;
         frame.origin.x = 0;
         bottomContainerView.frame = frame;
     }
                     completion:^(BOOL finished)
     {
         NSLog(@"Completed");
         
     }];
}
-(void)startAnimationUp
{
    
    bottomContainerView.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height, 320, 65);

    [UIView animateWithDuration:0.1
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^
     {
         CGRect frame = bottomContainerView.frame;
         frame.origin.y = [[UIScreen mainScreen] bounds].size.height-65;
         frame.origin.x = 0;
         bottomContainerView.frame = frame;
     }
    completion:^(BOOL finished)
     {
         NSLog(@"Completed");
         
     }];
}


#pragma mark-scrollView delegate

//- (void)scrollViewDidScroll:(UIScrollView *)sender
//{
//    CGFloat pageHeight = self.mainScrollView.frame.size.height;
//    // you need to have a **iVar** with getter for scrollView
//    
//    float fractionalPage = self.mainScrollView.contentOffset.y / pageHeight;
//    NSInteger page = lround(fractionalPage);
//    self.pageControl.currentPage = page;
//}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    self.navigationItem.hidesBackButton = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signInButtonClicked:(id)sender
{
    [self startAnimationDown];
    [self performSegueWithIdentifier:@"SignIn" sender:self];
}

//- (IBAction)pageControllerButtonClicked:(id)sender {
//    NSLog(@"pageControl position %ld", (long)[self.pageControl currentPage]);
//    //Call to remove the current view off to the left
//    unsigned long int page = self.pageControl.currentPage;
//    
//    CGRect frame = mainScrollView.frame;
//    frame.origin.x = 0;
//    frame.origin.y = frame.size.width * page;
//    [mainScrollView scrollRectToVisible:frame animated:YES];
//}


- (IBAction)registerButtonClicked:(id)sender {
    [self startAnimationDown];
    [self performSegueWithIdentifier:@"SignUp" sender:self];
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"SignIn"])
    {
        SignInViewController *SVC = [[SignInViewController alloc]init];
        
        SVC =[segue destinationViewController];

    }
    else
    {
        SignUpViewController *SVC = [[SignUpViewController alloc]init];
        
        SVC =[segue destinationViewController];
    }
    
}

-(void)callPush
{
   // LoginViewController *LVC=[[LoginViewController alloc] init];
    [UIView  beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
  //  [self.navigationController pushViewController:LVC animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
}
//   Call Pop

-(void)callPop
{
    [UIView  beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.75];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelay:0.375];
    [self.navigationController popViewControllerAnimated:NO];
    [UIView commitAnimations];
}

@end
