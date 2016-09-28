//
//  AppointmentViewController.m
//  privMD
//
//  Created by Rahul Sharma on 10/03/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import "AppointmentViewController.h"
#import "XDKAirMenuController.h"
#import "CustomNavigationBar.h"
#import "AppointmentDates.h"
#import "NSCalendar+Ranges.h"
#import "CKCalendarHeaderView.h"


@interface AppointmentViewController () <CustomNavigationBarDelegate>
@property (nonatomic, strong) NSMutableDictionary *data;
@property (nonatomic,strong) UIScrollView *calScrollView;
@property (nonatomic,strong) UIView *calView;

@end

@implementation AppointmentViewController
@synthesize calendar;
@synthesize calScrollView;
@synthesize calView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(NSString *)getMonths
{
    NSDate *date = [NSDate date];
    NSCalendar *calendarLoc = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendarLoc components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
    // NSInteger Day = [components day];
    NSInteger month = [components month];
    NSInteger year = [components year];
    
    //
    NSNumberFormatter * numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPaddingCharacter:@"0"];
    [numberFormatter setMinimumIntegerDigits:2];
    NSString * monthString = [numberFormatter stringFromNumber:[NSNumber numberWithInteger:month]];
    
    NSString *retMonth = [NSString stringWithFormat:@"%ld-%@",(long)year,monthString];
    return retMonth;
}
#pragma mark -Web Service

-(void)sendServicegetPatientAppointment
{
    [[ProgressIndicator sharedInstance]showPIOnView:self.view withMessage:@"Loading.."];
    
    NSString *month = [self getMonths];
    NSDictionary *parameters = @{kSMPcheckUserSessionToken: [[NSUserDefaults standardUserDefaults] objectForKey:KDAcheckUserSessionToken],
                                 kSMPCommonDevideId:[[NSUserDefaults standardUserDefaults] objectForKey:kPMDDeviceIdKey],
                                 @"ent_appnt_dt":month,
                                 @"ent_date_time":[Helper getCurrentDateTime]};
    
    
    NSURL *url = [NSURL URLWithString:BASE_URL];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient postPath:MethodAppointments parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self getPatientAppointmentResponse:operation.responseString.JSONValue];
        // NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //NSLog(@"Request Successful, response '%@'", responseStr);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"[HTTPClient Error]: %@", error.localizedDescription);
    }];
    
}

- (NSDateFormatter *)formatter {
    
    //EEE - day(eg: Thu)
    //MMM - month (eg: Nov)
    // dd - date (eg 01)
    // z - timeZone
    
    //eg : @"EEE MMM dd HH:mm:ss z yyyy"
    
    static NSDateFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd";
    });
    return formatter;
}
-(void)getPatientAppointmentResponse:(NSDictionary *)response
{
    
    // NSLog(@"response:%@",response);
    if (!response)
    {
        ProgressIndicator *pi = [ProgressIndicator sharedInstance];
        [pi hideProgressIndicator];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:[response objectForKey:@"Message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        
    }
    else if ([response objectForKey:@"Error"])
    {
        ProgressIndicator *pi = [ProgressIndicator sharedInstance];
        [pi hideProgressIndicator];
        [Helper showAlertWithTitle:@"Error" Message:[response objectForKey:@"Error"]];
        
    }
    else
    {
        NSDictionary *dictResponse  = response;// =[response objectForKey:@"ItemsList"];
        if ([[dictResponse objectForKey:@"errFlag"] intValue] == 0)
        {
            
            
            
            NSMutableArray *appointmentsArr = [dictResponse objectForKey:@"appointments"];
            //date
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            self.data = [[NSMutableDictionary alloc]init];
            
            //date done
            
            NSMutableDictionary *apArr = [[NSMutableDictionary alloc]init];
            for (int i = 0;i<appointmentsArr.count;i++)
            {
                apArr = [appointmentsArr objectAtIndex:i];
                
                NSArray *appDetailArr = [apArr objectForKey:@"appt"];
                
                NSString *appDate = [apArr objectForKey:@"date"];
                //NSLog(@"appDate %@",appDate);
                NSDate *dateFormated = [dateFormatter dateFromString:appDate];
                [self addEvents:appDetailArr forDate:dateFormated];
                
            }
            
            [calendar reload];
            
            ProgressIndicator *pi = [ProgressIndicator sharedInstance];
            [pi hideProgressIndicator];
            [self calendarView:calendar tableViewIsReoloadedTable:nil];
            
        }
        else
        {
            ProgressIndicator *pi = [ProgressIndicator sharedInstance];
            [pi hideProgressIndicator];
            [Helper showAlertWithTitle:@"Message" Message:[dictResponse objectForKey:@"errMsg"]];
            
        }
    }
    
}
-(void)createBookButton
{
    UIView *mapView = [[UIView alloc]initWithFrame:CGRectMake(0,0,55,29)];
    
    UIButton *bookButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0.0"))
    {
        [bookButton setFrame:CGRectMake(0,0,55,29)];
    }
    else
    {
        [bookButton setFrame:CGRectMake(0,0,55,29)];
        
    }
    
    [bookButton setTitle:@"Book" forState:UIControlStateNormal];
    [Helper setButton:bookButton Text:@"BOOK" WithFont:@"Helvetica" FSize:12 TitleColor:[UIColor blueColor] ShadowColor:nil];
    //   [bookButton addTarget:self action:@selector(bookButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [mapView addSubview:bookButton];
    
    UIBarButtonItem *containingBarButton = [[UIBarButtonItem alloc] initWithCustomView:mapView];
    
    self.navigationItem.rightBarButtonItem = containingBarButton;
}
-(void)createMenuButton
{
    UIButton *buttonMenu = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonMenu.frame = CGRectMake(10,20, 42, 40);
    
    
    //  [Helper setButton:buttonMenu Text:@"Menu" WithFont:@"HelveticaNeue" FSize:15 TitleColor:[UIColor whiteColor] ShadowColor:nil];
    buttonMenu.tag = 100;
    [Helper setButton:buttonMenu Text:@"Menu" WithFont:@"HelveticaNeue" FSize:15 TitleColor:[UIColor blueColor] ShadowColor:nil];
    
    [buttonMenu addTarget:self action:@selector(menuButtonclicked) forControlEvents:UIControlEventTouchUpInside];
    
    //[confirmButton addTarget:self action:@selector(confirmButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *containingBarButton = [[UIBarButtonItem alloc] initWithCustomView:buttonMenu];
    
    self.navigationItem.rightBarButtonItem = containingBarButton;
}

-(void)createConfirmButton
{
    UIView *confirmView = [[UIView alloc]initWithFrame:CGRectMake(0,0.0,70,29)];
    
    UIButton *confirmButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    
    confirmButton.frame = CGRectMake(0,0,70,29);
    
    [Helper setButton:confirmButton Text:@"Next" WithFont:@"HelveticaNeue" FSize:17 TitleColor:[UIColor blueColor] ShadowColor:nil];
    
    //   [confirmButton setBackgroundImage:[UIImage imageNamed:@"capture_btn_flash_off.png"] forState:UIControlStateNormal];
    //  [confirmButton setBackgroundImage:[UIImage imageNamed:@"capture_btn_flash_on.png"] forState:UIControlStateSelected];
    [confirmView addSubview:confirmButton];
    
    //[confirmButton addTarget:self action:@selector(confirmButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *containingBarButton = [[UIBarButtonItem alloc] initWithCustomView:confirmView];
    
    self.navigationItem.rightBarButtonItem = containingBarButton;
    
}

#pragma mark - ViewLifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (IS_IOS7) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = YES;
    }
    [self addCustomNavigationBar];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [calendar setDelegate:nil];
    [calendar setDataSource:nil];
    calendar = nil;
    [self.navigationController setNavigationBarHidden:YES];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    if (!calendar) {
        
        calView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height-64)];
        //[self.view addSubview:view];
        
        calScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,64, 320,[UIScreen mainScreen].bounds.size.height-64)];
        calScrollView.backgroundColor = [UIColor blackColor];
        [calScrollView setScrollEnabled:YES];
        [self.view addSubview:calScrollView];
        
        NSDate *currentdate = [NSDate date];
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        NSString *yourDate = [dateFormatter stringFromDate:currentdate];
        NSDate *date = [dateFormatter dateFromString:yourDate];
        
        
        calendar = [CKCalendarView new];
        calendar.isComingFrom = YES;
        [calendar setBackgroundColor:[UIColor blackColor]];
        CGRect calendarFrame = calendar.frame;
        calendarFrame.origin.y = 0;
        calendar.frame =  calendarFrame;
        
        calendar.date = date;
        
        
        // 2. Optionally, set up the datasource and delegates
        [calendar setDelegate:self];
        [calendar setDataSource:self];
        // 3. Present the calendar
        [calView addSubview:calendar];
        
        [calScrollView addSubview:calView];
        
        
        [self sendServicegetPatientAppointment];
    }
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- Custom Methods

#pragma mark- Custom Methods

- (void) addCustomNavigationBar{
    
    CustomNavigationBar *customNavigationBarView = [[CustomNavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    customNavigationBarView.tag = 78;
    customNavigationBarView.delegate = self;
    [customNavigationBarView setTitle:@"History"];
    [customNavigationBarView setBackgroundColor:NavBarTint_Color];
    [self.view addSubview:customNavigationBarView];
    
}
-(void)leftBarButtonClicked:(UIButton *)sender{
    [self menuButtonclicked];
}

- (void)menuButtonclicked
{
    XDKAirMenuController *menu = [XDKAirMenuController sharedMenu];
    
    if (menu.isMenuOpened)
        [menu closeMenuAnimated];
    else
        [menu openMenuAnimated];
}

- (NSArray *)calendarView:(CKCalendarView *)calendarView eventsForDate:(NSDate *)date
{
    
    return [self data][date];
    
}
// Called before/after the selected date changes
- (void)calendarView:(CKCalendarView *)CalendarView willSelectDate:(NSDate *)date
{
    
}

- (void)calendarView:(CKCalendarView *)CalendarView didSelectDate:(NSDate *)date
{
    
    
}

//  A row is selected in the events table. (Use to push a detail view or whatever.)
- (void)calendarView:(CKCalendarView *)CalendarView didSelectEvent:(CKCalendarEvent *)event
{
    
    /*
     NSDictionary *dictionary = event.info;
     
     if ([dictionary[@"statCode"] integerValue] == 5) {
     
     AppointedDoctor *appointedDoctor = [[AppointedDoctor alloc] init];
     appointedDoctor.doctorName      =   dictionary[@"fname"];
     appointedDoctor.estimatedTime   =   dictionary[@""];
     appointedDoctor.appoinmentDate  =   dictionary[@"dt"];
     appointedDoctor.distance        =   dictionary[@""];
     appointedDoctor.contactNumber   =   dictionary[@"phone"];
     appointedDoctor.profilePicURL   =   dictionary[@"pPic"];
     appointedDoctor.email           =   dictionary[@"email"];
     appointedDoctor.status          =   dictionary[@"status"];
     
     NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:appointedDoctor];
     [[NSUserDefaults standardUserDefaults] setObject:encodedObject forKey:kNSUAppoinmentDoctorDetialKey];
     [[NSUserDefaults standardUserDefaults] synchronize];
     
     UIStoryboard *mainstoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
     BookingDirectionViewController *bookingDirectionVC = [mainstoryboard instantiateViewControllerWithIdentifier:@"bookingDirectionVC"];
     bookingDirectionVC.appointmentLatitude = [dictionary[@"apptLat"] floatValue];
     bookingDirectionVC.appointmentLongitude = [dictionary[@"apptLong"] floatValue];
     [self.navigationController pushViewController:bookingDirectionVC animated:YES];
     }
     */
    
    
}

-(void)addEvents:(NSArray *)eventsArray forDate:(NSDate*)date
{
    NSMutableArray *myeventsArray = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *eventsDict = [[NSMutableDictionary alloc] init];
    
    for (int i =0; i< eventsArray.count ;i++)
    {
        
        // Create events
        eventsDict = eventsArray[i];
        CKCalendarEvent* aCKCalendarEvent = [[CKCalendarEvent alloc] init];
        aCKCalendarEvent.title = [eventsDict  objectForKey:@"email"];
        aCKCalendarEvent.image = [eventsDict objectForKey:@"pPic"];
        aCKCalendarEvent.name = [eventsDict objectForKey:@"fname"];
        aCKCalendarEvent.pickAdd = [eventsDict  objectForKey:@"addrLine1"];
        aCKCalendarEvent.desAdd = [eventsDict  objectForKey:@"dropLine1"];
        aCKCalendarEvent.time = [eventsDict objectForKey:@"apntTime"];
        aCKCalendarEvent.distance = [eventsDict objectForKey:@"distance"];;
        aCKCalendarEvent.amount = [eventsDict  objectForKey:@"amount"];
        aCKCalendarEvent.status = [eventsDict objectForKey:@"status"];
        aCKCalendarEvent.date = date; //[eventsArray  objectForKey:@"phone"];
        aCKCalendarEvent.info = eventsDict;
        [myeventsArray addObject: aCKCalendarEvent];
    }
    
    [_data setObject:myeventsArray forKey:date];
    
    
    // NSLog(@"data %@",_data);
    
    
}
-(void)calendarView:(CKCalendarView *)CalendarView tableViewIsReoloadedTable:(UITableView *)table{
    
    
    
    
    if (calendar.table.contentSize.height + 314 > [UIScreen mainScreen].bounds.size.height-64 ) {
        self.calScrollView.contentSize = CGSizeMake(320, calendar.table.contentSize.height + 250);
        
        CGRect rect = self.calScrollView.frame;
        rect.size.height = calendar.table.contentSize.height + 250;
        
        CGRect rect1 = self.calView.frame;
        rect1.size.height = rect.size.height;
        calView.frame = rect1;
        self.calendar.table.frame = rect;
    } else {
        self.calScrollView.contentSize = CGSizeMake(320, 0);
        
        CGRect rect = self.calScrollView.frame;
        rect.size.height = [UIScreen mainScreen].bounds.size.height-64;
        CGRect rect1 = self.calView.frame;
        rect1.size.height = rect.size.height;
        calView.frame = rect1;
        
        self.calendar.table.frame = rect;
    }
    
}



@end
