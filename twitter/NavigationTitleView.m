//
//  NavigationTitleView.m
//  twitter
//
//  Created by Ke Huang on 3/1/15.
//  Copyright (c) 2015 Ke Huang. All rights reserved.
//

#import "NavigationTitleView.h"

@interface NavigationTitleView()

@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelTweets;

@end

@implementation NavigationTitleView

-(void)setUser:(User *)user {
    self.labelName.text = user.name;
    self.labelTweets.text = [NSString stringWithFormat:@"%ld Tweets", user.tweetCount];
}

@end
