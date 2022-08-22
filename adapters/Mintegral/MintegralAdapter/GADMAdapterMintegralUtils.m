// Copyright 2022 Google LLC
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

#import "GADMAdapterMintegralUtils.h"
#import "GADMediationAdapterMintegralConstants.h"

@implementation GADMAdapterMintegralUtils

+ (BOOL)isStringEmpty:(NSString *)value {
    if ([value isKindOfClass:NSString.class] && value.length > 0) {
        return NO;
    }else{
        return YES;
    }
}

NSError *_Nonnull GADMAdapterMintegralErrorWithCodeAndDescription(GADMintegralErrorCode code, NSString *_Nonnull description) {
    NSDictionary *userInfo =@{NSLocalizedDescriptionKey : description, NSLocalizedFailureReasonErrorKey : description};
    NSError *error = [NSError errorWithDomain:GADMAdapterMintegralErrorDomain
                                         code:code
                                     userInfo:userInfo];
    return error;
}

void GADMAdapterMintegralMutableSetAddObject(NSMutableSet *_Nullable set,
                                            NSObject *_Nonnull object) {
  if (object) {
    [set addObject:object];  // Allow pattern.
  }
}

@end
