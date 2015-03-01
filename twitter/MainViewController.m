//
//  MainViewController.m
//  twitter
//
//  Created by Ke Huang on 2/25/15.
//  Copyright (c) 2015 Ke Huang. All rights reserved.
//

#import "MainViewController.h"
#import "HomeViewController.h"
#import "LoginViewController.h"
#import "MenuViewController.h"
#import "User.h"

@interface MainViewController () <HomeViewControllerDelegate, MenuViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (nonatomic, strong) UIViewController *contentViewController;

@property (nonatomic, assign)CGFloat oriLeftOfContentView;
@property (nonatomic, assign)CGFloat leftBorderLimitOfContentView;
@property (nonatomic, assign)CGFloat leftBorderCenterOfContentView;

@property (nonatomic, strong)NSString *curMenuID;

- (IBAction)panContentView:(UIPanGestureRecognizer *)sender;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
    self.leftBorderLimitOfContentView = appFrame.size.width - 140;
    self.leftBorderCenterOfContentView = self.leftBorderLimitOfContentView / 2;
    // Setup Hamburger Menu
    MenuViewController *mvc = [[MenuViewController alloc] init];
    mvc.delegate = self;
    UINavigationController *mnvc = [[UINavigationController alloc] initWithRootViewController:mvc];
    mnvc.navigationBar.barTintColor = [UIColor colorWithRed:90.0f/255.0f green:90.0f/255.0f blue:90.0f/255.0f alpha:1.0f];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    [self addChildViewController:mnvc];
    mnvc.view.frame = self.menuView.frame;
    [self.menuView addSubview:mnvc.view];
    [mnvc didMoveToParentViewController:self];
    // setup content view style
    self.contentView.layer.masksToBounds = NO;
    self.contentView.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.contentView.layer.shadowOffset = CGSizeMake(0.0f, 5.0f);
    self.contentView.layer.shadowOpacity = 0.5f;
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.contentView.bounds];
    self.contentView.layer.shadowPath = shadowPath.CGPath;
    // Steup home view
    [self showViewControllerInContentView:@"HOME"];
    self.curMenuID = @"HOME";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(BOOL)isMenuOpen {
    return self.contentView.frame.origin.x > 0;
}

-(void)openMenu {
    CGRect contentViewFrame = self.contentView.frame;
    contentViewFrame.origin.x = self.leftBorderLimitOfContentView;
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.contentView.frame = contentViewFrame;
    } completion:nil];
}

-(void)closeMenu {
    CGRect contentViewFrame = self.contentView.frame;
    contentViewFrame.origin.x = 0;
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.contentView.frame = contentViewFrame;
    } completion:nil];
}

-(void)homeViewController:(HomeViewController *)homeViewController didMenuClicked:(BOOL)isMenuClicked {
    if ([self isMenuOpen]) {
        [self closeMenu];
    } else {
        [self openMenu];
    }
}

-(void)logout {
    [User logout];
    UIView *animBgView = [[UIView alloc] initWithFrame:self.view.frame];
    animBgView.backgroundColor = [UIColor colorWithRed:84.0f/255.0f green:169.0f/255.0f blue:235.0f/255.0f alpha:1.0f];
    animBgView.alpha = 0;
    UIImageView *animImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TwitterLogo_Big"]];
    animImgView.frame = CGRectMake(0, 0, 1500, 1500);
    animImgView.center = animBgView.center;
    animImgView.alpha = 0;
    [animBgView addSubview:animImgView];
    [self.view addSubview:animBgView];
    [UIView animateWithDuration:0.7f delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        animImgView.frame = CGRectMake(0, 0, 96, 96);
        animImgView.center = animBgView.center;
        animImgView.alpha = 1;
        animBgView.alpha = 1;
    } completion:^(BOOL finished) {
        LoginViewController *lvc = [[LoginViewController alloc] init];
        [[UIApplication sharedApplication] keyWindow].rootViewController = lvc;
    }];
}

-(void)menuViewController:(MenuViewController *)menuViewController didMenuSelected:(NSString *)menuID {
    if ([menuID isEqual:@"LOGOUT"]) {
        [self logout];
    } else {
        if (![self.curMenuID isEqual:menuID]) {
            [self showViewControllerInContentView:menuID];
        }
        [self closeMenu];
    }
    self.curMenuID = menuID;
}

- (UIViewController *)createViewControllerByMenuID: (NSString *)menuID {
    UIViewController *result = nil;
    if ([menuID isEqual:@"HOME"] || [menuID isEqual:@"MENTION"]) {
        HomeViewController *hvc = [[HomeViewController alloc] initWithType:menuID];
        hvc.delegate = self;
        UINavigationController *hnvc = [[UINavigationController alloc] initWithRootViewController:hvc];
        hnvc.navigationBar.barTintColor = [UIColor colorWithRed:84.0f/255.0f green:169.0f/255.0f blue:235.0f/255.0f alpha:1.0f];
        [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
        result = hnvc;
    } else if ([menuID isEqual:@"PROFILE"]) {
        
    }
    return result;
}

- (void)showViewControllerInContentView: (NSString *)menuID {
    // remove old view controller
    if (self.contentViewController != nil) {
        [self.contentViewController willMoveToParentViewController:nil];
        [self.contentViewController.view removeFromSuperview];
        [self.contentViewController removeFromParentViewController];
    }
    // add new view controller
    self.contentViewController = [self createViewControllerByMenuID:menuID];
    [self addChildViewController:self.contentViewController];
    self.contentViewController.view.frame = self.contentView.bounds;
    [self.contentView addSubview:self.contentViewController.view];
    [self.contentViewController didMoveToParentViewController:self];
}

- (IBAction)panContentView:(UIPanGestureRecognizer *)sender {
    CGPoint translationPoint = [sender translationInView:self.view];
    CGPoint velocity = [sender velocityInView:self.view];
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        self.oriLeftOfContentView = self.contentView.frame.origin.x;
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        CGFloat left = self.oriLeftOfContentView + translationPoint.x;
        if (left < 0) {
            left = 0;
        } else if (left > self.leftBorderLimitOfContentView) {
            left = self.leftBorderLimitOfContentView;
        }
        CGRect frame = self.contentView.frame;
        frame.origin.x = left;
        self.contentView.frame = frame;
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        CGRect targetFrame = self.contentView.frame;
        targetFrame.origin.x = targetFrame.origin.x > self.leftBorderCenterOfContentView ? self.leftBorderLimitOfContentView : 0;
        if (velocity.x > 100) {
            targetFrame.origin.x = self.leftBorderLimitOfContentView;
        } else if (velocity.x < -100) {
            targetFrame.origin.x = 0;
        }
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.contentView.frame = targetFrame;
        } completion:nil];
    }
    
}
@end
