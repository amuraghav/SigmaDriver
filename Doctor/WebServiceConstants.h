//
//  WebServiceConstants.h
//  Doctor
//
//  Created by Rahul Sharma on 18/04/14.
//  Copyright (c) 2014 3Embed. All rights reserved.
//


//Booking Type
extern NSString *constkNotificationTypeBookingType;
extern NSString *constkNotificationTypeBookingAccept;
extern NSString *constkNotificationTypeBookingReject;
extern NSString *constkNotificationTypeBookingOnTheWay;
extern NSString *constkNotificationTypeBookingArrived;
extern NSString *constkNotificationTypeBookingComplete;
extern NSString *constkNotificationTypeBookingBeginTrip;


//Methods
extern NSString *const MethodPatientSignUp;
extern NSString *const MethodPatientLogin;
extern NSString *const MethodDoctorUploadImage;
extern NSString *const MethodAppointments;
extern NSString *const MethodGetPendingAppointments;
extern NSString *const MethodGetPendingAppointments;
extern NSString *const MethodAppointmentsHistoryWithPatients;
extern NSString *const MethodRespondToAppointMent;
extern NSString *const MethodGetMySlotes;
extern NSString *const MethodGetMasterProfile;
extern NSString *const MethodResetPassword;
extern  NSString *const MethodupdateApptStatus;
//extern NSString *const MethodDoctorActiveAndDeactive;
extern NSString *const MethodGetCarType;
extern NSString *const MethodLogout;
extern NSString *const MethodAppointmentDetail;
extern NSString *const MethodUploadImage;
extern NSString *const MethodUpdateMasterStatus;
extern NSString *const MethodCancelBooking;
extern NSString *const MethodUpdateAppointmentDetail;


extern NSString *const MethodchangePassword;

// SMP-Service Method Parameter

//Request Params For SignUp
extern NSString *kSMPSignUpFirstName;
extern NSString *kSMPSignUpLastName;
extern NSString *kSMPSignUpMobile;
extern NSString *kSMPSignUpEmail;
extern NSString *kSMPSignUpPassword;
extern NSString *kSMPSignUpCountry;
extern NSString *kSMPSignUpCity;
extern NSString *kSMPSignUpDeviceType;
extern NSString *kSMPSignUpDeviceId;
extern NSString *kSMPSignUpAddLine1;
extern NSString *kSMPSignUpAddLine2;
extern NSString *kSMPSignUpPushToken;
extern NSString *kSMPSignUpZipCode;
extern NSString *kSMPSignUpAccessToken;
extern NSString *kSMPSignUpDateTime;
extern NSString *kSMPSignUpCreditCardNo;
extern NSString *kSMPSignUpCreditCardCVV;
extern NSString *kSMPSignUpCreditCardExpiry;
extern NSString *kSMPSignUpTandC;
extern NSString *kSMPSignUpPricing;
extern NSString *kSMPSignUpLattitude;
extern NSString *kSMPSignUpLongitude;
extern NSString *kSMPSignUpDoctorType;
extern NSString *kSMPSignUpSeatCapcity;
extern NSString *kSMPSignUpRegistartionNumber;
extern NSString *kSMPSignUpLicenceNumber;
extern NSString *kSMPSignUpCarType;
extern NSString *kSMPSignupCompneyId;
extern NSString *kSMPSignupTaxNumber;
extern NSString *kSMPSignupCompneyname;
extern NSString *kSMPoplock;
extern NSString *kSMOtp;
extern NSString *kSMStripeAccount ;
extern NSString *kSMStripeConnect ;
extern NSString *kSMentStripeJson ;

//Request Params For Login

extern NSString *kSMPLoginEmail;
extern NSString *kSMPLoginPassword;
extern NSString *kSMPLoginDeviceType;
extern NSString *kSMPLoginDevideId;
extern NSString *kSMPLoginPushToken;
extern NSString *kSMPLoginUpDateTime;
extern NSString *kSMPLoginCarId;

//Request for Upload Image
extern NSString *kSMPUploadDeviceId;
extern NSString *kSMPUploadSessionToken;
extern NSString *kSMPUploadImageName;
extern NSString *kSMPUploadImageChunck;
extern NSString *kSMPUploadfrom;
extern NSString *kSMPUploadtype;
extern NSString *kSMPUploadDateTime;
extern NSString *kSMPUploadOffset;


//params for Firstname
extern NSString *kSMPFirstName;
extern NSString *kSMPLastName;
extern NSString *kSMPEmail;
extern NSString *kSMPPhoneNo;
extern NSString *kSMPPassword;

// Common params
extern NSString *kSMPCommonDeviceType;
extern NSString *kSMPCommonDevideId;
extern NSString *kSMPCommonPushToken;
extern NSString *kSMPCommonUpDateTime;

extern NSString *kSMPcheckUserId;
extern NSString *kSMPcheckUserSessionToken;
extern NSString *kSMPgetPushToken;


//Requset for AcceptRejectBooking
extern NSString *kSMPRespondPassengerEmail;
extern NSString *kSMPRespondBookingDateTime;
extern NSString *kSMPRespondResponse;
extern NSString *kSMPRespondBookingType;
extern NSString *kSMPRespondDocNotes;
extern NSString *kSMPRespondDocbid;


extern NSString *kSMPRespondcurrentAddress;
extern NSString *kSMPRespondcurrentLatitude;
extern NSString *kSMPRespondcurrentLongitude;



//Requset for Reset

NSString *kSMPUserType;
NSString *kSMPOldPassword ;
NSString *kSMPNewPassword ;
NSString *kSResetpswSeesionToken  ;
NSString *kSMPResetpswDevideId;




// Logout the user

extern NSString *kSMPLogoutSessionToken;
extern NSString *kSMPLogoutUserId;

//request For Passenger Deatil
extern NSString *kSMPPassengerUserType ;


