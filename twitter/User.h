//
//  User.h
//  twitter
//
//  Created by Ke Huang on 2/16/15.
//  Copyright (c) 2015 Ke Huang. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const UserDidLoginNotification;
extern NSString *const UserDidLogoutNotification;

@interface User : NSObject

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *des;
@property (nonatomic, strong) NSString *handle;
@property (nonatomic, strong) NSString *profileImageURL;
@property (nonatomic, strong) NSString *profileBGImageURL;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, assign) NSInteger friendsCount;
@property (nonatomic, assign) NSInteger followerCount;
@property (nonatomic, assign) NSInteger followingCount;
@property (nonatomic, assign) NSInteger tweetCount;

- (id)initWithDictionary:(NSDictionary *)dictionary;

+ (User *)currentUser;
+ (void)setCurrentUser: (User *) user;
+ (void)logout;

@end
