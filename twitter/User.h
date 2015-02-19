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
@property (nonatomic, strong) NSString *screenName;
@property (nonatomic, strong) NSString *profileImageURL;

- (id)initWithDictionary:(NSDictionary *)dictionary;

+ (User *)currentUser;
+ (void)setCurrentUser: (User *) user;
+ (void)logout;

@end
