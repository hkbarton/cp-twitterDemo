//
//  MenuViewController.h
//  twitter
//
//  Created by Ke Huang on 2/28/15.
//  Copyright (c) 2015 Ke Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MenuViewController;

@protocol MenuViewControllerDelegate

@optional

-(void)menuViewController:(MenuViewController *)menuViewController didMenuSelected:(NSString *)menuID;

@end

@interface MenuViewController : UIViewController

@property (nonatomic, weak) id<MenuViewControllerDelegate> delegate;

@end
