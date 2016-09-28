//
//  RadioButton.m
//  RadioButton
//
//  Created by Jeruel Fernandes on 15/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RadioButton.h"

@interface RadioButton()
+ (void)registerInstance:(RadioButton*)radioButton;
- (void)defaultInit;
- (void)handleTap;
@end

@implementation RadioButton

@synthesize lbl_RadioButton;
@synthesize btn_RadioButton;
@synthesize nID;
@synthesize nGroupID;
@synthesize delegate;

#define kImageHeight    25
#define kImageWidth     25

static NSMutableArray *arr_Instances=nil;

- (void)defaultInit
{    
    btn_RadioButton            = [UIButton buttonWithType:UIButtonTypeCustom];
    btn_RadioButton.frame      = CGRectMake(0, 0, kImageWidth, kImageHeight);
    btn_RadioButton.adjustsImageWhenHighlighted = NO;
    [btn_RadioButton setImage:[UIImage imageNamed:@"check_button.png"] forState:UIControlStateNormal];
    [btn_RadioButton setImage:[UIImage imageNamed:@"check_button_checked.png"] forState:UIControlStateSelected];
    [btn_RadioButton addTarget:self action:@selector(handleTap) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn_RadioButton];
    
//    lbl_RadioButton            = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, self.bounds.size.width-35, 30)];
//    lbl_RadioButton.backgroundColor    = [UIColor clearColor];
//    [self addSubview:lbl_RadioButton];
    
    [RadioButton registerInstance:self];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        [self defaultInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame AndGroupID:(NSUInteger)indexGroup AndID:(NSUInteger)indexID AndTitle:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self defaultInit];
        [self setGroupID:indexGroup AndID:indexID AndTitle:title];
    }
    return self;
}

- (void)setGroupID:(NSUInteger)indexGroup AndID:(NSUInteger)indexID AndTitle:(NSString *)title
{
    nID = indexID;
    nGroupID = indexGroup;
    lbl_RadioButton.text = title;
    
    if (indexGroup == 0) {
        NSLog(@"this id : %lu", (unsigned long)indexID);
    }
    
    NSLog(@"radiobtn----------- : %lu %lu %ld", (unsigned long)indexGroup, (unsigned long)indexID, (long)self.tag);
}

+ (void)registerInstance:(RadioButton*)radioButton
{
    if(!arr_Instances)
    {
        arr_Instances = [[NSMutableArray alloc] init];
    }    
    [arr_Instances addObject:radioButton];
}
+ (void)unRegisterInscance:(RadioButton*)radioButon
{
    if (!arr_Instances) {
        // do nothing
    }
    else
    {
        for (RadioButton *btn in arr_Instances) {
            if ([btn isEqual:radioButon]) {
                [arr_Instances removeObject:btn];
                break;
            }
        }
    }
}

+ (void)handleGroup:(RadioButton*)radioButton
{
    if(arr_Instances) 
    {
        for (int i=0; i<[arr_Instances count]; i++) 
        {
            RadioButton *button = [arr_Instances objectAtIndex:i];
            if ((![button isEqual:radioButton]) && (button.nGroupID == radioButton.nGroupID))
            {
                [button.btn_RadioButton setSelected:NO];
            }
        }
    }
}

+ (NSInteger)selectedIDForGroupID:(NSUInteger)indexGroup
{
    if(arr_Instances)
    {
        for(int i=0; i<[arr_Instances count]; i++)
        {
            RadioButton *button = [arr_Instances objectAtIndex:i];
            if((button.nGroupID == indexGroup) && (button.btn_RadioButton.isSelected))
            {
                return button.nID;
            }
        }
    }
    return -1;
}


+ (NSArray*)indexIDsForGroupIDs:(NSUInteger)indexGroup
{
    NSMutableArray *btnArr = [[NSMutableArray alloc] init];
    
    if(arr_Instances)
    {
        for(int i=0; i<[arr_Instances count]; i++)
        {
            RadioButton *button = [arr_Instances objectAtIndex:i];
            if(button.nGroupID == indexGroup)
            {
                 [btnArr addObject:[NSNumber numberWithInt:button.nID]];
            }
        }
    }
    
    return btnArr;
}

- (void)handleTap
{
    if(!btn_RadioButton.selected)
    {
        [btn_RadioButton setSelected:YES];
        [RadioButton handleGroup:self];
        [delegate stateChangedForGroupID:nGroupID WithSelectedButton:nID];
    }
}

@end
