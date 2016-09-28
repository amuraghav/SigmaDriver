//
//  TermsnConditionViewController.m
//  privMD
//
//  Created by Rahul Sharma on 27/02/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import "TermsnConditionViewController.h"
#import "WebViewController.h"
@interface TermsnConditionViewController ()
@property(nonatomic,strong)IBOutlet UITableView *tableView;
@property(nonatomic,strong)NSArray *termsOptions;
@end

@implementation TermsnConditionViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


//-(void) createNavLeftButton
//{
//    // UIView *navView = [[UIView new]initWithFrame:CGRectMake(0, 0,50, 44)];
//    UIImage *buttonImage = [UIImage imageNamed:@"signup_btn_back_bg_on.png"];
//    UIButton *navCancelButton =  [UIButton buttonWithType:UIButtonTypeCustom];
//    
//    [navCancelButton addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
//    [navCancelButton setFrame:CGRectMake(0.0f,0.0f,buttonImage.size.width,buttonImage.size.height)];
//    
//    
//    [Helper setButton:navCancelButton Text:@"BACK" WithFont:Robot_Regular FSize:11 TitleColor:[UIColor blueColor] ShadowColor:nil];
//    [navCancelButton setTitle:@"BACK" forState:UIControlStateNormal];
//    [navCancelButton setTitle:@"BACK" forState:UIControlStateSelected];
//    [navCancelButton setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
//    [navCancelButton setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateHighlighted];
//    navCancelButton.titleLabel.font = [UIFont fontWithName:Robot_Regular size:11];
//    [navCancelButton setBackgroundImage:buttonImage forState:UIControlStateHighlighted];
//    
//    //Adding Button onto View
//    // [navView addSubview:navCancelButton];
//    
//    // Create a container bar button
//    UIBarButtonItem *containingcancelButton = [[UIBarButtonItem alloc] initWithCustomView:navCancelButton];
//    // UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithCustomView:segmentView];
//    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
//                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
//                                       target:nil action:nil];
//    negativeSpacer.width = -16;// it was -6 in iOS 6  you can set this as per your preference
//    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer,containingcancelButton, nil] animated:NO];
//    
//    
//    //  self.navigationItem.leftBarButtonItem = containingcancelButton;
//}
//

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
     [self addCustomNavigationBar];
    
     self.view.backgroundColor = BG_Color;

    
    
    self.title = @"Agreement";
    
    _termsOptions = @[@"Terms & Conditions",@"Privacy Policy"];
    
    
    
}

-(void)linkButtonClicked :(id)sender
{
    [self performSegueWithIdentifier:@"gotoWebView" sender:self];
    
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"gotoWebView"])
    {
        NSIndexPath *iPath = (NSIndexPath*)sender;
        WebViewController *webView = (WebViewController*)[segue destinationViewController];
        webView.titleStr = _termsOptions[iPath.row];
        
        if (iPath.row == 0) {
            webView.weburl = @"http://auscartaxiapp.onsisdev.info/driver_terms_and_conditions.php";
        }
        else if (iPath.row == 1) {
            webView.weburl = @"http://auscartaxiapp.onsisdev.info/privacy.php";
        }
      
        
        
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark UITableViewDelegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _termsOptions.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell setBackgroundColor:BUTTON_Color];
    }
    
    cell.textLabel.text = _termsOptions[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

#pragma mark - UITableViewDataSource Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    UITableViewCell *tableViewCell = [tableView cellForRowAtIndexPath:indexPath];
    //	[tableViewCell setSelected:NO animated:YES];
    
    [self performSegueWithIdentifier:@"gotoWebView" sender:indexPath];
    
}

- (void) addCustomNavigationBar
{
    
    UIView *customNavigationBarView = nil;
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0.0"))
    {
        customNavigationBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
        
    }else{
        customNavigationBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    }
    
    // Add navigationbar item
    
  //  customNavigationBarView.backgroundColor = [UIColor blackColor];
    
    [customNavigationBarView setBackgroundColor:NavBarTint_Color];
    
    //Add title
    UILabel *labelTitle = nil;
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0.0"))
    {
        labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, 320, 44)];
    }
    else
    {
        labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    }
    
    [Helper setToLabel:labelTitle Text:@"Agreement" WithFont:Robot_Regular FSize:15 Color:[UIColor whiteColor]];
    [labelTitle setTextAlignment:NSTextAlignmentCenter];
    [customNavigationBarView addSubview:labelTitle];
    
    //Add right Navigation button
    
    UIButton *leftNavButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0.0"))
    {
        leftNavButton.frame = CGRectMake(10, 5,50, 44);
    }
    else
    {
        leftNavButton.frame = CGRectMake(10, 0, 50, 44);
    }
    
    [Helper setButton:leftNavButton Text:@"Back" WithFont:Robot_Regular FSize:11 TitleColor:[UIColor whiteColor] ShadowColor:nil];
    [leftNavButton addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [customNavigationBarView addSubview:leftNavButton];
    [self.view addSubview:customNavigationBarView];
    self.navigationController.navigationBarHidden=YES;
    
}

-(void)cancelButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}



@end
