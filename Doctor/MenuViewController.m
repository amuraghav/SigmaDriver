//
//  MenuViewController.m
//  Doctor
//
//  Created by Rahul Sharma on 18/04/14.
//  Copyright (c) 2014 3Embed. All rights reserved.
//

#import "MenuViewController.h"
#import "XDKAirMenuController.h"
#import "HomeVC/HomeViewController.h"
#import "ProfileVc/AccountViewController.h"
#import "Appointment/AppointmentViewController.h"
#import "AboutViewController.h"
#import "FAQViewController.h"

@interface MenuViewController ()<XDKAirMenuDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic , strong) HomeViewController *homeVC;
@property (nonatomic, strong) AccountViewController *accountVC;
@property (nonatomic , strong) AppointmentViewController *appointmentVC;
@property (nonatomic , strong) AboutViewController *aboutVC;
@property (nonatomic , strong) FAQViewController *faqVC;

@end

@implementation MenuViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.view setBackgroundColor:NavBarTint_Color];
   // [self.view setBackgroundColor:BG_COLOR];
    [_tableView setBackgroundColor:NavBarTint_Color];
    _tableView.contentSize = CGSizeMake(320,_tableView.frame.size.height);
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    if (IS_IOS7)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
	// Do any additional setup after loading the view, typically from a nib.
    
    //if (self.airMenuController) {
    //   [self.airMenuController removeFromParentViewController];
    // }
    
    self.airMenuController = [XDKAirMenuController sharedMenu];
    self.airMenuController.airDelegate = self;
    //self.airMenuController.isMenuOnRight = TRUE;
    [self.view addSubview:self.airMenuController.view];
    [self addChildViewController:self.airMenuController];
    
}

-(void)inviteUsers
{
    
}

/*
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (indexPath.row == 5) // For example
 {
 
 }// [self logout];
 else
 {
 [((id<UITableViewDelegate>)airMenuController) tableView:tableView didSelectRowAtIndexPath:indexPath];
 }
 }
 */

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"TableViewSegue"])
    {
        self.tableView = ((UITableViewController*)segue.destinationViewController).tableView;
    }
    
    
}


#pragma mark - XDKAirMenuDelegate

- (UIViewController*)airMenu:(XDKAirMenuController*)airMenu viewControllerAtIndexPath:(NSIndexPath*)indexPath
{
    UIStoryboard *storyboard = self.storyboard;
    UIViewController *vc = nil;
    
    vc.view.autoresizesSubviews = TRUE;
    vc.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
   
    
    if (indexPath.row == 0) //home
    {
      
        vc = [storyboard instantiateViewControllerWithIdentifier:@"ViewController1"];
        return vc;
    }
    else if (indexPath.row == 1) // Bookings
    {
        
        

     vc = [storyboard instantiateViewControllerWithIdentifier:@"appointmentViewController"];
        //}
        return vc;
    }
    if (indexPath.row == 2) // Profile
    {
       // if (!_accountVC) {
            vc = [storyboard instantiateViewControllerWithIdentifier:@"Profilevc"];
       // }
        return vc;
    }
   // else if (indexPath.row == 3) //support
   // {
       // if (!_faqVC) {
   //         vc = [storyboard instantiateViewControllerWithIdentifier:@"faqViewController"];
       // }
        
   //     return vc;
   // }
//    else if(indexPath.row == 3)//About
//    {
//     
//        
//        
////        UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle: @"Attention"
////                                                         message:@"Coming Soon!"                                                                                                            delegate:nil
////                                               cancelButtonTitle:@"OK"
////                                               otherButtonTitles:nil, nil];
////        [alert1 show];
////        vc = [storyboard instantiateViewControllerWithIdentifier:@"ViewController1"];
//
//        
//        vc = [storyboard instantiateViewControllerWithIdentifier:@"aboutVC"];
//        return vc;
//    }
    else if(indexPath.row == 3)//About
    {
        
        vc = [storyboard instantiateViewControllerWithIdentifier:@"resetPwdViewController"];
        return vc;
    }

    
    else if(indexPath.row == 4)//About
    {
        
        vc = [storyboard instantiateViewControllerWithIdentifier:@"aboutVC"];
        return vc;
    }

    
   
    else {
        
        return nil;
    }
    
}
#pragma mark Webservice Handler(Request) -

- (UITableView*)tableViewForAirMenu:(XDKAirMenuController*)airMenu
{
    return self.tableView;
}

@end
