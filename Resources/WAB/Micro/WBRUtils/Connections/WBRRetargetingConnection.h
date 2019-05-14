//
//  WBRRetargetingConnection.h
//  Walmart
//
//  Created by Marcelo Santos on 6/6/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 ## Mock Control
 
 * **CONFIGURATION_Release, CONFIGURATION_EnterpriseTK and DEBUG**:<br>
 _Build Production_<br>
 Should ALWAYS be configured with NO.<br>
 * **CONFIGURATION_DebugCalabash or CONFIGURATION_TestWm**:<br>
 _Build for test_<br>
 Choose YES or NO as required.<br>
 * **OTHER BUILDS**:<br>
 Choose YES or NO as required.
 */
// MOCK Control---------------------------------------
#if defined CONFIGURATION_Release || CONFIGURATION_EnterpriseTK || DEBUG
#define USE_MOCK_RETARGETING NO

#else
#if defined CONFIGURATION_DebugCalabash || CONFIGURATION_TestWm
#define USE_MOCK_RETARGETING YES

#else
#define USE_MOCK_RETARGETING NO

#endif
#endif
// ---------------------------------------------------

@interface WBRRetargetingConnection : NSObject

- (void) requestRetargShowcases:(NSString *) strUrl success:(void (^)(NSHTTPURLResponse *httpResponse)) success failure:(void (^)(NSDictionary *dictError))failure;

@end
