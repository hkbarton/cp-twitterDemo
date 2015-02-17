//
//  TwitterClient.h
//  twitter
//
//  Created by Ke Huang on 2/16/15.
//  Copyright (c) 2015 Ke Huang. All rights reserved.
//

#import "BDBOAuth1RequestOperationManager.h"
#import "User.h"
#import "Tweet.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager

- (void)login: (void (^)(User *user, NSError *error))callback;
- (void)logout;
- (void)handleCallbackURL:(NSURL *)url;

+ (TwitterClient *)defaultClient;

@end
