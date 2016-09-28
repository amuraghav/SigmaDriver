//
//  Appointments.h
//  Roadyo
//
//  Created by Surender Rathore on 26/06/14.
//  Copyright (c) 2014 3Embed. All rights reserved.
//

//"apntDt":"2014-06-25 05:51:54",
//"pPic":"PAAbhi201420062025201220212040temp_photo.jpg",
//"email":"abhi1@mobifyi.com",
//"status":"8",
//"pickupDt":"",
//"dropDt":"",
//"fname":"Abhi",
//"phone":"987456321",
//"apntTime":"05:51 am",
//"apntDate":"2014-06-25",
//
//
//"apptLat":"13.0355",
//"apptLong":"77.5899",
//"addrLine1":"2\/B, Vinayakanagar, Hebbal",
//"addrLine2":"",
//"notes":"",
//"dropAddr1":"2\/B, Vinayakanagar, Hebbal",
//"dropAddr2":"",
//"dropLat":"13.035508787357",
//"dropLong":"77.589880563319",
//"duration":"0",
//"distanceMts":"",
//"amount":"10"

#import <Foundation/Foundation.h>

@interface Appointments : NSObject
@property(nonatomic,strong)NSString *apntDt;
@property(nonatomic,strong)NSString *pPic;
@property(nonatomic,strong)NSString *email;
@property(nonatomic,strong)NSString *status;
@property(nonatomic,strong)NSString *pickupDt;
@property(nonatomic,strong)NSString *dropDt;
@property(nonatomic,strong)NSString *fname;
@property(nonatomic,strong)NSString *phone;
@property(nonatomic,strong)NSString *apntTime;
@property(nonatomic,strong)NSString *apntDate;
@property(nonatomic,strong)NSString *apptLat;
@property(nonatomic,strong)NSString *apptLong;
@property(nonatomic,strong)NSString *addrLine1;
@property(nonatomic,strong)NSString *addrLine2;
@property(nonatomic,strong)NSString *notes;
@property(nonatomic,strong)NSString *dropAddr1;
@property(nonatomic,strong)NSString *dropAddr2;
@property(nonatomic,strong)NSString *dropLat;
@property(nonatomic,strong)NSString *dropLong;
@property(nonatomic,strong)NSString *duration;
@property(nonatomic,strong)NSString *distanceMts;
@property(nonatomic,strong)NSString *amount;

@end
