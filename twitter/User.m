//
//  User.m
//  twitter
//
//  Created by Ke Huang on 2/16/15.
//  Copyright (c) 2015 Ke Huang. All rights reserved.
//

#import "User.h"
#import "TwitterClient.h"

NSString *const UserDidLoginNotification = @"UserDidLoginNotification";
NSString *const UserDidLogoutNotification = @"UserDidLogoutNotification";

@interface User()

@property (nonatomic, strong) NSDictionary *userData;

@end

@implementation User

NSString *const kCurrentUserKey = @"kCurrentUserKey";

static User *_currentUser = nil;

- (id)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        self.userData = dictionary;
        self.ID = [dictionary valueForKeyPath:@"id_str"];
        self.name = [dictionary valueForKeyPath:@"name"];
        self.des = [dictionary valueForKeyPath:@"description"];
        self.handle = [[NSArray arrayWithObjects:@"@", [dictionary valueForKeyPath:@"screen_name"], nil] componentsJoinedByString:@""];
        self.profileImageURL = [dictionary valueForKeyPath:@"profile_image_url"];
        self.profileBGImageURL = [dictionary valueForKeyPath:@"profile_background_image_url"];
        self.location = [dictionary valueForKeyPath:@"location"];
        self.friendsCount = [[dictionary valueForKeyPath:@"friends_count"] integerValue];
        self.followerCount = [[dictionary valueForKeyPath:@"followers_count"] integerValue];
        self.followingCount = self.friendsCount;
        self.tweetCount = [[dictionary valueForKeyPath:@"statuses_count"] integerValue];
        
    }
    return self;
}

+ (User *)currentUser {
    if (_currentUser == nil) {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kCurrentUserKey];
        if (data != nil){
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            _currentUser = [[User alloc] initWithDictionary:dic];
        }
    }
    return _currentUser;
}

+ (void)setCurrentUser: (User *) user{
    _currentUser = user;
    if (_currentUser != nil) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:user.userData options:0 error:NULL];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:kCurrentUserKey];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kCurrentUserKey];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)logout {
    [User setCurrentUser:nil];
    [[TwitterClient defaultClient] logout];
    [[NSNotificationCenter defaultCenter] postNotificationName:UserDidLogoutNotification object:nil];
}

@end
