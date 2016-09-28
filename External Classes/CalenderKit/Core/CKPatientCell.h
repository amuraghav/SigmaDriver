//
//  CKPatientCell.h
//  privMD
//
//  Created by Rahul Sharma on 24/02/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RadioButton;
@interface CKPatientCell : UITableViewCell

@property(strong,nonatomic)   UILabel *textLabel;
@property (strong,nonatomic)  RadioButton *radioButton;

@end
