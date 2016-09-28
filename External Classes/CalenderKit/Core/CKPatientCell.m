//
//  CKPatientCell.m
//  privMD
//
//  Created by Rahul Sharma on 24/02/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import "CKPatientCell.h"
#import "RadioButton.h"

@implementation CKPatientCell
@synthesize textLabel;
@synthesize radioButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        if(!textLabel)
        {
            UILabel *obj = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 200, 35)];
            self.textLabel = obj;
            
            [self.contentView addSubview:textLabel];
        }
        if(!radioButton)
        {
            
            radioButton =[[RadioButton alloc] initWithFrame:CGRectMake(240,5,25,25)];
            [self.contentView addSubview:radioButton];
            
        }
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
