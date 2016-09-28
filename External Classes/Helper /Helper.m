//
//  Helper.m
//  Restaurant
//
//  Created by 3Embed on 14/09/12.
//
//

#import "Helper.h"

@interface Helper ()
@property(nonatomic,strong)NSString *currency;
@property(nonatomic,strong)NSString *distanceUnit;
@end

@implementation Helper


static Helper *helper;
@synthesize _latitude;
@synthesize _longitude;
@synthesize menu_valueChanged;
@synthesize location;
@synthesize locate_ValueChanged;







+ (id)sharedInstance {
	if (!helper) {
		helper  = [[self alloc] init];
	}
	
	return helper;
}


+(void)setToLabel:(UILabel*)lbl Text:(NSString*)txt WithFont:(NSString*)font FSize:(float)_size Color:(UIColor*)color
{
   
    lbl.textColor = color;

    if (txt != nil) {
        lbl.text = txt;
    }
    
    
    if (font != nil) {
        lbl.font = [UIFont fontWithName:font size:_size];
    }
    
    lbl.backgroundColor = [UIColor clearColor];
    
    
}



+(void)setButton:(UIButton*)btn Text:(NSString*)txt WithFont:(NSString*)font FSize:(float)_size TitleColor:(UIColor*)t_color ShadowColor:(UIColor*)s_color
{
    [btn setTitle:txt forState:UIControlStateNormal];
    
    [btn setTitleColor:t_color forState:UIControlStateNormal];
    
    if (s_color != nil) {
        [btn setTitleShadowColor:s_color forState:UIControlStateNormal];
    }
    
    
    if (font != nil) {
        btn.titleLabel.font = [UIFont fontWithName:font size:_size];
    
    }
    else
    {
        btn.titleLabel.font = [UIFont systemFontOfSize:_size];
    }
}



+(void)showAlertWithTitle:(NSString*)title Message:(NSString*)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];

  
}



+(void)showErrorFor:(int)errorCode
{
//    switch (errorCode) {
//        case SERVER_EXCEPTION:
//            [Helper showAlertWithTitle:@"Error" Message:@"Could not connect to sever. Please try again."];
//            break;
//            
//        case PASSWORD_NOT_MATCH:
//            [Helper showAlertWithTitle:@"Error" Message:@"The password you entered is incorrect. Please try again "];
//            break;
//        case SUCCESSFULL_RESPONSE:
//            ;
//            break;
//        case REQUEST_PARAMETER_BLANK:
//            [Helper showAlertWithTitle:@"Alert" Message:@"Please enter valid information"];
//            break;
//        case EMAIL_NOT_MATCH:
//            [Helper showAlertWithTitle:@"Alert" Message:@"User already exists"];
//            break;
//        case SEARCH_RESULT_NULL:
//            [Helper showAlertWithTitle:@"Message" Message:@"No Result Found"];
//            break;
//        case SERVICE_RESPONSE_NULL:
//            [Helper showAlertWithTitle:@"Message" Message:@"No Result Found"];
//            break;
//        default:
//            break;
//    }
}

+ (NSString *)removeWhiteSpaceFromURL:(NSString *)url
{
	NSMutableString *string = [[NSMutableString alloc] initWithString:url] ;
	[string replaceOccurrencesOfString:@" " withString:@"%20" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [string length])];
    //	[string replaceOccurrencesOfString:@"www.museumhunters.com" withString:@"207.150.204.61" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [string length])];
    //	NSLog(@"returnted : %@",string);
	return string;
}


+ (NSString *)stripExtraSpacesFromString:(NSString *)string
{
	NSCharacterSet *whitespaces = [NSCharacterSet whitespaceCharacterSet];
	NSPredicate *noEmptyStrings = [NSPredicate predicateWithFormat:@"SELF != ''"];
	
	NSArray *parts = [string componentsSeparatedByCharactersInSet:whitespaces];
	NSArray *filteredArray = [parts filteredArrayUsingPredicate:noEmptyStrings];
	
	return [filteredArray componentsJoinedByString:@" "];
}

+(NSString*)getReadbleDate:(NSString*)date{
 
    NSDateFormatter *df = [Helper formatter];
    NSDate *d = [df dateFromString:date];
    df.dateFormat = @"dd MMM yyyy hh:mm a";
    NSString *dateString = [df stringFromDate:d];
    return dateString;
}
+(NSString*)getCurrentDate
{
    // Get current date time
    
    NSDate *currentDateTime = [NSDate date];
    
    // Instantiate a NSDateFormatter
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    // Set the dateFormatter format
    
    //[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    // or this format to show day of the week Sat,11-12-2011 23:27:09
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    // Get the date time in NSString
    
    NSString *dateInStringFormated = [dateFormatter stringFromDate:currentDateTime];

    return dateInStringFormated;
    //NSLog(@"%@", dateInStringFormated);
    
    // Release the dateFormatter
    
    //[dateFormatter release];
}


+(NSString*)getDueTime :(NSString *)deliverytime
{
    // Get current date time
    
    NSDate *currentDateTime = [NSDate date];
    
    // Instantiate a NSDateFormatter
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    // Set the dateFormatter format
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    // or this format to show day of the week Sat,11-12-2011 23:27:09
    
    
    
    // Get the date time in NSString
    
    //NSString *dateInStringFormated = [dateFormatter stringFromDate:currentDateTime];
    
    NSDate *toDate = [dateFormatter dateFromString:deliverytime];
    
   // NSTimeInterval difference = [currentDateTime timeIntervalSinceDate:toDate];
    
//    NSString *intervalString = [NSString stringWithFormat:@"%f", difference];
//    int timeInterval = [intervalString intValue];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [calendar components:NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit
                                               fromDate:toDate
                                                 toDate:currentDateTime
                                                options:0];
    
    NSLog(@"Difference in date components: %li/%li/%li", (long)components.day, (long)components.hour, (long)components.minute);
    
   
//    long seconds = lroundf(timeInterval); // Modulo (%) operator below needs int or long
//    int hour = seconds / 3600;
//    int mins = (seconds % 3600) / 60;
//    int secs = seconds % 60;
    
    NSString * stringDue = [NSString stringWithFormat:@"Day-%li Hours-%li Mins-%li Secs-%li",(long)components.day, (long)components.hour, (long)components.minute,(long)components.second];
    return stringDue;
    NSLog(@"day%@", stringDue);
    
    // Release the dateFormatter
    
    //[dateFormatter release];
}



+(NSString*)getCurrentTime
{
    NSDate *currentDateTime = [NSDate date];
    
    // Instantiate a NSDateFormatter
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    // Set the dateFormatter format
    
    //[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    // or this format to show day of the week Sat,11-12-2011 23:27:09
    
    [dateFormatter setDateFormat:@"HH:MM:SS"];
    
    // Get the date time in NSString
    
    NSString *dateInStringFormated = [dateFormatter stringFromDate:currentDateTime];
    
    return dateInStringFormated;

}



+(NSString*)getDayDate
{
    NSDate *currentDateTime = [NSDate date];
    
    // Instantiate a NSDateFormatter
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    // Set the dateFormatter format
    
    //[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    // or this format to show day of the week Sat,11-12-2011 23:27:09
    
    [dateFormatter setDateFormat:@"EEEE"];
    
    // Get the date time in NSString
    
    NSString *dateInStringFormated = [dateFormatter stringFromDate:currentDateTime];
    
    return dateInStringFormated;
}

+(NSString*)getDay:(NSDate *)date
{
    NSDate *currentDateTime = [NSDate date];
    
    // Instantiate a NSDateFormatter
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    // Set the dateFormatter format
    
    //[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    // or this format to show day of the week Sat,11-12-2011 23:27:09
    
    [dateFormatter setDateFormat:@"EEEE"];
    
    // Get the date time in NSString
    
    NSString *dateInStringFormated = [dateFormatter stringFromDate:currentDateTime];
    
    return dateInStringFormated;
}

+(NSString *)getCurrentDateTime
{
    
    
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *dateInStringFormated = [dateFormatter stringFromDate:now];
    
    NSLog(@"date in string %@ ",dateInStringFormated);
    
  //  NSDate *wer = [dateFormatter dateFromString:returnDate];
   // NSLog(@"date from string %@ ",wer);
    
    return dateInStringFormated;

}
+(NSString *)getCurrentAppointmentDate
{
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *dateInStringFormated = [dateFormatter stringFromDate:now];
    
    NSLog(@"date in string %@ ",dateInStringFormated);
    
     
    return dateInStringFormated;
    
}



+ (UIColor *)getColorFromHexString:(NSString *)hexString
{
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}


+(NSDate *)convertGMTtoLocal:(NSString *)gmtDateStr
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSTimeZone *gmt = [NSTimeZone systemTimeZone];
    
    [formatter setTimeZone:gmt];
    
    NSDate *localDate = [formatter dateFromString:gmtDateStr]; // get the date
    
    NSTimeInterval timeZoneOffset = [[NSTimeZone systemTimeZone] secondsFromGMT]; // You could also use the systemTimeZone method
    
    NSTimeInterval localTimeInterval = [localDate timeIntervalSinceReferenceDate] + timeZoneOffset;
    
    NSDate *localCurrentDate = [NSDate dateWithTimeIntervalSinceReferenceDate:localTimeInterval];
    return localCurrentDate;
    }



+(NSDate *)convertLocalToGMT:(NSString *)localDateStr
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *localDate = [formatter dateFromString: localDateStr];
    NSTimeInterval timeZoneOffset = [[NSTimeZone defaultTimeZone] secondsFromGMT]; // You could also use the systemTimeZone method
    NSTimeInterval gmtTimeInterval = [localDate timeIntervalSinceReferenceDate] - timeZoneOffset;
    NSDate *gmtDate = [NSDate dateWithTimeIntervalSinceReferenceDate:gmtTimeInterval];
    return gmtDate;
}


/*
 *  Validates an eMail Address.
 */
+ (BOOL) emailValidationCheck: (NSString *) emailToValidate
{
    NSString *regexForEmailAddress = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailValidation = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regexForEmailAddress];
    return [emailValidation evaluateWithObject:emailToValidate];
}


+(BOOL)isIphone5{
    
    if([[UIScreen mainScreen] bounds].size.height >= 568)
        return YES;
    else
        return NO;
}
+ (NSDateFormatter *)formatter {
    
    //EEE - day(eg: Thu)
    //MMM - month (eg: Nov)
    // dd - date (eg 01)
    // z - timeZone
    
    //eg : @"EEE MMM dd HH:mm:ss z yyyy"
    
    static NSDateFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    });
    return formatter;
}
+(NSString*)getDistanceUnit{
    return @"Km";
}
+(NSString*)getCurrencyUnit{
    return [[Helper sharedInstance] currency];
}
-(void)setCurrencyUnit{
    
    NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
    [currencyFormatter setLocale:[NSLocale currentLocale]];
   
    [currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    _currency = [currencyFormatter currencySymbol];
}


@end
