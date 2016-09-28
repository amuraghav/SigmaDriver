//
//  FAQViewController.h
//  privMD
//
//  Created by Rahul Sharma on 10/03/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FAQViewController : UIViewController<UIScrollViewDelegate>
@property (strong , nonatomic) UIScrollView *mainScrollView;
@property (strong , nonatomic) UIPageControl *pageControl;
@end
