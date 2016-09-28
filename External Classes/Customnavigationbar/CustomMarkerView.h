//
//  CustomMarkerView.h
//  privMD
//
//  Created by Surender Rathore on 07/04/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoundedImageView.h"
@interface CustomMarkerView : UIView
@property(nonatomic,strong)RoundedImageView *profileImage;
@property(nonatomic,strong)UILabel *labelTitle;

/**
 *  Singlton instance of class
 *
 *  @return a singlton instance
 */
+ (id)sharedInstance;
/**
 *  Update Rating
 *
 *  @param rating rating of medical specialist
 */
-(void)updateRating:(float)rating;

-(void)updateTitle:(NSString*)title;
@end
