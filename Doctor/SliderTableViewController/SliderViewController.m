//
//  SliderViewController.m
//  Doctor
//
//  Created by Rahul Sharma on 22/04/14.
//  Copyright (c) 2014 3Embed. All rights reserved.
//

#import "SliderViewController.h"
#import <QuartzCore/CALayer.h>
#define templte_height 320
#define templte_weidth 320
#define template_height_iPad 768
#define template_width_iPad  768
#define template   @"template"

@interface SliderViewController ()

@end

@implementation SliderViewController
@synthesize homeTableViewController;

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
      [self loadTemplatetsForFrame];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (id)initWithPageNumber:(NSUInteger)page :(NSMutableArray*)arr
{
    if (self = [super initWithNibName:nil bundle:nil])
    {
        NSLog(@"arr%@",arr);
        arrayAppt = [[NSMutableArray alloc]initWithArray:arr];
        NSLog(@"arrrrrr%@",arrayAppt);

        templetNumber = page;
   
        
    }
    return self;
}

-(void)loadTemplatetsForFrame
{
    ProgressIndicator *pi = [ProgressIndicator sharedInstance];
    [pi showPIOnView:self.view withMessage:nil];
    switch (templetNumber) {
        case 0:
        {
            pageNumber = 1;
            [self loadTemplate];
            break;
        }
        case 1:
        {
            pageNumber = 2;
            [self loadTemplate];
            break;
        }
        case 2:
        {
            pageNumber = 3;
            [self loadTemplate];
            break;
        }
        case 3:
        {
            pageNumber = 4;
            [self loadTemplate];
            break;
        }
        case 4:
        {
            pageNumber = 5;
            [self loadTemplate];
            break;
        }
        case 5:
        {
            pageNumber = 6;
            [self loadTemplate];
            break;
        }
        case 6:
        {
            pageNumber = 7;
            [self loadTemplate];
            break;
        }
               default:
            break;
    }
    
    // ProgressIndicator *pi = [ProgressIndicator sharedInstance];
    //[pi hideProgressIndicator];
}

-(void)loadTemplate
{
    
    [self.view addSubview:[self getTemplateFor:pageNumber WithFrame:CGRectMake(0, 0, 320, 320)]];
   
    
}
-(UIView*)getTemplateFor:(int)pageIndex WithFrame:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    
   if(pageNumber == 1)//cloudy template box(bottom)
    {
        dictAppt = [arrayAppt objectAtIndex:0];
        self.homeTableViewController = [[HomeTableView alloc] init];
        self.homeTableViewController.view.frame = CGRectMake(0, 0, templte_weidth, templte_height);
        self.homeTableViewController.view.backgroundColor = [UIColor clearColor];
        [view addSubview:self.homeTableViewController.view];
        [self.homeTableViewController upDateArray:dictAppt];
         return view;
    
    }
    if (pageNumber == 2) {
        
        dictAppt = [arrayAppt objectAtIndex:1];
        self.homeTableViewController = [[HomeTableView alloc] init];
        self.homeTableViewController.view.frame = CGRectMake(0, 0, templte_weidth, templte_height);
        self.homeTableViewController.view.backgroundColor = [UIColor clearColor];
        [view addSubview:self.homeTableViewController.view];
        [self.homeTableViewController upDateArray:dictAppt];

        
        return view;
        
    }
    
    else if(pageNumber == 3)//cloudy template box(bottom)
    {
         dictAppt = [arrayAppt objectAtIndex:2];
        self.homeTableViewController = [[HomeTableView alloc] init];
        self.homeTableViewController.view.frame = CGRectMake(0, 0, templte_weidth, templte_height);
        self.homeTableViewController.view.backgroundColor = [UIColor clearColor];
        [view addSubview:self.homeTableViewController.view];
        [self.homeTableViewController upDateArray:dictAppt];
        return view;
    }
    if (pageNumber == 4) {
        
         dictAppt = [arrayAppt objectAtIndex:3];
        self.homeTableViewController = [[HomeTableView alloc] init];
        self.homeTableViewController.view.frame = CGRectMake(0, 0, templte_weidth, templte_height);
        self.homeTableViewController.view.backgroundColor = [UIColor clearColor];
        [view addSubview:self.homeTableViewController.view];
        [self.homeTableViewController upDateArray:dictAppt];

        return view;
        
    }
    
    else if(pageNumber == 5)//cloudy template box(bottom)
    {
         dictAppt = [arrayAppt objectAtIndex:4];
        self.homeTableViewController = [[HomeTableView alloc] init];
        self.homeTableViewController.view.frame = CGRectMake(0, 0, templte_weidth, templte_height);
        self.homeTableViewController.view.backgroundColor = [UIColor clearColor];
        [view addSubview:self.homeTableViewController.view];
        [self.homeTableViewController upDateArray:dictAppt];
        return view;
    }
    else if(pageNumber == 6)//cloudy template box(bottom)
    {
        dictAppt = [arrayAppt objectAtIndex:5];
        self.homeTableViewController = [[HomeTableView alloc] init];
        self.homeTableViewController.view.frame = CGRectMake(0, 0, templte_weidth, templte_height);
        self.homeTableViewController.view.backgroundColor = [UIColor clearColor];
        [view addSubview:self.homeTableViewController.view];
        [self.homeTableViewController upDateArray:dictAppt];

        return view;
    }

    else if(pageNumber == 7)//cloudy template box(bottom)
    {
         dictAppt = [arrayAppt objectAtIndex:6];
        self.homeTableViewController = [[HomeTableView alloc] init];
        self.homeTableViewController.view.frame = CGRectMake(0, 0, templte_weidth, templte_height);
        self.homeTableViewController.view.backgroundColor = [UIColor clearColor];
        [view addSubview:self.homeTableViewController.view];
        [self.homeTableViewController upDateArray:dictAppt];
        return view;
    }
    else if(pageNumber == 8)//cloudy template box(bottom)
    {
        dictAppt = [arrayAppt objectAtIndex:7];
        self.homeTableViewController = [[HomeTableView alloc] init];
        self.homeTableViewController.view.frame = CGRectMake(0, 0, templte_weidth, templte_height);
        self.homeTableViewController.view.backgroundColor = [UIColor clearColor];
        [view addSubview:self.homeTableViewController.view];
        [self.homeTableViewController upDateArray:dictAppt];
        return view;
    }



    return view;
}


@end
