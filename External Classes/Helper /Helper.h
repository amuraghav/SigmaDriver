//
//  Helper.h
//  Restaurant
//
//  Created by 3Embed on 14/09/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface Helper : NSObject


@property(nonatomic,assign)float _latitude;
@property(nonatomic,assign)float _longitude;
@property(nonatomic,assign)int menu_valueChanged;
@property(nonatomic,assign)int locate_ValueChanged;
@property(nonatomic,strong)NSString *location;

@property(nonatomic, strong) NSMutableArray *helperContry;
@property(nonatomic, strong) NSMutableArray *helperCity;


+ (id)sharedInstance;

+(void)setToLabel:(UILabel*)lbl Text:(NSString*)txt WithFont:(NSString*)font FSize:(float)_size Color:(UIColor*)color;
+(void)setButton:(UIButton*)btn Text:(NSString*)txt WithFont:(NSString*)font FSize:(float)_size TitleColor:(UIColor*)t_color ShadowColor:(UIColor*)s_color;
+(void)showAlertWithTitle:(NSString*)title Message:(NSString*)message;
+(void)showErrorFor:(int)errorCode;
+(NSString *)removeWhiteSpaceFromURL:(NSString *)url;
+(NSString *)stripExtraSpacesFromString:(NSString *)string;
+(NSString *)getCurrentDateTime;
+(NSString*)getCurrentDate;
+(NSString*)getCurrentTime;
+(NSString*)getDayDate;
+(NSString *)getCurrentAppointmentDate;
+(NSString*)getDueTime :(NSString *)deliverytime;
+(UIColor *)getColorFromHexString:(NSString *)hexString;
+(NSDate *)convertGMTtoLocal:(NSString *)gmtDateStr;
+(NSDate *)convertLocalToGMT:(NSString *)localDateStr;
//check EmailValidation
+(NSString*)getReadbleDate:(NSString*)date;
+(BOOL) emailValidationCheck:(NSString *) emailToValidate;

+(BOOL)isIphone5;

+(NSString*)getDay:(NSDate *)date;

-(void)setCurrencyUnit;
+(NSString*)getDistanceUnit;
+(NSString*)getCurrencyUnit;

@end
