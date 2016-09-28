//
//  HelpViewController.h
//  privMD
//
//  Created by Rahul Sharma on 11/02/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CSAnimationView;
@interface HelpViewController : UIViewController<UIScrollViewDelegate>


@property (unsafe_unretained, nonatomic) IBOutlet UIView *bottomContainerView;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *signInBtn;

@property (unsafe_unretained, nonatomic) IBOutlet UIButton *registerBtn;

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *orLbl;

@property (strong, nonatomic) IBOutlet UIView *swipeLabel;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong , nonatomic) UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UILabel *swpLabel;

- (IBAction)signInButtonClicked:(id)sender;
- (IBAction)registerButtonClicked:(id)sender;
//- (IBAction)pageControllerButtonClicked:(id)sender;

@end
