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
    [self GET:kTwitterAPIHomeLine parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
        callback([Tweet tweetsWithArry:responseObject], nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
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
