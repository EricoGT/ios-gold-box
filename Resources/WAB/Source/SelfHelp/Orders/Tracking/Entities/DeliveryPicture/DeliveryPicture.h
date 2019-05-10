//
//  DeliveryPicture.h
//  Tracking
//
//  Created by Bruno Delgado on 4/22/14.
//  Copyright (c) 2014 Ginga One. All rights reserved.
//

@protocol DeliveryPicture
@end

@interface DeliveryPicture : JSONModel

@property (nonatomic, strong) NSString *imageName;

@end
