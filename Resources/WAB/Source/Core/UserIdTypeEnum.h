//
//  UserIdTypeEnum.h
//  Walmart
//
//  Created by Renan Cargnin on 05/01/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#ifndef UserIdTypeEnum_h
#define UserIdTypeEnum_h

typedef enum : NSUInteger {
    UserIdTypeNone = 0,
    UserIdTypeAll = 1,
    UserIdTypePid = 2,
    UserIdTypeVid = 3,
    UserIdTypeDevice = 4
} UserIdType;

#endif /* UserIdTypeEnum_h */
