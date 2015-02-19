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
@property (nonatomic, strong) NSArray *entities;
@property (nonatomic, assign) NSInteger retweetCount;
@property (nonatomic, assign) BOOL isRetweeted;
@property (nonatomic, assign) NSInteger favouritesCount;
@property (nonatomic, assign) BOOL isFavorited;

- (id)initWithDictionary:(NSDictionary *)dictionary;

+ (NSArray *)tweetsWithArry:(NSArray *)dictinoaries;

@end
