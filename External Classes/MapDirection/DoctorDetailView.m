//
//  WindowOverlayButton.m
//  MyAlbum
//
//  Created by Surender Rathore on 28/02/14.
//
//

#import "DoctorDetailView.h"
#import "AppointedDoctor.h"
#import "RoundedImageView.h"
#import "TQStarRatingView.h"
#import "UIImageView+WebCache.h"

@implementation DoctorDetailView
@synthesize callback;

#define DeafultText @"Please Wait..."

#define _height  120

static DoctorDetailView *overlayButton;

+ (id)sharedInstance {
	if (!overlayButton) {
		overlayButton  = [[self alloc] init];
	}
	
	return overlayButton;
}

-(id)initWithButtonTitle:(NSString*)title
{
    self = [DoctorDetailView sharedInstance];
    if (self) {
        // Initialization code
        [self deafultInitWithTitle:title];
    }
    return self;
}




-(void)deafultInitWithTitle:title
{
    
    //get doctor detail
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSData *decodedObject = [ud objectForKey:kNSUAppoinmentDoctorDetialKey];
    AppointedDoctor *apDoc = [NSKeyedUnarchiver unarchiveObjectWithData:decodedObject];
    
    RoundedImageView *profilepic = [[RoundedImageView alloc] initWithFrame:CGRectMake(15, 10, 80, 80)];
    profilepic.image = [UIImage imageNamed:@"signup_image_user.png"];
    [self addSubview:profilepic];
    
    NSString *strImageUrl = [NSString stringWithFormat:@"%@%@",baseUrlForXXHDPIImage,apDoc.profilePicURL];
    NSLog(@"strUrl :%@",strImageUrl);
    [profilepic setImageWithURL:[NSURL URLWithString:strImageUrl]
                    placeholderImage:[UIImage imageNamed:@"doctor_image_thumbnail.png"]
                           completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                           }];
    
    UILabel *doctorName = [[UILabel alloc] initWithFrame:CGRectMake(122, 5, 200, 20)];
    [Helper setToLabel:doctorName Text:apDoc.doctorName WithFont:@"Helvetica" FSize:12 Color:[UIColor blackColor]];
    [self addSubview:doctorName];
    
    
    UILabel *appoinmentTime = [[UILabel alloc] initWithFrame:CGRectMake(122, 30, 200, 20)];
    [Helper setToLabel:appoinmentTime Text:apDoc.appoinmentDate WithFont:@"Helvetica" FSize:12 Color:[UIColor blackColor]];
    [self addSubview:appoinmentTime];
    
    float rating = [ud floatForKey:@"Rating"];
    TQStarRatingView *starRatingView = [[TQStarRatingView alloc] initWithFrame:CGRectMake(122,50,100,20)
                                                numberOfStar:5];
    [self addSubview:starRatingView];
    [starRatingView setScore:rating withAnimation:YES];
    
    UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(122, 72, 155, 15)];
    statusLabel.tag = 10;
    [Helper setToLabel:statusLabel Text:apDoc.status WithFont:@"Helvetica" FSize:13 Color:[UIColor redColor]];
    [self addSubview:statusLabel];
    
    
    UILabel *distance = [[UILabel alloc] initWithFrame:CGRectMake(5, 100, 155, 15)];
    distance.tag = 100;
    [Helper setToLabel:distance Text:[NSString stringWithFormat:@"Distance: %@",apDoc.distance] WithFont:@"Helvetica" FSize:12 Color:[UIColor blackColor]];
    [self addSubview:distance];
    
    UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake(160, 100, 155, 15)];
    time.tag = 200;
    [Helper setToLabel:time Text:[NSString stringWithFormat:@"Time: %@",apDoc.distance] WithFont:@"Helvetica" FSize:12 Color:[UIColor blackColor]];
    [self addSubview:time];
    
    
    
    
    
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    self.backgroundColor = [UIColor grayColor];
    CGSize size = [[UIScreen mainScreen] bounds].size;
    self.frame = CGRectMake(0, size.height, 320, _height);
    [window addSubview:self];
    
    
    
    
}
-(void)show{
    
    CGSize size = [[UIScreen mainScreen] bounds].size;
    CGRect frame = self.frame;
    frame.origin.y = ( size.height -_height);
    
    [UIView animateWithDuration:.4f
                     animations:^{
                         
                         self.frame = frame;
                     }
                     completion:^(BOOL finished){
                         
                     }];
}

-(void)hide
{
    
  
    CGRect frame = self.frame;
    frame.origin.y = ( frame.origin.y + _height);
    
    [UIView animateWithDuration:0.2f
                     animations:^{
                         self.frame = frame;
                         
                         
                     }
                     completion:^(BOOL finished){
                         
                         [self removeFromSuperview];
                         overlayButton = Nil;
                         
                         
                     }];
    
    
}
-(void)buttonClicked:(id)sender {
    
    if (self.callback) {
        self.callback();
    }
}
-(void)updateDistance:(NSString*)distane estimateTime:(NSString*)eta{
    UILabel *distanceLabel = (UILabel*)[self viewWithTag:100];
    distanceLabel.text = [NSString stringWithFormat:@"Distance : %@",distane];
    
    UILabel *timeLabel = (UILabel*)[self viewWithTag:200];
    timeLabel.text = [NSString stringWithFormat:@"Time : %@",eta];
}
-(void)updateStatus:(NSString*)status{
    UILabel *timeLabel = (UILabel*)[self viewWithTag:10];
    timeLabel.text = status;
}
@end
