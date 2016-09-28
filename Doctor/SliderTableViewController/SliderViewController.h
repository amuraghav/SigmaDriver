//
//  SliderViewController.h
//  Doctor
//
//  Created by Rahul Sharma on 22/04/14.
//  Copyright (c) 2014 3Embed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeTableView.h"

@interface SliderViewController : UIViewController
{
    int pageNumber;
    NSUInteger templetNumber;
    NSDictionary * dictAppt;
    NSMutableArray * arrayAppt;
   
}
@property(strong,nonatomic) HomeTableView * homeTableViewController;
- (id)initWithPageNumber:(NSUInteger)page :(NSMutableArray*)arr;

@end
