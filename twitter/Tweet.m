//
//  Tweet.m
//  twitter
//
//  Created by Ke Huang on 2/16/15.
//  Copyright (c) 2015 Ke Huang. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

- (id)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        self.ID = [dictionary valueForKeyPath:@"id_str"];
        self.user = [[User alloc] initWithDictionary:[dictionary valueForKey:@"user"]];
        NSDictionary *retweet = [dictionary valueForKeyPath:@"retweeted_status"];
        if (retweet != nil) {
            self.retweetStatus = [[Tweet alloc] initWithDictionary:retweet];
        }
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"EEE MMM d HH:mm:ss Z y";
        self.createdAt = [formatter dateFromString:[dictionary valueForKeyPath:@"created_at"]];
        self.text = [dictionary valueForKeyPath:@"text"];
        NSDictionary *entities = [dictionary valueForKeyPath:@"entities"];
        if (entities) {
            NSArray *media = [dictionary valueForKeyPath:@"entities.media"];
            if (media && media.count > 0) {
                self.mainImageURL = [media[0] valueForKeyPath:@"media_url"];
            }
        }
        self.retweetCount = [[dictionary valueForKeyPath:@"retweet_count"] integerValue];
        self.isRetweeted = [[dictionary valueForKey:@"retweeted"] boolValue];
        NSInteger favCount =  [[dictionary valueForKeyPath:@"favorite_count"] integerValue];
        if (favCount == 0) {
            favCount =  [[dictionary valueForKeyPath:@"favourites_count"] integerValue];
        }
        self.favouritesCount = favCount;
        self.isFavorited = [[dictionary valueForKey:@"favorited"] boolValue];
    }
    return self;
}

- (NSDictionary *)toAPIData {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    [result setObject:self.text forKey:@"status"];
    if (self.in_reply_id) {
        [result setObject:self.in_reply_id forKey:@"in_reply_to_status_id"];
    }
    return result;
}

+ (NSArray *)tweetsWithArry:(NSArray *)dictinoaries {
    NSMutableArray *tweets = [NSMutableArray array];
    for (NSDictionary *dictionary in dictinoaries) {
        [tweets addObject:[[Tweet alloc] initWithDictionary:dictionary]];
    }
    return tweets;
}

+ (Tweet *)createNewTweet: (NSString *)text withReply: (NSString *)replyID {
    Tweet *result = [[Tweet alloc] init];
    result.text = text;
    result.in_reply_id = replyID;
    return result;
}

@end
