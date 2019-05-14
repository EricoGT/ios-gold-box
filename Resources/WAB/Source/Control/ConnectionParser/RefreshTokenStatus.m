//
//  RefreshTokenStatus.m
//  Walmart
//
//  Created by Marcelo Santos on 1/18/16.
//  Copyright © 2016 Marcelo Santos. All rights reserved.
//

#import "RefreshTokenStatus.h"

@interface RefreshTokenStatus ()

@property (weak, nonatomic) IBOutlet UILabel *lblToken;

@end

@implementation RefreshTokenStatus

@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _lblToken.text = _strToken;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //you receive touch here
    [[self delegate] removeStatusRefreshToken];
}

- (void)expireToken:(NSString *) token {
    
    NSString *strUrl = @"https://napsao-nix-qa-wm-acesso-app-1.qa.vmcommerce.intra:80/connect/logout/mobile?token";
    
#if defined CONFIGURATION_Staging
    strUrl = @"https://acesso.stg.vmcommerce.intra:80/connect/logout/mobile?token";
#endif
    
    strUrl = [NSString stringWithFormat:@"%@=%@", strUrl, token];
    NSURL *url = [NSURL URLWithString:strUrl];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:35];
    [request setHTTPMethod:@"GET"];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *connectionError)
      {
          NSString *file = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
          LogInfo(@"Response expire token status: %@", file);
          
          NSHTTPURLResponse *aResponse = (NSHTTPURLResponse *)response;
          
          int responseStatusCode = (int)[aResponse statusCode];
          
          LogInfo(@"Status Code expire token status: %i", responseStatusCode);
          
          if (responseStatusCode == 200) {
              
              dispatch_async(dispatch_get_main_queue(), ^{
                  LogInfo(@"Token EXPIRED token status");
              });
          }
      }
      ] resume];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
