// Copyright 2023 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "GADMAdapterIronSourceInterstitialAdDelegate.h"
#import "GADMAdapterIronSourceInterstitialAd.h"
#import "GADMediationAdapterIronSource.h"
#import "GADMAdapterIronSourceConstants.h"
#import "GADMAdapterIronSourceUtils.h"
#import <Foundation/Foundation.h>

@implementation GADMAdapterIronSourceInterstitialAdDelegate

- (GADMAdapterIronSourceInterstitialAdDelegate *)init {
    [IronSource setISDemandOnlyInterstitialDelegate:self];
    return self;
}

#pragma mark - ISDemandOnlyInterstitialDelegate

- (void)didClickInterstitial:(NSString *)instanceId {
    [GADMAdapterIronSourceUtils
     onLog:[NSString stringWithFormat:@"Interstitial did click for Instance ID: %@",
            instanceId]];
    
    GADMAdapterIronSourceInterstitialAd *adInstance = [GADMAdapterIronSourceInterstitialAd delegateForKey:instanceId];
    if (adInstance != nil){
        id<GADMediationInterstitialAdEventDelegate> eventDelegate = [adInstance getInterstitialAdEventDelegate];
        if (eventDelegate != nil){
            [eventDelegate reportClick];
        }
    }
}

- (void)interstitialDidClose:(NSString *)instanceId {
    [GADMAdapterIronSourceUtils
     onLog:[NSString stringWithFormat:@"Interstitial did close for Instance ID: %@",
            instanceId]];
    
    GADMAdapterIronSourceInterstitialAd *adInstance = [GADMAdapterIronSourceInterstitialAd delegateForKey:instanceId];
    if (adInstance != nil){
        [adInstance setState:GADMAdapterIronSourceInstanceStateCanLoad];
        id<GADMediationInterstitialAdEventDelegate> eventDelegate = [adInstance getInterstitialAdEventDelegate];
        if (eventDelegate != nil){
            [eventDelegate willDismissFullScreenView];
            [eventDelegate didDismissFullScreenView];
        }
    }
}

- (void)interstitialDidFailToLoadWithError:(NSError *)error
                                instanceId:(NSString *)instanceId {
    [GADMAdapterIronSourceUtils
     onLog:[NSString stringWithFormat:@"Interstitial did fail to load for Instance ID: %@ with error: %@",
            instanceId, error.localizedDescription]];
    
    GADMAdapterIronSourceInterstitialAd *adInstance = [GADMAdapterIronSourceInterstitialAd delegateForKey:instanceId];
    if (adInstance != nil){
        [adInstance setState:GADMAdapterIronSourceInstanceStateCanLoad];
        [adInstance getLoadCompletionHandler](nil, error);
    }
}

- (void)interstitialDidFailToShowWithError:(NSError *)error
                                instanceId:(NSString *)instanceId {
    [GADMAdapterIronSourceUtils
     onLog:[NSString stringWithFormat:@"Interstitial did fail to show for Instance ID: %@ with error: %@",
            instanceId, error.localizedDescription]];
    
    GADMAdapterIronSourceInterstitialAd *adInstance = [GADMAdapterIronSourceInterstitialAd delegateForKey:instanceId];
    if (adInstance != nil){
        [adInstance setState:GADMAdapterIronSourceInstanceStateCanLoad];
        id<GADMediationInterstitialAdEventDelegate> eventDelegate = [adInstance getInterstitialAdEventDelegate];
        if (eventDelegate != nil){
            [eventDelegate didFailToPresentWithError:error];
        }
    }
}

- (void)interstitialDidLoad:(NSString *)instanceId {
    [GADMAdapterIronSourceUtils
     onLog:[NSString stringWithFormat:@"Interstitial did load for Instance ID: %@", instanceId]];
    
    GADMAdapterIronSourceInterstitialAd *adInstance = [GADMAdapterIronSourceInterstitialAd delegateForKey:instanceId];
    if (adInstance != nil){
        [adInstance setState:GADMAdapterIronSourceInstanceStateCanLoad];
        GADMediationInterstitialLoadCompletionHandler loadCompletionHandler = [adInstance getLoadCompletionHandler];
        if (loadCompletionHandler != nil){
            [adInstance setInterstitialAdEventDelegate:loadCompletionHandler(adInstance,nil)];
        }
    }
}

- (void)interstitialDidOpen:(NSString *)instanceId {
    [GADMAdapterIronSourceUtils
     onLog:[NSString stringWithFormat:@"Interstitial did open for Instance ID: %@",
            instanceId]];
    
    GADMAdapterIronSourceInterstitialAd *adInstance = [GADMAdapterIronSourceInterstitialAd delegateForKey:instanceId];
    if (adInstance != nil){
        [adInstance setState:GADMAdapterIronSourceInstanceStateCanLoad];
        id<GADMediationInterstitialAdEventDelegate> eventDelegate = [adInstance getInterstitialAdEventDelegate];
        if (eventDelegate != nil){
            [eventDelegate willPresentFullScreenView];
            [eventDelegate reportImpression];
        }
    }
}

@end
