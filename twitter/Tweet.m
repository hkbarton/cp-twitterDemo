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
        self.entities = nil; // TODO
        self.retweetCount = [[dictionary valueForKeyPath:@"retweet_count"] integerValue];
        self.isRetweeted = [[dictionary valueForKey:@"retweeted"] boolValue];
        self.favouritesCount = [[dictionary valueForKeyPath:@"favourites_count"] integerValue];
        self.isFavorited = [[dictionary valueForKey:@"favorited"] boolValue];
    }
    return self;
}

+ (NSArray *)tweetsWithArry:(NSArray *)dictinoaries {
    NSMutableArray *tweets = [NSMutableArray array];
    for (NSDictionary *dictionary in dictinoaries) {
        [tweets addObject:[[Tweet alloc] initWithDictionary:dictionary]];
    }
    return tweets;
}

@end
