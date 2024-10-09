//
//  UpdateUtilObjc.m
//  DemoApp
//
//  Created by Emerge Tools on 9/10/24.
//

#import "UpdateUtilObjc.h"
#import "DemoApp-Swift.h"
@import ETDistribution;

@implementation UpdateUtilObjc
- (void) checkForUpdates {
  [[ETDistribution sharedInstance] checkForUpdateWithApiKey:[Constants apiKey]
                                                    tagName:[Constants tagName]
                                         onReleaseAvailable:^(DistributionReleaseInfo *releaseInfo) {
    NSLog(@"Release info: %@", releaseInfo);
  }
                                                    onError:^(NSError *error) {
    NSLog(@"Error checking for update: %@", error);
  }];
}
@end
