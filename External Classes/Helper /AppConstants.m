//
//  AppConstants.m
//  privMD
//
//  Created by Surender Rathore on 22/03/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//

#import "AppConstants.h"


#pragma mark - Constants

NSString *const kPMDPublishStreamChannel = @"my_channel";
//privMD keys
//NSString *const kPMDPubNubPublisherKey   = @"pub-c-9546795a-2ee3-4967-98f8-7bffe970e118";
//NSString *const kPMDPubNubSubcriptionKey = @"sub-c-776f16fc-ac6a-11e3-aaa5-02ee2ddab7fe";




//UberClone keys
NSString *const kPMDPubNubPublisherKey   = @"pub-c-9f491335-1e5b-4a4e-b96a-29044a72447b";
NSString *const kPMDPubNubSubcriptionKey = @"sub-c-a0c4236e-3f0a-11e6-9236-02ee2ddab7fe";
NSString *const kPMDGoogleMapsAPIKey     = @"AIzaSyDDWdKKY1kqf3AllJ1oHJ0IYn3qUgHV_GQ";
NSString *const kPMDCrashLyticsAPIKey    = @"8c41e9486e74492897473de501e087dbc6d9f391";
NSString *const kPMDTestDeviceidKey      = @"C2A33350-D9CF-4A7E-8751-A36016838381";
NSString *const kPMDDeviceIdKey = @"deviceid";


//AIzaSyA80S8GESH2uz1DLCET87f-CGyvduSw3Jw
#pragma mark - mark URLs
//Base URL
//#define BASE_IP  @"http://www.privemd.com/test/"


//NSString *BASE_URL   = @"http://108.166.190.172:81/doctor_app/process.php/";


//#define Process @"process.php/"

NSString *BASE_URL_RESTKIT                   = BASE_IP ;
NSString *BASE_URL                           = BASE_IP Process;
NSString *const   baseUrlForXXHDPIImage      = BASE_IP @"pics/xxhdpi/";
NSString *const   baseUrlForOriginalImage    = BASE_IP @"pics/";
NSString *const   baseUrlForThumbnailImage   = BASE_IP @"pics/mdpi/";
NSString *const   baseUrlForUploadImage      = BASE_IP Process @"uploadImage";


#pragma mark - ServiceMethods
// eg : prifix kSM
NSString *const kSMLiveBooking                = @"liveBooking";
NSString *const kSMGetAppointmentDetial       = @"getAppointmentDetails";
NSString *const kSMUpdateSlaveReview          = @"updateSlaveReview";
NSString *const kSMGetMasters                 = @"getMasters";


//Methods
//NSString *const MethodPatientSignUp                = @"masterSignup1";
//NSString *const MethodPatientLogin                 = @"masterLogin";
//NSString *const MethodDoctorUploadImage            = @"uploadImage";
//NSString *const MethodMakeCardDefault              = @"makeCardDefault";

//SignUp

NSString *KDASignUpFirstName                  = @"ent_first_name";
NSString *KDASignUpLastName                   = @"ent_last_name";
NSString *KDASignUpMobile                     = @"ent_mobile";
NSString *KDASignUpEmail                      = @"ent_email";
NSString *KDASignUpPassword                   = @"ent_password";
NSString *KDASignUpAddLine1                   = @"ent_address_line1";
NSString *KDASignUpAddLine2                   = @"ent_address_line2";
NSString *KDASignUpAccessToken                = @"ent_token";
NSString *KDASignUpDateTime                   = @"ent_date_time";
NSString *KDASignUpCountry                    = @"ent_country";
NSString *KDASignUpCity                       = @"ent_city";
NSString *KDASignUpDeviceType                 = @"ent_device_type";
NSString *KDASignUpDeviceId                   = @"ent_dev_id";
NSString *KDASignUpPushToken                  = @"ent_push_token";
NSString *KDASignUpZipCode                    = @"ent_zipcode";
NSString *KDASignUpCreditCardNo               = @"ent_cc_num";
NSString *KDASignUpCreditCardCVV              = @"ent_cc_cvv";
NSString *KDASignUpCreditCardExpiry           = @"ent_cc_exp";
NSString *KDASignUpTandC                      = @"ent_terms_cond";
NSString *KDASignUpPricing                    = @"ent_pricing_cond";
NSString *KDASignUpLattitude                  = @"ent_latitude";
NSString *KDASignUpLongitude                  = @"ent_longitude";
NSString *KDASignUpDoctorType                 = @"ent_service_type";


// Login

NSString *KDALoginEmail                       = @"ent_email";
NSString *KDALoginPassword                    = @"ent_password";
NSString *KDALoginDeviceType                  = @"ent_device_type";
NSString *KDALoginDevideId                    = @"ent_dev_id";
NSString *KDALoginPushToken                   = @"ent_push_token";
NSString *KDALoginUpDateTime                  = @"ent_date_time";

//Upload
//Upload
NSString *KDAUploadDeviceId                     = @"ent_dev_id";
NSString *KDAUploadSessionToken                 = @"ent_sess_token";
NSString *KDAUploadImageName                    = @"ent_snap_name";
NSString *KDAUploadImageChunck                  = @"ent_snap_chunk";
NSString *KDAUploadfrom                         = @"ent_upld_from";
NSString *KDAUploadtype                         = @"ent_snap_type";
NSString *KDAUploadDateTime                     = @"ent_date_time";
NSString *KDAUploadOffset                       = @"ent_offset";

// Logout the user

NSString *KDALogoutSessionToken                = @"user_session_token";
NSString *KDALogoutUserId                      = @"logout_user_id";



//Parsms for checking user loged out or not

NSString *KDAcheckUserId                        = @"user_id";
NSString *KDAcheckUserSessionToken              = @"ent_sess_token";
NSString *KDAgetPushToken                       = @"ent_push_token";

//Parsms for checking user active or not
//NSString *KDAcheckUserId                        = @"user_id";
//NSString *KDAcheckUserSessionToken              = @"ent_sess_token";
//NSString *KDAgetPushToken                       = @"ent_push_token";


//Params to store the Country & City.

NSString *KDACountry                            = @"country";
NSString *KDACity                               = @"city";
NSString *KDALatitude                           = @"latitudeQR";
NSString *KDALongitude                          = @"longitudeQR";

//params for Firstname
NSString *KDAFirstName                          = @"ent_first_name";
NSString *KDALastName                           = @"ent_last_name";
NSString *KDAEmail                              = @"ent_email";
NSString *KDAPhoneNo                            = @"ent_mobile";
NSString *KDAPassword                           = @"ent_password";



#pragma mark - NSUserDeafults Keys
NSString *const kNSURoadyoSubscribeChanelKey         = @"subChannel";
NSString *const kNSURoadyoPubNubChannelkey           = @"dChannel";
NSString *const kNSUAppoinmentDoctorDetialKey        = @"doctorDetial";
NSString *const kNSUPatientEmailAddressKey           = @"dEmail";
NSString *const kNSUMongoDataBaseAPIKey              = @"mongoDBapi";
NSString *const kNSUDriverListnerChannelKey          = @"listnerChannel";
NSString *const kNSUPassengerChannelKey              = @"passengerChn";
NSString *const kNSUDriverStatekey                   = @"driverState";
NSString *const kNSUDriverDistanceTravalled          = @"distanceTravalled";

//Add two new NSUserDefualts Keys

NSString *const kNSUPatientCarNameKey        = @"car_type_name";
NSString *const kNSUPatientCarIDKey        = @"status";





#pragma mark - PushNotification Payload Keys

 NSString *const kPNPayloadDoctorNameKey            = @"sname";
 NSString *const kPNPayloadAppoinmentTimeKey        = @"dt";
 NSString *const kPNPayloadDistanceKey              = @"dis";
 NSString *const kPNPayloadEstimatedTimeKey         = @"eta";
 NSString *const kPNPayloadDoctorEmailKey           = @"e";
 NSString *const kPNPayloadDoctorContactNumberKey   = @"ph";
 NSString *const kPNPayloadProfilePictureUrlKey     = @"pic";
 NSString *const kPNPayloadAppoinmentDateStringKey  = @"dt";
 NSString *const kPNPayloadAppoinmentLatitudeKey    = @"ltg";


#pragma mark - Controller Keys


#pragma mark - Notification Name keys
 NSString *const kNotificationNewCardAddedNameKey   = @"cardAdded";
 NSString *const kNotificationCardDeletedNameKey   = @"cardDeleted";

#pragma mark - Network Error
 NSString *const kNetworkErrormessage          = @"No network connection";



//#define BUTTON_BG_Color [UIColor colorWithRed:255.0/255.0 green:204.0/255.0 blue:2.0/255.0 alpha:1]


