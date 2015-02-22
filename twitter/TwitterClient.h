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
#import "TwitterQueryParameter.h"

@interface TwitterClient : BDBOAuth1RequestOperationManager

- (void)login: (void (^)(User *user, NSError *error))callback;
- (void)logout;
- (void)handleCallbackURL:(NSURL *)url;

- (void)queryHomeTimeline: (TwitterQueryParameter *) param withCallback:(void (^)(NSArray *tweets, NSError *error))callback;
- (void)deleteTweet: (Tweet *)tweet withCallback:(void (^)(Tweet *tweet, NSError *error))callback;
- (void)retweet: (Tweet *)tweet withCallback:(void (^)(Tweet *tweet, NSError *error))callback;
- (void)favorite: (Tweet *)tweet withCallback:(void (^)(Tweet *tweet, NSError *error))callback;
- (void)unFavorite: (Tweet *)tweet withCallback:(void (^)(Tweet *tweet, NSError *error))callback;
- (void)tweet: (Tweet *)tweet withCallback:(void (^)(Tweet *tweet, NSError *error))callback;
- (void)getUserTimeline: (User *)user withParameter:(TwitterQueryParameter *) param withCallback:(void (^)(NSArray *tweets, NSError *error))callback;

+ (TwitterClient *)defaultClient;

@end
