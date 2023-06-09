#import "AUTKMediationRewardedAdLoadAssertions.h"
#import "AUTKConstants.h"

AUTKMediationRewardedAdEventDelegate *_Nullable AUTKWaitAndAssertLoadRewardedAd(
    id<GADMediationAdapter> adapter, GADMediationRewardedAdConfiguration *configuration) {
  XCTestExpectation *expectation =
      [[XCTestExpectation alloc] initWithDescription:@"Load a rewarded ad."];

  AUTKMediationRewardedAdEventDelegate *eventDelegate =
      [[AUTKMediationRewardedAdEventDelegate alloc] init];
  GADMediationRewardedLoadCompletionHandler completionHandler =
      ^(id<GADMediationRewardedAd> _Nullable ad, NSError *_Nullable error) {
        XCTAssertNotNil(ad);
        XCTAssertNil(error);
        if (!error) {
          eventDelegate.rewardedAd = ad;
        }
        [expectation fulfill];
        return eventDelegate;
      };

  [adapter loadRewardedAdForAdConfiguration:configuration completionHandler:completionHandler];
  XCTWaiterResult result = [XCTWaiter waitForExpectations:@[ expectation ]
                                                  timeout:AUTKExpectationTimeout];
  return result == XCTWaiterResultCompleted ? eventDelegate : nil;
}

void AUTKWaitAndAssertLoadRewardedAdFailure(id<GADMediationAdapter> adapter,
                                            GADMediationRewardedAdConfiguration *configuration,
                                            NSError *expectedError) {
  XCTestExpectation *expectation =
      [[XCTestExpectation alloc] initWithDescription:@"Fail to load a rewarded ad."];

  GADMediationRewardedLoadCompletionHandler completionHandler =
      ^(id<GADMediationRewardedAd> _Nullable ad, NSError *_Nullable error) {
        XCTAssertNil(ad);
        XCTAssertNotNil(error);
        XCTAssertEqualObjects(error.domain, expectedError.domain);
        XCTAssertEqual(error.code, expectedError.code);

        [expectation fulfill];
        return [[AUTKMediationRewardedAdEventDelegate alloc] init];
      };
  [adapter loadRewardedAdForAdConfiguration:configuration completionHandler:completionHandler];
  (void)[XCTWaiter waitForExpectations:@[ expectation ] timeout:AUTKExpectationTimeout];
}