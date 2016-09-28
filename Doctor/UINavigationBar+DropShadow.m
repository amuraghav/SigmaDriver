//
//  UINavigationBar+DropShadow.m
//  privMD
//
//  Created by Surender Rathore on 12/04/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import "UINavigationBar+DropShadow.h"

@implementation UINavigationBar (DropShadow)

-(void)willMoveToWindow:(UIWindow *)newWindow {
    [super willMoveToWindow:newWindow];
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 1;

    self.layer.shadowOffset = CGSizeMake(0,0);
    CGRect shadowPath = CGRectMake(self.layer.bounds.origin.x - 10, self.layer.bounds.size.height+1, self.layer.bounds.size.width + 20, 1.3);
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:shadowPath].CGPath;
    self.layer.shouldRasterize = YES;
}
@end
