//
//  Tweet.h
//  twitter
//
//  Created by Ke Huang on 2/16/15.
//  Copyright (c) 2015 Ke Huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Tweet : NSObject

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) User *user;
@property (nonatomic, strong) Tweet *retweetStatus;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *mainImageURL;
@property (nonatomic, assign) NSInteger retweetCount;
@property (nonatomic, assign) BOOL isRetweeted;
@property (nonatomic, strong) Tweet *myRetweetStatus;
@property (nonatomic, assign) NSInteger favouritesCount;
@property (nonatomic, assign) BOOL isFavorited;
@property (nonatomic, assign) NSString *in_reply_id;

- (id)initWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)toAPIData;

+ (NSArray *)tweetsWithArry:(NSArray *)dictinoaries;
+ (Tweet *)createNewTweet: (NSString *)text withReply: (NSString *)replyID;

@end
