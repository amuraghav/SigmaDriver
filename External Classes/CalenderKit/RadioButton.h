//
//  RadioButton.h
//  RadioButton
//
//  Created by Jeruel Fernandes on 15/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RadioButtonDelegate <NSObject>
- (void)stateChangedForGroupID:(NSUInteger)indexGroup WithSelectedButton:(NSUInteger)indexID;
@end

@interface RadioButton : UIView
{
    NSUInteger  nID;
    NSUInteger  nGroupID;
    UIButton    *btn_RadioButton;
    UILabel     *lbl_RadioButton;
    
    id <RadioButtonDelegate> delegate;
}

@property (readwrite, nonatomic) NSUInteger nID;
@property (readwrite, nonatomic) NSUInteger nGroupID;
@property (strong, nonatomic) UIButton *btn_RadioButton;
@property (strong, nonatomic) UILabel *lbl_RadioButton;
//@property (strong, nonatomic)NSMutableArray *arr_Instances;
@property (strong, nonatomic) id <RadioButtonDelegate> delegate;

- (id)initWithFrame:(CGRect)frame AndGroupID:(NSUInteger)indexGroup AndID:(NSUInteger)indexID AndTitle:(NSString*)title;
- (void)setGroupID:(NSUInteger)indexGroup AndID:(NSUInteger)indexID AndTitle:(NSString*)title;
+ (NSInteger)selectedIDForGroupID:(NSUInteger)indexGroup;
+ (NSArray*)indexIDsForGroupIDs:(NSUInteger)indexGroup;
+ (void)unRegisterInscance:(RadioButton*)radioButon;

@end
