//
//  SMChatViewController.m
//  JabberClient
//
//  Created by Eduardo Alvarado Díaz on 12/31/14.
//  Copyright (c) 2014 Organization. All rights reserved.
//

#import "SMChatViewController.h"
#define TimeStamp [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000]

@interface SMChatViewController ()

@end

@implementation SMChatViewController 

@synthesize messageField, chatWithUser, tView;

- (JabberClientAppDelegate *)appDelegate{
    return (JabberClientAppDelegate *)[[UIApplication sharedApplication]delegate];
}

- (XMPPStream *)xmppStream{
    return [[self appDelegate]xmppStream];
}

- (id) initWithUser:(NSString *)userName{
    if (self = [super init]) {
        chatWithUser = userName;
        self.navItem.title = userName;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.messages = [[NSMutableArray alloc]init];
    JabberClientAppDelegate *del = [self appDelegate];
    del._messageDelegate = self;

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

        NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
        [body setStringValue:messageStr];

        NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
        [message addAttributeWithName:@"type" stringValue:@"chat"];
        [message addAttributeWithName:@"to" stringValue:chatWithUser];
        [message addChild:body];

        [self.xmppStream sendElement:message];

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

- (void) newMessageReceived:(NSDictionary *)messageContent{
    NSString *m = [messageContent objectForKey:@"msg"];

    [messageContent setValue:m forKey:@"msg"];
    [messageContent setValue:TimeStamp forKey:@"time"];
    [self.messages addObject:messageContent];
    [self.tView reloadData];
}

@end
