//
//  HomeTableView.h
//  Doctor
//
//  Created by Rahul Sharma on 23/04/14.
//  Copyright (c) 2014 3Embed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTableView : UITableViewController
{
    NSMutableArray *arrApp;
}
-(void)upDateArray:(NSDictionary *)dict;
@end
