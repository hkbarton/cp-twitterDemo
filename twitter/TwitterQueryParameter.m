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
    result.isIncludeEntries = YES;
    return result;
}

- (NSDictionary *)getAPISearchParameter {
    return nil;
}

@end
