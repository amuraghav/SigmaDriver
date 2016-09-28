//
//  UploadProgress.m
//  InsightApp
//
//  Created by Surender Rathore on 14/01/14.
//
//

#import "UploadProgress.h"

@implementation UploadProgress
@synthesize lblMessage;
@synthesize progressBar;
@synthesize showViewFrom;
#define _height  50
#define fromTop 0
#define fromBottom 1

static UploadProgress *pv;

+ (id)sharedInstance {
	if (!pv) {
		pv  = [[self alloc] init];
	}
	
	return pv;
}

-(id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        //showViewFrom = fromBottom;
        [self deafultInit];
    }
    return self;
}


-(void)deafultInit
{
    progressBar = [[UIProgressView alloc] initWithFrame:CGRectMake(5, 40, 310, 10)];
    progressBar.progress = 0;
    [self addSubview:progressBar];
    
    lblMessage = [[UILabel alloc] initWithFrame:CGRectMake(55, _height/2-25/2, 200, 25)];
    lblMessage.textAlignment = NSTextAlignmentCenter;
    lblMessage.textColor = [UIColor whiteColor];
    lblMessage.backgroundColor = [UIColor clearColor];
    lblMessage.font = [UIFont boldSystemFontOfSize:14];
    lblMessage.text = @"uploading..";
    [self addSubview:lblMessage];
    
//    UIButton *btnCross = [UIButton buttonWithType:UIButtonTypeCustom];
//    btnCross.frame = CGRectMake(320-18, 3, 15, 15);
//    [btnCross setImage:[UIImage imageNamed:@"close_btn.png"] forState:UIControlStateNormal];
//    [btnCross addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:btnCross];
    
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    self.backgroundColor = [UIColor blackColor];
    
    CGSize size;
    if (showViewFrom == fromBottom) {
        size = [[UIScreen mainScreen] bounds].size;
        self.frame = CGRectMake(0,size.height, 320, _height);
    }
    else {
        self.frame = CGRectMake(0,-_height, 320, _height);
    }
    
    [window addSubview:self];
    
    
    CGRect frame = self.frame;
    if (showViewFrom == fromBottom) {
        frame.origin.y = size.height - _height;
    }
    else {
        frame.origin.y = 0;
    }
    
    
    [UIView animateWithDuration:.4f
                     animations:^{
                         
                         self.frame = frame;
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
    
    
}
-(void)setMessage:(NSString*)message
{
    lblMessage.text = message;
}
-(void)hide
{
    
    
    CGSize size;
    CGRect frame = self.frame;
    if (showViewFrom == fromBottom) {
        size = [[UIScreen mainScreen] bounds].size;
        frame.origin.y  = size.height;
    }
    else {
        frame.origin.y = -50;
    }
    
    
    
    [UIView animateWithDuration:0.2f
                     animations:^{
                         self.frame = frame;
                         
                         
                     }
                     completion:^(BOOL finished){
                         
                         [self removeFromSuperview];
                         pv = nil;
                         
                         
                     }];
    
    
}
-(void)updateProgress:(float)progress {
    [progressBar setProgress:progress animated:YES];
}

@end
