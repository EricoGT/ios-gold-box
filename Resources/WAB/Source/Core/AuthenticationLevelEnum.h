//
//  AuthenticationLevelEnum.h
//  Walmart
//
//  Created by Renan Cargnin on 05/01/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#ifndef AuthenticationLevelEnum_h
#define AuthenticationLevelEnum_h

typedef enum : NSUInteger {
    AuthenticationLevelNotRequired = 0,
    AuthenticationLevelOptional = 1,
    AuthenticationLevelRequired = 2,
} AuthenticationLevel;

#endif /* AuthenticationLevelEnum_h */
