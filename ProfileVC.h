//
//  ProfileVC.h
//  CarApp
//
//  Created by Appypie Inc on 26/09/15.
//  Copyright (c) 2015 ons. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileVC : UIViewController
{
    IBOutlet UIView *DriverView;
    IBOutlet UIView *CarView;
    IBOutlet UIView *StatiticsView;
}


-(IBAction)accountview_action:(id)sender;
@end
