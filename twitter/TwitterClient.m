//
//  TwitterClient.m
//  twitter
//
//  Created by Ke Huang on 2/16/15.
//  Copyright (c) 2015 Ke Huang. All rights reserved.
//

#import "TwitterClient.h"

@interface TwitterClient()

@property (nonatomic, strong) void (^loginCallback)(User *user, NSError *error);

@end

NSString *const kTwitterConsumerKey = @"GO8khUBGguDbMUKlB5ANPDWoz";
NSString *const kTwitterConsumerSecret = @"VAVIF15q8DpfScMcbXhLg9UZalUESOYof6aY5I32j0dFQNQqm2";
NSString *const kTwitterBaseUrl = @"https://api.twitter.com";
NSString *const kTwitterRequestTokenPath = @"oauth/request_token";
NSString *const kTwitterAuthorizePath = @"oauth/authorize?oauth_token=%@";
NSString *const kTwitterAccessTokenPath = @"oauth/access_token";
NSString *const kTwitterCallbackURL = @"cptwitterdemo://oauth";

NSString *const kTwitterAPIVerifyCredentials = @"1.1/account/verify_credentials.json";
NSString *const kTwitterAPIHomeLine = @"1.1/statuses/home_timeline.json";
NSString *const kTwitterAPIRetweet = @"1.1/statuses/retweet/%@.json";
NSString *const kTwitterAPIFavorite = @"1.1/favorites/create.json";
NSString *const kTwitterAPIUnFavorite = @"1.1/favorites/destroy.json";
NSString *const kTwitterAPIDelete = @"1.1/statuses/destroy/%@.json";
NSString *const kTwitterAPIUpdate = @"1.1/statuses/update.json";
NSString *const kTwitterAPIUserTimeline = @"1.1/statuses/user_timeline.json";
NSString *const kTwitterAPIMentionTimeline = @"1.1/statuses/mentions_timeline.json";

static TwitterClient *_defaultClient = nil;

@implementation TwitterClient

- (void)login: (void (^)(User *user, NSError *error))callback {
    self.loginCallback = callback;
    [self.requestSerializer removeAccessToken];
    [self fetchRequestTokenWithPath:kTwitterRequestTokenPath method:@"GET" callbackURL:[NSURL URLWithString:kTwitterCallbackURL] scope:nil success:^(BDBOAuth1Credential *requestToken) {
        NSURL *authURL = [NSURL URLWithString:[NSString stringWithFormat:[[NSArray arrayWithObjects:kTwitterBaseUrl, @"/", kTwitterAuthorizePath, nil] componentsJoinedByString:@""], requestToken.token]];
        [[UIApplication sharedApplication] openURL:authURL];
    } failure:^(NSError *error) {
        self.loginCallback(nil, error);
    }];
}

- (void)handleCallbackURL:(NSURL *)url {
    [self fetchAccessTokenWithPath:kTwitterAccessTokenPath method:@"POST" requestToken:[BDBOAuth1Credential credentialWithQueryString:url.query] success:^(BDBOAuth1Credential *accessToken) {
        [self.requestSerializer saveAccessToken:accessToken];
        [self GET:kTwitterAPIVerifyCredentials parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            User *user = [[User alloc] initWithDictionary:responseObject];
            [User setCurrentUser:user];
            self.loginCallback(user, nil);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            self.loginCallback(nil, error);
        }];
    } failure:^(NSError *error) {
        self.loginCallback(nil, error);
    }];
}

- (void)logout {
    [self.requestSerializer removeAccessToken];
}

- (void)queryHomeTimeline: (TwitterQueryParameter *) param withCallback:(void (^)(NSArray *tweets, NSError *error))callback {
    [self GET:kTwitterAPIHomeLine parameters:[param getAPISearchParameter] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        callback([Tweet tweetsWithArry:responseObject], nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        callback(nil, error);
    }];
}

- (void)getUserTimeline: (User *)user withParameter:(TwitterQueryParameter *) param withCallback:(void (^)(NSArray *tweets, NSError *error))callback {
    NSMutableDictionary *apiParam = [param getAPISearchParameter];
    [apiParam setObject:user.ID forKey:@"user_id"];
    [apiParam removeObjectForKey:@"include_entities"];
    [self GET:kTwitterAPIUserTimeline parameters:apiParam success:^(AFHTTPRequestOperation *operation, id responseObject) {
        callback([Tweet tweetsWithArry:responseObject], nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        callback(nil, error);
    }];
}

- (void)getMentionTimeline:(TwitterQueryParameter *) param withCallback:(void (^)(NSArray *tweets, NSError *error))callback {
    NSMutableDictionary *apiParam = [param getAPISearchParameter];
    [self GET:kTwitterAPIMentionTimeline parameters:apiParam success:^(AFHTTPRequestOperation *operation, id responseObject) {
        callback([Tweet tweetsWithArry:responseObject], nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        callback(nil, error);
    }];
}

- (void)deleteTweet: (Tweet *)tweet withCallback:(void (^)(Tweet *tweet, NSError *error))callback {
    if (tweet==nil) {
        callback(nil, [[NSError alloc] init]);
        return;
    }
    [self POST:[NSString stringWithFormat:kTwitterAPIDelete, tweet.ID] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        callback([[Tweet alloc] initWithDictionary:responseObject], nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        callback(nil, error);
    }];
}

- (void)retweet: (Tweet *)tweet withCallback:(void (^)(Tweet *tweet, NSError *error))callback {
    [self POST:[NSString stringWithFormat:kTwitterAPIRetweet, tweet.ID] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        tweet.myRetweetStatus = [[Tweet alloc] initWithDictionary:responseObject];
        callback(tweet.myRetweetStatus, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        callback(nil, error);
    }];
}

- (void)favorite: (Tweet *)tweet withCallback:(void (^)(Tweet *tweet, NSError *error))callback {
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:tweet.ID, @"id", nil];
    [self POST:kTwitterAPIFavorite parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        callback([[Tweet alloc] initWithDictionary:responseObject], nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        callback(nil, error);
    }];
}

- (void)unFavorite: (Tweet *)tweet withCallback:(void (^)(Tweet *tweet, NSError *error))callback {
    NSDictionary *param = [[NSDictionary alloc] initWithObjectsAndKeys:tweet.ID, @"id", nil];
    [self POST:kTwitterAPIUnFavorite parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        callback([[Tweet alloc] initWithDictionary:responseObject], nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        callback(nil, error);
    }];
}

- (void)tweet: (Tweet *)tweet withCallback:(void (^)(Tweet *tweet, NSError *error))callback {
    [self POST:kTwitterAPIUpdate parameters:[tweet toAPIData] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        callback([[Tweet alloc] initWithDictionary:responseObject], nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error);
        callback(nil, error);
    }];
}

+ (TwitterClient *)defaultClient {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (_defaultClient == nil) {
            _defaultClient = [[TwitterClient alloc] initWithBaseURL:[NSURL URLWithString:kTwitterBaseUrl] consumerKey:kTwitterConsumerKey consumerSecret:kTwitterConsumerSecret];
        }
    });
    return _defaultClient;
}

@end
