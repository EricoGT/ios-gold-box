//
//  PSLog.h
//  Pensamentos
//
//  Created by Marcelo Santos on 26/03/13.
//  Copyright (c) 2013 Marcelo dos Santos. All rights reserved..
//

#import <Foundation/Foundation.h>

#if !defined CONFIGURATION_Release && !defined CONFIGURATION_EnterpriseTK
#define DEBUG_LEVEL 8
#else
#define DEBUG_LEVEL 0
#endif

#define DEBUG_URLS          (DEBUG_LEVEL >= 1)
#define DEBUG_ERROR         (DEBUG_LEVEL >= 2)
#define DEBUG_RTG           (DEBUG_LEVEL >= 3)
#define DEBUG_INFO          (DEBUG_LEVEL >= 4)
#define DEBUG_NEWCHECKOUT   (DEBUG_LEVEL >= 5)
#define DEBUG_TIME          (DEBUG_LEVEL >= 6)
#define DEBUG_MOB           (DEBUG_LEVEL >= 7)
#define DEBUG_MICRO         (DEBUG_LEVEL >= 8)

#define LogTime(format, ...)   do{ if(DEBUG_TIME)   \
NSLog((format), ##__VA_ARGS__); }while(0)
#define LogURL(format, ...)   do{ if(DEBUG_URLS)   \
NSLog((format), ##__VA_ARGS__); }while(0)
#define LogMob(format, ...)   do{ if(DEBUG_MOB)   \
NSLog((format), ##__VA_ARGS__); }while(0)
#define LogErro(format, ...)   do{ if(DEBUG_ERROR)   \
NSLog((format), ##__VA_ARGS__); }while(0)
#define LogInfo(format, ...)   do{ if(DEBUG_INFO)   \
NSLog((format), ##__VA_ARGS__); }while(0)
#define LogNewCheck(format, ...)   do{ if(DEBUG_NEWCHECKOUT)   \
NSLog((format), ##__VA_ARGS__); }while(0)
#define LogMicro(format, ...)   do{ if(DEBUG_MICRO)   \
NSLog((format), ##__VA_ARGS__); }while(0)
#define LogRtg(format, ...)   do{ if(DEBUG_RTG)   \
NSLog((format), ##__VA_ARGS__); }while(0)

@interface PSLog : NSObject

@end
