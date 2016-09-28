//
//  CustomNavigationBar.m
//  privMD
//
//  Created by Surender Rathore on 15/04/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import "CustomNavigationBar.h"
#import "Helper.h"
#import "Fonts.h"

@interface CustomNavigationBar()


@end
@implementation CustomNavigationBar
@synthesize labelTitle;
@synthesize rightbarButton;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:246/255.0 green:206/255.0 blue:18/255.0 alpha:1.0]];
                //title
        labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0,20, 320,30)];
        labelTitle.textAlignment = NSTextAlignmentCenter;
        //[Helper setToLabel:labelTitle Text:@"Home" WithFont:Robot_Regular FSize:17 Color:[UIColor whiteColor]];
        
        [Helper setToLabel:labelTitle Text:@"HOME" WithFont:Oswald_Light FSize:17 Color:[UIColor whiteColor]];
        [self addSubview:labelTitle];
        
        _leftbarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftbarButton.frame = CGRectMake(0,20,44,30);
        [_leftbarButton setTitle:@"" forState:UIControlStateNormal];
        [_leftbarButton setTitle:@"" forState:UIControlStateSelected];
        [_leftbarButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_leftbarButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        _leftbarButton.titleLabel.font = [UIFont fontWithName:Robot_Regular size:11];
        UIImage *buttonImage = [UIImage imageNamed:@"Menu.png"];
        [_leftbarButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
        [_leftbarButton addTarget:self action:@selector(leftBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_leftbarButton];
        
        
        //rightbutton
      //  UIImage *buttonImage = [UIImage imageNamed:@"signup_btn_back_bg_on.png"];
        //rightbutton
        rightbarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightbarButton.frame = CGRectMake(220, 20,100, buttonImage.size.height);
        rightbarButton.titleLabel.font = [UIFont fontWithName:Robot_Regular size:15];
        [rightbarButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [rightbarButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
       // [rightbarButton setBackgroundImage:buttonImage forState:UIControlStateHighlighted];
        rightbarButton.tag = 100;
        [rightbarButton addTarget:self action:@selector(rightBarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:rightbarButton];
        
        
//        self.layer.shadowColor = [UIColor blackColor].CGColor;
//        self.layer.shadowOpacity = 1;
//        
//        self.layer.shadowOffset = CGSizeMake(0,0);
//        CGRect shadowPath = CGRectMake(self.layer.bounds.origin.x - 10, self.layer.bounds.size.height+1, self.layer.bounds.size.width + 20, 1.3);
//        self.layer.shadowPath = [UIBezierPath bezierPathWithRect:shadowPath].CGPath;
//        self.layer.shouldRasterize = YES;
        
    }
    return self;
}
-(void)setTitle:(NSString*)title{
    labelTitle.text = title;
    
    
  
    //[self setNeedsDisplay];
}
-(void)setRightBarButtonTitle:(NSString*)title{
    [rightbarButton setTitle:title forState:UIControlStateNormal];
    //[self setNeedsDisplay];
}
-(void)setLeftBarButtonTitle:(NSString*)title{
    [_leftbarButton setTitle:title forState:UIControlStateNormal];
   
    
    //[self setNeedsDisplay];
}
-(void)rightBarButtonClicked:(UIButton*)sender{
    if (delegate && [delegate respondsToSelector:@selector(rightBarButtonClicked:)]) {
        [delegate rightBarButtonClicked:sender];
    }
}
-(void)leftBarButtonClicked:(UIButton*)sender {
    if (delegate && [delegate respondsToSelector:@selector(leftBarButtonClicked:)]) {
        [delegate leftBarButtonClicked:sender];
    }
}
@end
