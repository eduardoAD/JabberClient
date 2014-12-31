//
//  ViewController.m
//  JabberClient
//
//  Created by Eduardo Alvarado Díaz on 12/30/14.
//  Copyright (c) 2014 Organization. All rights reserved.
//

#import "SMBuddyListViewController.h"
#import <SMLoginViewController.h>

@interface SMBuddyListViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation SMBuddyListViewController

@synthesize tView;
@synthesize onlineBuddies;

- (void)viewDidLoad {
    [super viewDidLoad];
    onlineBuddies = [[NSMutableArray alloc] init];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSString *login = [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
    if (!login) {
        [self showLogin];
    }
}

- (void) showLogin {
    SMLoginViewController *loginController = [[SMLoginViewController alloc] init];
    [self presentViewController:loginController animated:YES completion:^{}];
}

#pragma mark - Table view delegates


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *s = (NSString *) [onlineBuddies objectAtIndex:indexPath.row];
    static NSString *CellIdentifier = @"buddyCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    cell.textLabel.text = s;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [onlineBuddies count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    // start a chat

}

@end
