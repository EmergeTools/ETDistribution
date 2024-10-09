//
//  UpdateUtilObjc.m
//  DemoApp
//
//  Created by Itay Brenner on 9/10/24.
//  Copyright © 2024 Emerge Tools. All rights reserved.
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
