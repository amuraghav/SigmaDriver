//
//  AppConstants.h
//  privMD
//
//  Created by Surender Rathore on 22/03/14.
//  Copyright (c) 2014 Rahul Sharma. All rights reserved.
//




#pragma mark - enums

typedef enum {
    
    kNotificationTypeBookingAccept1 = 2,
    kNotificationTypeBookingReject1 = 3,
    kNotificationTypeBookingOnTheWay = 6,
    kNotificationTypeBookingArrived = 7,
    kNotificationTypeBookingBeginTrip = 8,
    kNotificationTypeBookingComplete = 9,
    
}BookingNotificationType;

#define Process @"newLogic.php/"
#define BASE_IP @"http://auscartaxiapp.onsisdev.info/"

typedef enum {
    kPubNubStartStreamAction = 1,
    kPubNubCheckDriverStatusAction = 2,
    kPubNubUpdatePatientAppointmentLocationAction = 3,
    kPubNubStartUploadLocation = 4,
    kPubNubDriverCancelBooking = 5,
    kPubNubStartDoctorLocationStreamAction = 6,
    kPubNubDriverReachedPickupLocation  = 7,
    kPubNubDriverBeginTrp = 8,
    kPubNubDriverReachedDestinationLoation  = 9,
}PubNubStreamAction;


typedef enum {
    kAppointmentTypeNow = 3,
    kAppointmentTypeLater = 4
}AppointmentType;

typedef enum {
    kMedicalSpecialistDoctor = 1,
    kMedicalSpecialistNurse = 2
}MedicalSpecialistType;


typedef enum {
    kResponseFlagSuccess = 0,
    kResponseFlagFailure = 1
}ResponseErrorFlagCodes;

typedef enum {
    kResponseErrorCode = 0,
   
}ResponseErrorCode;

typedef enum {
    KDriverStatusOnline = 3,
    kDriverStatusOffline = 4
}DriverStatus;


typedef enum {
    kPaymentStatusNotDone = 0,
    kPaymentStatusDone = 1,
    kPaymentStatusDisputRaised = 2,
    kPaymentStatusClosed = 3,
}PaymentStatus;

typedef enum {
    
    kCBRPassengerDoNotShow = 4,
    kCBRWrongAddressShown = 5,
    kCBRDPassengerRequestedCancel = 6,
    kCBRDoNotChargeClient = 7,
    kCBOhterReasons = 8,
   
}CancelBookingReasons;
#pragma mark - Constants
//eg: give prifix kPMD

extern NSString *const kPMDPublishStreamChannel;
extern NSString *const kPMDPubNubPublisherKey;
extern NSString *const kPMDPubNubSubcriptionKey;
extern NSString *const kPMDGoogleMapsAPIKey;
extern NSString *const kPMDCrashLyticsAPIKey;

extern NSString *const kPMDTestDeviceidKey;
extern NSString *const kPMDDeviceIdKey;

#pragma mark - mark URLs

//Base URL
extern NSString *BASE_URL_RESTKIT;
extern NSString *BASE_URL;
extern NSString *const   baseUrlForXXHDPIImage;
extern NSString *const   baseUrlForOriginalImage;
extern NSString *const   baseUrlForThumbnailImage;
extern NSString *const   baseUrlForUploadImage;


#pragma mark - ServiceMethods
// eg : prifix kSM
extern NSString *const kSMLiveBooking;
extern NSString *const kSMGetAppointmentDetial;
extern NSString *const kSMUpdateSlaveReview;
extern NSString *const kSMGetMasters ;



//Request Params For Logout the user

extern NSString *KDALogoutSessionToken;
extern NSString *KDALogoutUserId;
extern NSString *KDALogoutDateTime;

//Parsms for checking user loged out or not

extern NSString *KDAcheckUserLogedOut;
extern NSString *KDAcheckUserSessionToken;
extern NSString *KDAgetPushToken;

//Params to store the Country & City.

extern NSString *KDACountry;
extern NSString *KDACity;
extern NSString *KDALatitude;
extern NSString *KDALongitude;

//params for firstname
extern NSString *KDAFirstName;
extern NSString *KDALastName;
extern NSString *KDAEmail;
extern NSString *KDAPhoneNo;
extern NSString *KDAPassword;




#pragma mark - NSUserDeafults Keys
//eg : give prefix kNSU
extern NSString *const kNSURoadyoSubscribeChanelKey;
extern NSString *const kNSURoadyoPubNubChannelkey;
extern NSString *const kNSUAppoinmentDoctorDetialKey;
extern NSString *const kNSUPatientEmailAddressKey;
extern NSString *const kNSUMongoDataBaseAPIKey;
extern NSString *const kNSUDriverListnerChannelKey;
extern NSString *const kNSUPassengerChannelKey;
extern NSString *const kNSUDriverStatekey;
extern NSString *const kNSUDriverDistanceTravalled;

//Add two new key
extern NSString *const kNSUPatientCarNameKey;
extern NSString *const kNSUPatientCarIDKey;
//.........

#pragma mark - PushNotification Payload Keys
//eg : give prefix kPN
extern NSString *const kPNPayloadDoctorNameKey;
extern NSString *const kPNPayloadAppoinmentTimeKey;
extern NSString *const kPNPayloadDistanceKey;
extern NSString *const kPNPayloadEstimatedTimeKey;
extern NSString *const kPNPayloadDoctorEmailKey;
extern NSString *const kPNPayloadDoctorContactNumberKey;
extern NSString *const kPNPayloadProfilePictureUrlKey;
extern NSString *const kPNPayloadAppoinmentDateStringKey;
extern NSString *const kPNPayloadAppoinmentLatitudeKey;

#pragma mark - Controller Keys

#pragma mark - Notification Name keys
extern NSString *const kNotificationNewCardAddedNameKey;
extern NSString *const kNotificationCardDeletedNameKey;

#pragma mark - Network Error
extern NSString *const kNetworkErrormessage;
