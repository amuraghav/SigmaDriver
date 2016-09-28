//
//  CustomMarkerView.m
//  privMD
//
//  Created by Surender Rathore on 07/04/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import "CustomMarkerView.h"
#import "TQStarRatingView.h"
#import "RoundedImageView.h"

@interface CustomMarkerView ()
@property(nonatomic,strong)TQStarRatingView *starRatingView;
@end

@implementation CustomMarkerView
@synthesize profileImage;
@synthesize labelTitle;


static CustomMarkerView *customMakerView;

+ (id)sharedInstance {
	if (!customMakerView) {
		customMakerView  = [[self alloc] initWithFrame:CGRectMake(0, 0, 120, 50)];
        [customMakerView createView];
	}
	
	return customMakerView;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}
-(void)createView{
    
    self.backgroundColor = [UIColor whiteColor];
    
    profileImage = [[RoundedImageView alloc]initWithFrame:CGRectMake(5,5,40, 40)];
    [self addSubview:profileImage];
    
    //title
    labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(50 ,5,75, 15)];
    [Helper setToLabel:labelTitle Text:@"Hello" WithFont:@"HelveticaNeue" FSize:10 Color:[UIColor blackColor]];
    [self addSubview:labelTitle];
    
    // Adding Star
    _starRatingView = [[TQStarRatingView alloc] initWithFrame:CGRectMake(50,25,70, 13)
                                                 numberOfStar:5];
    _starRatingView.userInteractionEnabled = NO;
    [self addSubview:_starRatingView];
}

-(void)updateRating:(float)rating{
    [_starRatingView setScore:rating withAnimation:YES];
}
-(void)updateTitle:(NSString*)title{
    
    labelTitle.text = title;
}
@end
