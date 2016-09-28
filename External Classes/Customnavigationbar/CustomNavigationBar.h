//
//  CustomNavigationBar.h
//  privMD
//
//  Created by Surender Rathore on 15/04/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CustomNavigationBarDelegate;
@interface CustomNavigationBar : UIView
@property(nonatomic,weak)id <CustomNavigationBarDelegate> delegate;
@property(nonatomic,strong)UILabel *labelTitle;
@property(nonatomic,strong)UIButton *rightbarButton;
@property(nonatomic,strong)UIButton *leftbarButton;


-(void)setTitle:(NSString*)title;
-(void)setRightBarButtonTitle:(NSString*)title;
-(void)setLeftBarButtonTitle:(NSString*)title;
@end
@protocol CustomNavigationBarDelegate <NSObject>
@optional
-(void)rightBarButtonClicked:(UIButton*)sender;
-(void)setLeftBarButtonTitle:(NSString*)title;

-(void)leftBarButtonClicked:(UIButton*)sender;
@end
