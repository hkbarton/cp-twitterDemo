//
//  ProfileViewController.h
//  twitter
//
//  Created by Ke Huang on 2/28/15.
//  Copyright (c) 2015 Ke Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Tweet.h"
#import "TwitterClient.h"

@class ProfileViewController;

@protocol ProfileViewControllerDelegate

@optional

-(void)profileViewController:(ProfileViewController *)profileViewController didMenuClicked:(BOOL)isMenuClicked;

@end

@interface ProfileViewController : UIViewController

-(ProfileViewController *)initWithUser:(User *) user;

@property (nonatomic, weak) id<ProfileViewControllerDelegate> delegate;

@end
