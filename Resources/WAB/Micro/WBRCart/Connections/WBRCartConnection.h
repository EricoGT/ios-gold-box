//
//  WBRCartConnection.h
//  Walmart
//
//  Created by Marcelo Santos on 6/19/17.
//  Copyright © 2017 WMB Comercio Eletronico Ltda. All rights reserved.
//

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
#define USE_MOCK_CART NO

#else
#if defined CONFIGURATION_DebugCalabash
#define USE_MOCK_CART NO

#else
#if defined CONFIGURATION_TestWm
#define USE_MOCK_CART YES

#else
#define USE_MOCK_CART NO

#endif
#endif
#endif
// ---------------------------------------------------

#import <Foundation/Foundation.h>

@interface WBRCartConnection : NSObject

@end
