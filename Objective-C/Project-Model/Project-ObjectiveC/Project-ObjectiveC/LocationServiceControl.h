//
//  LocationServiceControl.h
//  Carrorama3
//
//  Created by Érico Gimenes on 14/12/15.
//  Copyright © 2015 going2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationServiceControl : NSObject<CLLocationManagerDelegate>

//PROPRIEDADES
//-------------------------------------------------------------------------------------------------------------
@property(nonatomic, assign) CLAuthorizationStatus authorizationStatus;
@property(nonatomic, assign) CLError locationError;
@property(nonatomic, strong) NSString *statusMessage;
//
@property(nonatomic, assign) int updateCount;
@property(nonatomic, assign) double latitude;
@property(nonatomic, assign) double longitude;
//
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSDictionary *addressDictionary;
@property(nonatomic, strong) NSString *ISOcountryCode;
@property(nonatomic, strong) NSString *country;
@property(nonatomic, strong) NSString *postalCode;
@property(nonatomic, strong) NSString *administrativeArea;
@property(nonatomic, strong) NSString *subAdministrativeArea;
@property(nonatomic, strong) NSString *locality;
@property(nonatomic, strong) NSString *subLocality;
@property(nonatomic, strong) NSString *thoroughfare;
@property(nonatomic, strong) NSString *subThoroughfare;
@property(nonatomic, strong) CLRegion *region;


//MÉTODOS
//-------------------------------------------------------------------------------------------------------------
+ (LocationServiceControl*)initAndStartMonitoringLocation;
//
- (void)startMonitoringLocation;
- (void)stopMonitoring;


@end
