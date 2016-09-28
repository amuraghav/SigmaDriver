//
//  FAQViewController.m
//  privMD
//
//  Created by Rahul Sharma on 10/03/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import "FAQViewController.h"
#import "XDKAirMenuController.h"
#import "CustomNavigationBar.h"

@interface FAQViewController ()<CustomNavigationBarDelegate>
{
        NSArray *typeO;
        NSArray *typeoDetails;
        NSUInteger imgOffsetY;
}
@property(strong, nonatomic) UILabel *bottomLabel;
@end

@implementation FAQViewController

@synthesize mainScrollView;
@synthesize pageControl;
@synthesize bottomLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        typeoDetails = [[NSArray alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"suppor_phonearea_bg"]];
    typeO = [[NSArray alloc]initWithObjects:@"GET NEW BOOKING",@"DRIVER ARRIVE",@"DROP PASSENGER",@"RATE",nil];
    
    typeoDetails = [[NSArray alloc]initWithObjects:@"Get push notified for new booking request.",@"Notifyi passenger when you arrived.",@"Raise the invoice and get paid on dropping the passenger.",@"Help us to maintain a quality service by rating your experience.",nil];
    
    [self addCustomNavigationBar];
    [self createScrollingView];
    [self createBottomView1];
    //    [self createMessageView];
}

-(void)createScrollingView
{
    NSArray *colors = [[NSArray alloc]initWithObjects:
                       [UIImage imageNamed:@"support_newbooking"],
                       [UIImage imageNamed:@"support_arrive"],
                       [UIImage imageNamed:@"support_drop"],
                       [UIImage imageNamed:@"support_rate-568h@2x"],
                       nil];
    
    CGRect screen =  [[UIScreen mainScreen]bounds];
    if(IS_IPHONE_5)
    {
        mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,64,320,screen.size.height - 60)];
        imgOffsetY = 335;
    }
    
    else
    {
        mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,64,320,screen.size.height - 60)];
        imgOffsetY = 272;
        
    }
    
    [self.view addSubview:mainScrollView];
    
    self.mainScrollView.delegate = self;
    self.mainScrollView.contentSize = CGSizeMake(self.mainScrollView.frame.size.width * 4, self.mainScrollView.frame.size.height);
    mainScrollView.alwaysBounceHorizontal = NO;
    mainScrollView.alwaysBounceVertical = YES;
    mainScrollView.bounces = NO;
    mainScrollView.clipsToBounds = NO;
    mainScrollView.showsHorizontalScrollIndicator = NO;
    mainScrollView.showsVerticalScrollIndicator = NO;
    [mainScrollView setClipsToBounds:YES];
    //    UIImage *magnifierImage = [UIImage imageNamed:@"support_magnify-568h"];
    //    UIImageView *onSelf = [[UIImageView alloc]initWithFrame:mainScrollView.frame];
    //    onSelf.image = magnifierImage;
    //    [self.view addSubview:onSelf];
    
    for (int i = 0; i < 4; i++)
    {
        CGRect frame;
        frame.origin.x = self.mainScrollView.frame.size.width * i;
        frame.origin.y = 0;
        frame.size.height = imgOffsetY;
        frame.size.width = 320;
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:frame];
        imgView.image = [colors objectAtIndex:i];
        [self.mainScrollView addSubview:imgView];
        [self createBottomView:i];
    }
    
    [mainScrollView setPagingEnabled:YES];
    [self.mainScrollView setScrollEnabled:YES];
    [self.view bringSubviewToFront:pageControl];
    pageControl.transform = CGAffineTransformMakeRotation(M_PI/2.0);
}
-(void)createBottomView:(NSUInteger )widtH
{
    UIView *bottomView = [[UIView alloc]init];//WithFrame:CGRectMake(0,[UIScreen mainScreen].bounds.size.height-140,320,140)];
    if(IS_IPHONE_5)
    {
        bottomView.frame = CGRectMake(self.mainScrollView.frame.size.width * widtH,imgOffsetY, 320,150);
    }
    else
    {
        bottomView.frame = CGRectMake(self.mainScrollView.frame.size.width * widtH,imgOffsetY, 320,150);
    }
    bottomView.backgroundColor = [UIColor colorWithWhite:0.897 alpha:1.000];
    bottomView.tag = 99;
    
    UILabel *typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,5,320,30)];
    typeLabel.textAlignment = NSTextAlignmentCenter;
    typeLabel.backgroundColor = CLEAR_COLOR;
    typeLabel.tag = 100;
    [Helper setToLabel:typeLabel Text:[typeO objectAtIndex:widtH] WithFont:Robot_Regular FSize:15 Color:UIColorFromRGB(0x333333)];
    [bottomView addSubview:typeLabel];
    
    UILabel *typeDetailsLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,30,320,60)];
    typeDetailsLabel.numberOfLines = 2;
    typeDetailsLabel.textAlignment = NSTextAlignmentCenter;
    typeDetailsLabel.backgroundColor = CLEAR_COLOR;
    typeDetailsLabel.tag = 200;
    [Helper setToLabel:typeDetailsLabel Text:[typeoDetails objectAtIndex:widtH] WithFont:Robot_Regular FSize:15 Color:UIColorFromRGB(0x666666)];
    [bottomView addSubview:typeDetailsLabel];
    [mainScrollView addSubview:bottomView];
}
-(void)createBottomView1
{
    NSUInteger yOffset = [UIScreen mainScreen].bounds.size.height;
    pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(150,yOffset - 70,20,20)];
    pageControl.numberOfPages = 4;
    pageControl.currentPage = 0;
    pageControl.backgroundColor = CLEAR_COLOR;
    pageControl.pageIndicatorTintColor = UIColorFromRGB(0x666666);
    pageControl.currentPageIndicatorTintColor = UIColorFromRGB(0x333333);
    [pageControl addTarget:self action:@selector(pageControlClicked:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:pageControl];
    
    UIButton *BottomLabel = [UIButton buttonWithType:UIButtonTypeCustom];
    BottomLabel = [[UIButton alloc]initWithFrame:CGRectMake(10,yOffset - 50,300,40)];
    BottomLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [Helper setButton:BottomLabel Text:@" Have an issue visit RideOne.com" WithFont:Robot_Regular FSize:15 TitleColor:UIColorFromRGB(0xffffff) ShadowColor:nil];
    [BottomLabel addTarget:self action:@selector(websitebuttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [BottomLabel setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateHighlighted];
    [BottomLabel setBackgroundImage:[UIImage imageNamed:@"support_btn_website_off"] forState:UIControlStateNormal];
    [BottomLabel setBackgroundImage:[UIImage imageNamed:@"support_btn_website_on"] forState:UIControlStateHighlighted];
    [self.view addSubview:BottomLabel];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    
}
#pragma mark-scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pageHeight = self.mainScrollView.frame.size.width;
    // you need to have a **iVar** with getter for scrollView
    
    float fractionalPage = self.mainScrollView.contentOffset.x / pageHeight;
    NSInteger page = lround(fractionalPage);
    self.pageControl.currentPage = page;
    
    //    UIView *v = [self.view viewWithTag:99];
    //    UILabel *l = (UILabel *)[v viewWithTag:100];
    //    l.text = [typeO objectAtIndex:page];
    //    UILabel *l1 = (UILabel *)[v viewWithTag:200];
    //    l1.text = [typeoDetails objectAtIndex:page];
}

- (void)pageControlClicked:(id)sender
{
    //Call to remove the current view off to the left
    unsigned long int page = self.pageControl.currentPage;
    
    CGRect frame = mainScrollView.frame;
    frame.origin.x = 0;
    frame.origin.y = frame.size.width * page;
    [mainScrollView scrollRectToVisible:frame animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Custom Methods -

- (void) addCustomNavigationBar
{
    CustomNavigationBar *customNavigationBarView = [[CustomNavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    customNavigationBarView.tag = 78;
    customNavigationBarView.delegate = self;
    [customNavigationBarView setTitle:@"Support"];
    [customNavigationBarView setBackgroundColor:BLACK_COLOR];
    [self.view addSubview:customNavigationBarView];
    
}
-(void)leftBarButtonClicked:(UIButton *)sender{
    
    //    CGRect frame = mainScrollView.frame;
    //    frame.origin.x = 0;
    //    frame.origin.y = 64;
    //    [mainScrollView scrollRectToVisible:frame animated:YES];
    [self menuButtonPressedAccount];
}
-(void)websitebuttonClicked:(id)sender{
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://www.google.com"]];
}
- (void)menuButtonPressedAccount
{
    XDKAirMenuController *menu = [XDKAirMenuController sharedMenu];
    
    if (menu.isMenuOpened)
        [menu closeMenuAnimated];
    else
        [menu openMenuAnimated];
}


@end
