//
//  XDKAirMenuController.m
//  XDKAirMenu
//
//  Created by Xavier De Koninck on 29/12/2013.
//  Copyright (c) 2013 XavierDeKoninck. All rights reserved.
//

#import "XDKAirMenuController.h"
#import "XDKMenuCell.h"
#import "User.h"
#import "SplashViewController.h"
#import "HelpViewController.h"
#import "LocationTracker.h"
#import <AXRatingView/AXRatingView.h>


#define WIDTH_OPENED (93.0f)
#define MIN_SCALE_CONTROLLER (0.6f)
#define MIN_SCALE_TABLEVIEW (0.8f)
#define MIN_ALPHA_TABLEVIEW (0.01f)
#define DELTA_OPENING (65.f)


@interface XDKAirMenuController ()<UITableViewDelegate, UIGestureRecognizerDelegate,UITableViewDataSource,UserDelegate>


@property (nonatomic, strong) NSArray *images_off;
@property (nonatomic, strong) NSArray *images_on;
@property (nonatomic, strong) NSArray *menuTitle;

@property (nonatomic, assign) CGPoint startLocation;
@property (nonatomic, assign) CGPoint lastLocation;
@property (nonatomic, weak) UITableView *tableView;

@property (nonatomic, assign) CGFloat widthOpened;
@property (nonatomic, assign) CGFloat minScaleController;
@property (nonatomic, assign) CGFloat minScaleTableView;
@property (nonatomic, assign) CGFloat minAlphaTableView;
@property UIPanGestureRecognizer *panGesture, *panGesture1;

@end


@implementation XDKAirMenuController
@synthesize panGesture,panGesture1;
static XDKAirMenuController *controller = nil;

//+ (instancetype)sharedMenu
//{
//    static XDKAirMenuController *controller = nil;
//
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        controller = [[XDKAirMenuController alloc] init];
//    });
//
//    return controller;
//}

+ (id)sharedMenu {
    
	if (!controller) {
        
		controller  = [[XDKAirMenuController alloc] init];
	}
	
	return controller;
}
-(void)sharedRelease {
    
    for (UIGestureRecognizer *recognizer in self.currentViewController.view.gestureRecognizers) {
        if ([recognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
            
        }else {
        NSLog(@"removing gesture : %@", recognizer);
        recognizer.delegate = nil;
        [self.currentViewController.view removeGestureRecognizer:recognizer];
        }
    }
    
}
+(BOOL)relese{
    [controller.panGesture.view removeGestureRecognizer:controller.panGesture];
    [controller.panGesture1.view removeGestureRecognizer:controller.panGesture1];
    controller.panGesture.delegate = nil;
    controller.panGesture = nil;
    controller.panGesture1.delegate = nil;
    controller.panGesture1 = nil;
    UIWindow *frontWindow = [[UIApplication sharedApplication] keyWindow];
    
    for (UIGestureRecognizer *recognizer in frontWindow.gestureRecognizers) {
        [frontWindow removeGestureRecognizer:recognizer];
    }
    
    
    NSArray *gestrue =  [[[XDKAirMenuController sharedMenu] view] gestureRecognizers];
    for (UIGestureRecognizer *recognizer in gestrue) {
        [[[XDKAirMenuController sharedMenu] view] removeGestureRecognizer:recognizer];
    }
    
    
    [[self sharedMenu] sharedRelease];
    controller.airDelegate = Nil;
    controller = Nil;
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _images_off = [[NSArray alloc]initWithObjects:@"menu_home",@"menu_booking",@"menu_user",@"menu_user",@"menu_info",@"menu_logout", nil];
    
    _images_on = [[NSArray alloc]initWithObjects:@"menu_home_on",@"menu_payment_on",@"menu_user_on",@"menu_user_on",@"menu_info_on",@"menu_logout_on", nil];
    
    _menuTitle = [[NSArray alloc]initWithObjects:NSLocalizedString(@"HOME", @"HOME"),NSLocalizedString(@"HISTORY", @"HISTORY"),NSLocalizedString(@"PROFILE", @"PROFILE"),NSLocalizedString(@"RESET PASSWORD", @"RESET PASSWORD"),NSLocalizedString(@"ABOUT", @"ABOUT"),NSLocalizedString(@"LOGOUT", @"LOGOUT"),nil];
    
    if ([self.airDelegate respondsToSelector:@selector(tableViewForAirMenu:)])
    {
        self.tableView = [self.airDelegate tableViewForAirMenu:self];
        self.tableView.backgroundColor = [UIColor clearColor];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
    
    self.widthOpened = WIDTH_OPENED;
    self.minAlphaTableView = MIN_ALPHA_TABLEVIEW;
    self.minScaleTableView = MIN_SCALE_TABLEVIEW;
    self.minScaleController = MIN_SCALE_CONTROLLER;
    
    if ([self.airDelegate respondsToSelector:@selector(widthControllerForAirMenu:)])
        self.widthOpened = [self.airDelegate widthControllerForAirMenu:self];
    
    if ([self.airDelegate respondsToSelector:@selector(minAlphaTableViewForAirMenu:)])
        self.minAlphaTableView = [self.airDelegate minAlphaTableViewForAirMenu:self];
    
    if ([self.airDelegate respondsToSelector:@selector(minScaleTableViewForAirMenu:)])
        self.minScaleTableView = [self.airDelegate minScaleTableViewForAirMenu:self];
    
    if ([self.airDelegate respondsToSelector:@selector(minScaleControllerForAirMenu:)])
        self.minScaleController = [self.airDelegate minScaleControllerForAirMenu:self];
    
    
    _isMenuOpened = FALSE;
    [self openViewControllerAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    
    //[self.navigationController setNavigationBarHidden:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    
    
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    
    //    for (UIGestureRecognizer *gesture in frontWindow.gestureRecognizers) {
    //        if ([gesture isKindOfClass:[UIPanGestureRecognizer class]]) {
    //            [frontWindow removeGestureRecognizer:gesture];
    //            NSLog(@"gesrue on window: %@",gesture);
    //        }
    //    }
    
    if (panGesture) {
        [panGesture.view removeGestureRecognizer:panGesture];
        panGesture.delegate = nil;
        panGesture = nil;
    }
    
    
    UIWindow *frontWindow = [[UIApplication sharedApplication] keyWindow];
    panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    panGesture.delegate = self;
    [frontWindow addGestureRecognizer:panGesture];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    if (self.isMenuOpened)
        [self closeMenuAnimated];
}


#pragma mark - Gestures

- (void)panGesture:(UIPanGestureRecognizer *)sender {
    
    if (sender.state == UIGestureRecognizerStateBegan)
        self.startLocation = [sender locationInView:self.view];
    else if (sender.state == UIGestureRecognizerStateEnded
             && (self.isMenuOpened
                 || ((self.startLocation.x < DELTA_OPENING && !self.isMenuOnRight)
                     || (self.startLocation.x > self.currentViewController.view.frame.size.width -DELTA_OPENING && self.isMenuOnRight))))
    {
        CGFloat dx = self.lastLocation.x - self.startLocation.x;
        
        if (self.isMenuOnRight)
        {
            if ((self.isMenuOpened && dx > 0.f) || self.view.frame.origin.x > 3*self.view.frame.size.width / 4)
                [self closeMenuAnimated];
            else
                [self openMenuAnimated];
        }
        else
        {
            if ((self.isMenuOpened && dx < 0.f) || self.view.frame.origin.x < self.view.frame.size.width / 4)
                [self closeMenuAnimated];
            else
                [self openMenuAnimated];
        }
        
    }
    else if (sender.state == UIGestureRecognizerStateChanged
             && (self.isMenuOpened
                 || ((self.startLocation.x < DELTA_OPENING && !self.isMenuOnRight)
                     || (self.startLocation.x > self.currentViewController.view.frame.size.width -DELTA_OPENING && self.isMenuOnRight))))
        [self menuDragging:sender];
    
}
- (void)menuDragging:(UIPanGestureRecognizer *)sender
{
    CGPoint stopLocation = [sender locationInView:self.view];
    self.lastLocation = stopLocation;
    
    CGFloat dx = stopLocation.x - self.startLocation.x;
    
    CGFloat distance = dx;
    
    CGFloat width = (self.isMenuOnRight) ? (-self.view.frame.size.width + self.widthOpened) : (self.view.frame.size.width - self.widthOpened);
    
    
    CGFloat scaleController = 1 - ((self.view.frame.origin.x / width) * (1-self.minScaleController));
    
    CGFloat scaleTableView = 1 - ((1 - self.minScaleTableView) + ((self.view.frame.origin.x / width) * (-1+self.minScaleTableView)));
    
    CGFloat alphaTableView = 1 - ((1 - self.minAlphaTableView) + ((self.view.frame.origin.x / width) * (-1+self.minAlphaTableView)));
    
    
    if (scaleTableView < self.minScaleTableView)
        scaleTableView = self.minScaleTableView;
    
    if (scaleController > 1.f)
        scaleController = 1.f;
    
    self.tableView.transform = CGAffineTransformMakeScale(scaleTableView, scaleTableView);
    
    self.tableView.alpha = alphaTableView;
    
    self.currentViewController.view.transform = CGAffineTransformMakeScale(scaleController, scaleController);
    
    CGRect frame = self.view.frame;
    frame.origin.x = frame.origin.x + distance;
    
    if (self.isMenuOnRight)
    {
        if (frame.origin.x < -frame.size.width)
            frame.origin.x = -frame.size.width;
        if (frame.origin.x > 0.f)
            frame.origin.x = 0.f;
    }
    else
    {
        if (frame.origin.x < 0.f)
            frame.origin.x = 0.f;
        if (frame.origin.x > (frame.size.width))
            frame.origin.x = (frame.size.width);
    }
    
    self.view.frame = frame;
    
    frame = self.currentViewController.view.frame;
    if (self.isMenuOnRight)
        frame.origin.x = self.view.frame.size.width - frame.size.width;
    else
        frame.origin.x = 0.f;
    self.currentViewController.view.frame = frame;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[AXRatingView class]]) {
        return NO;
    }
    else if (self.isMenuOpened)
        return TRUE;
    return FALSE;
}


#pragma mark - Menu

- (void)openViewControllerAtIndexPath:(NSIndexPath*)indexPath
{
    if ([self.airDelegate respondsToSelector:@selector(airMenu:viewControllerAtIndexPath:)])
    {
        BOOL firstTime = FALSE;
        if (self.currentViewController == nil) {
            firstTime = TRUE;
        }
        
        else {
            //[controller sharedRelease];
        }
        _currentViewController = [self.airDelegate airMenu:self viewControllerAtIndexPath:indexPath];
        
        if (_currentViewController != nil) {
            
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeMenuAnimated)];
            tapGesture.delegate = self;
            [self.currentViewController.view addGestureRecognizer:tapGesture];
            
            CGRect frame = self.view.frame;
            frame.origin.x = 0.f;
            frame.origin.y = 0.f;
            self.currentViewController.view.frame = frame;
            
            frame = self.view.frame;
            frame.origin.x = 0.f;
            frame.origin.y = 0.f;
            self.view.frame = frame;
            
            self.currentViewController.view.autoresizesSubviews = TRUE;
            self.currentViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
            
            [self.view addSubview:self.currentViewController.view];
            [self addChildViewController:self.currentViewController];
            
            //            for (UIGestureRecognizer *gesture in self.view.gestureRecognizers) {
            //                if ([gesture isKindOfClass:[UIPanGestureRecognizer class]]) {
            //
            //                    NSLog(@"gestuire on self :%@",gesture);
            //
            //                    [self.view removeGestureRecognizer:gesture];
            //                }
            //        }
            
            if (panGesture1) {
                [panGesture1.view removeGestureRecognizer:panGesture1];
                panGesture1.delegate = nil;
                panGesture1 = nil;
            }
            panGesture1 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
            //           panGesture1.delegate = self;
            [self.view addGestureRecognizer:panGesture1];
            
            
            
            if (!firstTime)
                [self openingAnimation];
        }
        
    }
}
- (void)openingAnimation
{
    self.currentViewController.view.transform = CGAffineTransformMakeScale(self.minScaleController, self.minScaleController);
    
    CGRect frame = self.view.frame;
    if (self.isMenuOnRight)
        frame.origin.x = -frame.size.width + self.widthOpened;
    else
        frame.origin.x = frame.size.width - self.widthOpened;
    self.view.frame = frame;
    
    self.tableView.alpha = 1.f;
    
    self.tableView.transform = CGAffineTransformMakeScale(1.f, 1.f);
    
    frame = self.currentViewController.view.frame;
    if (self.isMenuOnRight)
        frame.origin.x = self.view.frame.size.width - frame.size.width;
    else
        frame.origin.x = 0.f;
    
    self.currentViewController.view.frame = frame;
    
    [self closeMenuAnimated];
    
}


#pragma mark - Actions

- (void)openMenuAnimated
{
    
    
    [UIView animateWithDuration:0.3f
                     animations:^{
                         
                         self.currentViewController.view.transform = CGAffineTransformMakeScale(self.minScaleController, self.minScaleController);
                         
                         CGRect frame = self.view.frame;
                         
                         if (self.isMenuOnRight)
                             frame.origin.x = -frame.size.width + self.widthOpened;
                         else
                             frame.origin.x = frame.size.width - self.widthOpened;
                         
                         self.view.frame = frame;
                         
                         self.tableView.alpha = 1.f;
                         
                         self.tableView.transform = CGAffineTransformMakeScale(1.f, 1.f);
                         
                         frame = self.currentViewController.view.frame;
                         if (self.isMenuOnRight)
                             frame.origin.x = self.view.frame.size.width - frame.size.width;
                         else
                             frame.origin.x = 0.f;
                         self.currentViewController.view.frame = frame;
                         
                        // NSLog(@"frame , %@",NSStringFromCGRect(frame));
                         
                     }
                     completion:^(BOOL finished){
                         //[self.navigationController setNavigationBarHidden:YES];
                         //self.currentViewController.view.transform = CGAffineTransformIdentity;
                     }];
    
    
    _isMenuOpened = TRUE;
}

- (void)closeMenuAnimated
{
    //[self.navigationController setNavigationBarHidden:NO];
    
    [UIView animateWithDuration:0.3f
                     animations:^{
                         
                         
                         
                         self.currentViewController.view.transform = CGAffineTransformMakeScale(1.f, 1.f);
                         
                         CGRect frame = self.view.frame;
                         frame.origin.x = 0.f;
                         self.view.frame = frame;
                         
                         self.tableView.alpha = self.minAlphaTableView;
                         
                         self.tableView.transform = CGAffineTransformMakeScale(self.minScaleTableView, self.minScaleTableView);
                         
                         frame = self.currentViewController.view.frame;
                         frame.origin.x = 0.f;
                         //frame.origin.y = 0.f;
                         //frame.size.height = [[UIScreen mainScreen]bounds].size.height;
                         self.currentViewController.view.frame = frame;
                        
                     }
                     completion:^(BOOL finished){
                         // [self.navigationController setNavigationBarHidden:NO];
                     }];
    
    //    [UIView animateWithDuration:0.3f animations:^{
    //
    //        self.currentViewController.view.transform = CGAffineTransformMakeScale(1.f, 1.f);
    //
    //        CGRect frame = self.view.frame;
    //        frame.origin.x = 0.f;
    //        self.view.frame = frame;
    //
    //        self.tableView.alpha = self.minAlphaTableView;
    //
    //        self.tableView.transform = CGAffineTransformMakeScale(self.minScaleTableView, self.minScaleTableView);
    //
    //        frame = self.currentViewController.view.frame;
    //        frame.origin.x = 0.f;
    //        self.currentViewController.view.frame = frame;
    //    }];
    
    _isMenuOpened = FALSE;
}


#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   /* if(indexPath.row == 4)
    {
        NSString *postText =  [NSString stringWithFormat:@"Please download the RideOne Driver www.twyns.net"];
        NSArray *activityItems = @[postText];
        
        
        
        UIActivityViewController *activityController =
        [[UIActivityViewController alloc]
         initWithActivityItems:activityItems
         applicationActivities:nil];
        [activityController setValue:@"Invite to join RideOne Driver App" forKey:@"subject"];
        
        [self presentViewController:activityController animated:YES completion:nil];
        
    }//3Embed*/
    
     if (indexPath.row ==5){
        
        NSLog(@"Logout");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Confirm" message:@"Are you sure you want to logout?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        [alertView show];
        
    }
    else {
        
        [self.currentViewController.view removeFromSuperview];
        [self.currentViewController removeFromParentViewController];
        [self openViewControllerAtIndexPath:indexPath];
    }
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}
#pragma mark- UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) { // logout
        
        ProgressIndicator *pi = [ProgressIndicator sharedInstance];
        [pi showPIOnView:self.view withMessage:@"Logging out.."];
        
        User *user = [[User alloc] init];
        user.delegate = self;
        [user logout];
    }
}
#pragma mark - UserDelegate
-(void)userDidLogoutSucessfully:(BOOL)sucess{
    
   // LocationTracker *tracker = [LocationTracker sharedInstance];
   // [tracker stopLocationTracking];
    
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:KDAcheckUserSessionToken];
    [[NSUserDefaults standardUserDefaults] synchronize];
    ProgressIndicator *pi = [ProgressIndicator sharedInstance];
    [pi hideProgressIndicator];
    
    [[[XDKAirMenuController sharedMenu] view] removeFromSuperview];
    
    if ([XDKAirMenuController relese]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:
                                    @"Main" bundle:[NSBundle mainBundle]];
        
        SplashViewController *splah = [storyboard instantiateViewControllerWithIdentifier:@"splash"];
        
        self.navigationController.viewControllers = [NSArray arrayWithObjects:splah, nil];
    }
    
}
-(void)userDidFailedToLogout:(NSError *)error{
    
    
   // LocationTracker *tracker = [LocationTracker sharedInstance];
   // [tracker stopLocationTracking];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:KDAcheckUserSessionToken];
    [[NSUserDefaults standardUserDefaults] synchronize];

    
    ProgressIndicator *pi = [ProgressIndicator sharedInstance];
    [pi hideProgressIndicator];
    
    [[[XDKAirMenuController sharedMenu] view] removeFromSuperview];
    
    if ([XDKAirMenuController relese]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:
                                    @"Main" bundle:[NSBundle mainBundle]];
        
        SplashViewController *splah = [storyboard instantiateViewControllerWithIdentifier:@"splash"];
        
        self.navigationController.viewControllers = [NSArray arrayWithObjects:splah, nil];
    }
    
}

#pragma mark - Setters

- (void)setIsMenuOnRight:(BOOL)isMenuOnRight
{
    if (self.view.superview == nil)
        _isMenuOnRight = isMenuOnRight;
}

//3Embed
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _menuTitle.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    XDKMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[XDKMenuCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        UIImage *cellimage = [UIImage imageNamed:_images_off[indexPath.row]];
        cell.backgroundColor = [UIColor colorWithPatternImage:cellimage];
       // cell.selectionStyle = UITableViewCellSelectionStyleNone;
        // this is where you set your color view
//        UIImageView *customColorView = [[UIImageView alloc] init];
//        customColorView.image = [UIImage imageNamed:_images_on[indexPath.row]];
//        cell.selectedBackgroundView =  customColorView;
    }
    
    cell.menuImage.tag = indexPath.row;
    cell.menutitle.text = _menuTitle [indexPath.row];
    
   
 
              return cell;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    // [super setHighlighted:highlighted animated:animated];
    // self.yourButton.highlighted = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    // [super setSelected:selected animated:animated];
    // self.yourButton.selected = NO;
    // If you don't set highlighted to NO in this method,
    // for some reason it'll be highlighed while the
    // table cell selection animates out
    // self.yourButton.highlighted = NO;
}
@end
