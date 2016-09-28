//
//  XDKMenuCell.m
//  privMD
//
//  Created by Rahul Sharma on 25/03/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import "XDKMenuCell.h"
#import "Fonts.h"
#import "Helper.h"

@implementation XDKMenuCell

@synthesize menuImage;
@synthesize menutitle,menuLine;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        if(!menuLine)
        {
            menuLine = [[UILabel alloc]initWithFrame:CGRectMake(5,0,227,1)];
            [self.contentView addSubview:menuLine];
        }
        
        if(!menuImage)
        {
            menuImage = [[UIButton alloc]initWithFrame:CGRectMake(5,4,45,45)];
            [self.contentView addSubview:menuImage];
        }
        if(!menutitle)
        {
            menutitle = [[UILabel alloc]initWithFrame:CGRectMake(70,0,150,45)];
            [Helper setToLabel:menutitle Text:@"" WithFont:Oswald_Light FSize:15 Color:UIColorFromRGB(0xffffff)];
            [self.contentView addSubview:menutitle];
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
