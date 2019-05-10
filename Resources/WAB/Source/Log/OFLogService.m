//
//  OFLogService.m
//  Walmart
//
//  Created by Marcelo Santos on 12/16/14.
//  Copyright (c) 2014 Marcelo Santos. All rights reserved.
//

#import "OFLogService.h"
@import AirshipKit;

@interface OFLogService ()

@end

@implementation OFLogService

- (void)sendLog:(LogError *)log
{
    [self sendLogsWithErrorEvent:log.event ?: @""
                   andRequestUrl:log.absolutRequest ?: @""
                  andRequestData:@""
                 andResponseCode:log.code ?: @""
                 andResponseData:log.data ? [[NSString alloc] initWithData:log.data encoding:NSUTF8StringEncoding] : @""
                  andUserMessage:log.userMessage ?: @""
                       andScreen:log.screen ?: @""
                     andFragment:log.fragment ?: @""];
}

- (void) sendLogsWithErrorEvent:(NSString *) errorEvent andRequestUrl:(NSString *) requestUrl andRequestData:(NSString *) requestData andResponseCode:(NSString *) responseCode andResponseData:(NSString *) responseData andUserMessage:(NSString *) userMessage andScreen:(NSString *) screen andFragment:(NSString *) fragment {
    
    //Verify if LOG SELECTOR is ON
    
    if ([OFSetup logsEnable]) {
        
        //Get Date Timestamp
        NSDate *dateNow = [NSDate date];
        NSString * timeInMS = [NSString stringWithFormat:@"%lld", [@(floor([dateNow timeIntervalSince1970] * 1000)) longLongValue]];

        //Get DeviceId
        NSString *deviceId = [[UAirship push] deviceToken] ?: @"";
        
        //Get Email
        NSString *email = [[NSUserDefaults standardUserDefaults] stringForKey:@"lgUs"] ?: @"";
        
        //Version
        NSString *versionApp = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] ?: @"";
        NSString *buildApp = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey] ?: @"";
        
        NSString *version = [NSString stringWithFormat:@"Version %@ - Build: %@ - %@", versionApp, buildApp, APP_VERSION];
        
        errorEvent = errorEvent ?: @"";
        responseCode = responseCode ?: @"";
        requestUrl = requestUrl ?: @"";
        requestData = requestData ?: @"";
        responseData = responseData ?: @"";
        userMessage = userMessage ?: @"";
        screen = screen ?: @"";
        fragment = fragment ?: @"";
        
        self.dictLog = @{@"deviceId"       :   deviceId,
                                  @"date"           :   timeInMS,
                                  @"errorEvent"     :   errorEvent,
                                  @"requestUrl"     :   requestUrl,
                                  @"requestData"    :   requestData,
                                  @"responseCode"   :   responseCode,
                                  @"responseData"   :   responseData,
                                  @"userMessage"    :   userMessage,
                                  @"system"         :   @"iOS",
                                  @"version"        :   version,
                                  @"email"          :   email,
                                  @"screen"         :   screen,
                                  @"fragment"       :   fragment
                                  };
        
        if (![fragment isEqualToString:@"test"]) {
            
            if ([[MDSSqlite new] addLogsToService:self.dictLog]) {
                LogInfo(@"Success added to DB :)");
            }
            else
            {
                LogErro(@"Error inserting into DB :)");
            }
        }
    }
    else
    {
        LogInfo(@"Logs service disabled (sendLogsWith...)!");
    }
}

- (void) getAllLogs {
    
    self.arrLogs = [[MDSSqlite new] getAllLogsFromDB];
    LogInfo(@"Array of Logs (waiting in DB): %@", self.arrLogs);
}

- (void) errorConnection:(NSString *)msgError op:(NSString *)operation {
    
    LogErro(@"Error :( : %@", msgError);
}

- (void) testInternet:(BOOL)sucess msg:(NSString *)msgInternetConnectionOk op:(NSString *)operation {
    
    LogErro(@"Error :( : %@", msgInternetConnectionOk);
}

@end
