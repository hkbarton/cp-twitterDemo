//
//  TwitterQueryParameter.m
//  twitter
//
//  Created by Ke Huang on 2/18/15.
//  Copyright (c) 2015 Ke Huang. All rights reserved.
//

#import "TwitterQueryParameter.h"

@implementation TwitterQueryParameter

const int DefaultPageCount = 20;

+ (TwitterQueryParameter *) defaultParameter {
    TwitterQueryParameter *result = [[TwitterQueryParameter alloc] init];
    result.pageCount = DefaultPageCount;
    result.maxID = nil;
    result.sinceID = nil;
    result.isIncludeEntities = YES;
    return result;
}

- (NSDictionary *)getAPISearchParameter {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    [result setObject:@(self.pageCount) forKey:@"count"];
    if (self.maxID != nil) {
        [result setObject:self.maxID forKey:@"max_id"];
    }
    if (self.sinceID != nil) {
        [result setObject:self.sinceID forKey:@"since_id"];
    }
    if (self.isIncludeEntities) {
        [result setObject:@"true" forKey:@"include_entities"];
    } else {
        [result setObject:@"false" forKey:@"include_entities"];
    }
    return result;
}

@end
