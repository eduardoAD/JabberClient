//
//  SMChatViewController.m
//  JabberClient
//
//  Created by Eduardo Alvarado Díaz on 12/31/14.
//  Copyright (c) 2014 Organization. All rights reserved.
//

#import "SMChatViewController.h"

@interface SMChatViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation SMChatViewController 

@synthesize messageField, chatWithUser, tView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.messages = [[NSMutableArray alloc]init];

    [self.messageField becomeFirstResponder];
}

#pragma mark - Actions

- (IBAction)closeChat{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)sendMessage{
    NSString *messageStr = self.messageField.text;

    if ([messageStr length] > 0) {
        //send message through XMPP
        self.messageField.text = @"";

        NSMutableDictionary *m = [[NSMutableDictionary alloc]init];
        [m setObject:messageStr forKey:@"msg"];
        [m setObject:@"you" forKey:@"sender"];

        [self.messages addObject:m];
        [self.tView reloadData];
    }
}

#pragma mark - Table view delegates

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSDictionary *s = (NSDictionary *) [self.messages objectAtIndex:indexPath.row];
    static NSString *CellIdentifier = @"MessageCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }

    cell.textLabel.text = [s objectForKey:@"msg"];
    cell.detailTextLabel.text = [s objectForKey:@"sender"];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.userInteractionEnabled = NO;

    return cell;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.messages count];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;

}

#pragma mark - Chat delegates


@end
