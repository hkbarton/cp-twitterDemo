//
//  MenuViewController.m
//  twitter
//
//  Created by Ke Huang on 2/28/15.
//  Copyright (c) 2015 Ke Huang. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuTableViewCell.h"
#import "MenuHeaderView.h"

@interface MenuViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *menuData;

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // navigation bar
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"User"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(onSwitchUserClicked)];
    // setup table view
    [self.tableView registerNib:[UINib nibWithNibName:@"MenuTableViewCell" bundle:nil] forCellReuseIdentifier:@"MenuTableViewCell"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 57;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setSeparatorColor:[UIColor colorWithRed:57.0f/255.0f green:57.0f/255.0f blue:57.0f/255.0f alpha:1.0f]];
    // setup menu
    self.menuData = [NSArray arrayWithObjects:
                     [NSDictionary dictionaryWithObjectsAndKeys:@"home", @"icon", @"Home", @"menuDes", @"HOME", @"menuID", nil],
                     [NSDictionary dictionaryWithObjectsAndKeys:@"profile", @"icon", @"My Profile", @"menuDes", @"PROFILE", @"menuID", nil],
                     [NSDictionary dictionaryWithObjectsAndKeys:@"mention", @"icon", @"Mentions", @"menuDes", @"MENTION", @"menuID", nil],
                     [NSDictionary dictionaryWithObjectsAndKeys:@"Logout", @"icon", @"Log out", @"menuDes", @"LOGOUT", @"menuID", nil],
                     nil];
}

- (void)viewDidAppear:(BOOL)animated {
    MenuHeaderView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"MenuHeaderView" owner:self options:nil] objectAtIndex:0];
    headerView.frame = CGRectMake(0, 0, self.tableView.frame.size.width, 100);
    self.tableView.tableHeaderView = headerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)onSwitchUserClicked {
    
}

// fix separator inset bug
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuTableViewCell"];
    [cell setMenuItem:self.menuData[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *selectedMenuID = self.menuData[indexPath.row][@"menuID"];
    if (self.delegate) {
        [self.delegate menuViewController:self didMenuSelected:selectedMenuID];
    }
}


@end
