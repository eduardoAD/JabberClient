//
//  ViewController.m
//  JabberClient
//
//  Created by Eduardo Alvarado Díaz on 12/30/14.
//  Copyright (c) 2014 Organization. All rights reserved.
//

#import "SMBuddyListViewController.h"
#import "XMPP.h"
#import "XMPPRoster.h"

@interface SMBuddyListViewController ()

@end

@implementation SMBuddyListViewController

@synthesize tView, onlineBuddies, buddyField;

- (JabberClientAppDelegate *)appDelegate{
    return (JabberClientAppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (XMPPStream *)xmppStream{
    return [[self appDelegate] xmppStream];
}

- (XMPPRoster *)xmppRoster{
    return [[self appDelegate] xmppRoster];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    onlineBuddies = [[NSMutableArray alloc] init];
    JabberClientAppDelegate *del = [self appDelegate];
    del._chatDelegate = self;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSString *login = [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"];
    if (login) {
        if ([[self appDelegate] connect]) {
            NSLog(@"Show buddy list");
        }
    }else{
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
    NSString *userName = (NSString *)[onlineBuddies objectAtIndex:indexPath.row];
    SMChatViewController *chatController = [[SMChatViewController alloc] initWithUser:userName];
    [self presentViewController:chatController animated:YES completion:^{}];
}

#pragma mark - Chat delegate

- (void) newBuddyOnline:(NSString *)buddyName{
    if (![onlineBuddies containsObject:buddyName]) {
        [onlineBuddies addObject:buddyName];
        [self.tView reloadData];
    }
}

- (void) buddyWentOffline:(NSString *)buddyName{
    [onlineBuddies removeObject:buddyName];
    [self.tView reloadData];
}

- (void)didDisconnect{
    [onlineBuddies removeAllObjects];
    [self.tView reloadData];
}

- (IBAction) addBuddy {
    // XMPPJID *newBuddy = [XMPPJID jidWithString:self.buddyField.text];
    // [self.xmppRoster addBuddy:newBuddy withNickname:@"ciao"];
}

@end
