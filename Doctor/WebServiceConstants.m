//
//  WebServiceConstants.m
//  Doctor
//
//  Created by Rahul Sharma on 18/04/14.
//  Copyright (c) 2014 3Embed. All rights reserved.
//

#import "AppConstants.h"

//Booking Type
 NSString *constkNotificationTypeBookingType  = @"1";
 NSString *constkNotificationTypeBookingAccept  = @"2";
 NSString *constkNotificationTypeBookingReject  = @"3";
 NSString *constkNotificationTypeBookingOnTheWay = @"6";
 NSString *constkNotificationTypeBookingArrived  = @"7";
 NSString *constkNotificationTypeBookingBeginTrip  = @"8";
 NSString *constkNotificationTypeBookingComplete  = @"9";


//Methods
 NSString *const MethodGetCarType                      =Process @"getTypes";
 NSString *const MethodPatientSignUp                   =Process  @"masterSignup1";
 NSString *const MethodPatientLogin                    =Process @"masterLogin";
 NSString *const MethodDoctorUploadImage               =Process @"uploadImage";
 NSString *const MethodAppointments                    =Process @"getMasterAppointments";
 NSString *const MethodGetPendingAppointments          =Process @"getPendingAppointments";
 NSString *const MethodAppointmentsHistoryWithPatients =Process @"getHistoryWith";
 NSString *const MethodRespondToAppointMent            =Process @"respondToAppointment";
 NSString *const MethodGetMySlotes                     =Process @"getMySlots";
 NSString *const MethodupdateApptStatus                =Process @"updateApptStatus";
 NSString *const MethodGetMasterProfile                =Process @"getMasterProfile";
 NSString *const MethodResetPassword                   =Process @"resetPassword";
 NSString *const MethodLogout                          =Process @"logout";
 NSString *const MethodAppointmentDetail               =Process @"getAppointmentDetails";
 NSString *const MethodUploadImage                      =Process @"uploadImage";
 NSString *const MethodUpdateMasterStatus                =Process @"updateMasterStatus";
 NSString *const MethodCancelBooking                  =Process @"abortJourney";
NSString *const MethodUpdateAppointmentDetail         = Process @"updateApptDetails";

//add new one
 NSString *const MethodchangePassword                    =Process @"changePassword";

// SMP-Service Method Parameter

//SignUp

NSString *kSMPSignUpFirstName                  = @"ent_first_name";
NSString *kSMPSignUpLastName                   = @"ent_last_name";
NSString *kSMPSignUpMobile                     = @"ent_mobile";
NSString *kSMPSignUpEmail                      = @"ent_email";
NSString *kSMPSignUpPassword                   = @"ent_password";
NSString *kSMPSignUpAddLine1                   = @"ent_address_line1";
NSString *kSMPSignUpAddLine2                   = @"ent_address_line2";
NSString *kSMPSignUpAccessToken                = @"ent_token";
NSString *kSMPSignUpDateTime                   = @"ent_date_time";
NSString *kSMPSignUpCountry                    = @"ent_country";
NSString *kSMPSignUpCity                       = @"ent_city";
NSString *kSMPSignUpDeviceType                 = @"ent_device_type";
NSString *kSMPSignUpDeviceId                   = @"ent_dev_id";
NSString *kSMPSignUpPushToken                  = @"ent_push_token";
NSString *kSMPSignUpZipCode                    = @"ent_zipcode";
NSString *kSMPSignUpCreditCardNo               = @"ent_cc_num";
NSString *kSMPSignUpCreditCardCVV              = @"ent_cc_cvv";
NSString *kSMPSignUpCreditCardExpiry           = @"ent_cc_exp";
NSString *kSMPSignUpTandC                      = @"ent_terms_cond";
NSString *kSMPSignUpPricing                    = @"ent_pricing_cond";
NSString *kSMPSignUpLattitude                  = @"ent_lat";
NSString *kSMPSignUpLongitude                  = @"ent_long";
NSString *kSMPSignUpSeatCapcity                = @"ent_seat_cap";
NSString *kSMPSignUpRegistartionNumber         = @"ent_reg_num";
NSString *kSMPSignUpLicenceNumber              = @"ent_dd_num";
NSString *kSMPSignUpCarType                    = @"ent_service_type";
NSString *kSMPSignupCompneyId                  = @"ent_comp_id";
NSString *kSMPSignupTaxNumber                  = @"ent_tax_num";
NSString *kSMPSignupCompneyname                = @"ent_comp_name";

NSString *kSMPoplock                           = @"ent_pop_lock";
NSString *kSMOtp                               = @"ent_otp";

NSString *kSMStripeAccount                           = @"ent_stripe_account";
//NSString *kSMStripeConnect                           = @"ent_stripe_connect";
NSString *kSMentStripeJson                           = @"ent_stripe_json";




//Request Params For Login

NSString *kSMPLoginEmail                       = @"ent_email";
NSString *kSMPLoginPassword                    = @"ent_password";
NSString *kSMPLoginDeviceType                  = @"ent_device_type";
NSString *kSMPLoginDevideId                    = @"ent_dev_id";
NSString *kSMPLoginPushToken                   = @"ent_push_token";
NSString *kSMPLoginCarId                       = @"ent_car_id";


//Request Params For Reset

NSString *kSMPUserType                       = @"ent_user_type";
NSString *kSMPOldPassword                    = @"ent_old_password";
NSString *kSMPNewPassword                    = @"ent_password";
NSString *kSResetpswSeesionToken             = @"ent_sess_token";
NSString *kSMPResetpswDevideId               = @"ent_dev_id";








//Request for Upload Image
NSString *kSMPUploadDeviceId                     = @"ent_dev_id";
NSString *kSMPUploadSessionToken                 = @"ent_sess_token";
NSString *kSMPUploadImageName                    = @"ent_snap_name";
NSString *kSMPUploadImageChunck                  = @"ent_snap_chunk";
NSString *kSMPUploadfrom                         = @"ent_upld_from";
NSString *kSMPUploadtype                         = @"ent_snap_type";
NSString *kSMPUploadDateTime                     = @"ent_date_time";
NSString *kSMPUploadOffset                       = @"ent_offset";

//params for Firstname
NSString *kSMPFirstName                          = @"ent_first_name";
NSString *kSMPLastName                           = @"ent_last_name";
NSString *kSMPEmail                              = @"ent_email";
NSString *kSMPPhoneNo                            = @"ent_mobile";
NSString *kSMPPassword                           = @"ent_password";


// Common params

 NSString *kSMPCommonDeviceType                 =@"ent_device_type";
 NSString *kSMPCommonDevideId                   =@"ent_dev_id";
 NSString *kSMPCommonPushToken                  =@"ent_push_token";
 NSString *kSMPCommonUpDateTime                  =@"ent_date_time";

//Parsms for checking user loged out or not

NSString *kSMPcheckUserId                        = @"user_id";
NSString *kSMPcheckUserSessionToken              = @"ent_sess_token";
NSString *kSMPgetPushToken                       = @"ent_push_token";


//Requset for GetAppointment
NSString *kSMPAppointmentDate                  =@"ent_appnt_dt";

// Logout the user

NSString *kSMPLogoutSessionToken                = @"user_session_token";
NSString *kSMPLogoutUserId                      = @"logout_user_id";

//Requset for AcceptRejectBooking
 NSString *kSMPRespondPassengerEmail                   =@"ent_pas_email";
 NSString *kSMPRespondBookingDateTime                  =@"ent_appnt_dt";
 NSString *kSMPRespondResponse                         =@"ent_response";
 NSString *kSMPRespondBookingType                      =@"ent_book_type";
 NSString *kSMPRespondDocNotes                         =@"ent_doc_remarks";
 NSString *kSMPRespondDocbid                           =@"ent_appnt_id";

NSString *kSMPRespondcurrentAddress                   =@"ent_latitude";
NSString *kSMPRespondcurrentLatitude                  =@"ent_longitude";
NSString *kSMPRespondcurrentLongitude                 =@"ent_address_line";


//request For Passenger Deatil
 NSString *kSMPPassengerUserType                         =@"ent_user_type";

