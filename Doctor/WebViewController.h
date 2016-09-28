//
//  WebViewController.h
//  Loupon
//
//  Created by Rahul Sharma on 08/01/14.
//  Copyright (c) 2014 3Embed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController<UIWebViewDelegate>
@property(nonatomic,strong) NSString *weburl;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property(nonatomic,strong) NSString *titleStr;

@property(strong,nonatomic) UIButton *backButton;

@end
