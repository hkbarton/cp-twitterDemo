//
//  TwitterQueryParameter.h
//  twitter
//
//  Created by Ke Huang on 2/18/15.
//  Copyright (c) 2015 Ke Huang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TwitterQueryParameter : NSObject

@property (nonatomic, assign) NSInteger pageCount;
@property (nonatomic, strong) NSString *maxID;
@property (nonatomic, strong) NSString *sinceID;
@property (nonatomic, assign) BOOL isIncludeEntities;

+ (TwitterQueryParameter *) defaultParameter;

- (NSDictionary *)getAPISearchParameter;

@end
