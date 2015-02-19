//
//  SMChatViewController.m
//  JabberClient
//
//  Created by Eduardo Alvarado Díaz on 12/31/14.
//  Copyright (c) 2014 Organization. All rights reserved.
//

#import "SMChatViewController.h"

@interface SMChatViewController ()

@end

@implementation SMChatViewController 

@synthesize messageField, chatWithUser, tView, turnSockets;
static CGFloat padding = 15.0;

- (JabberClientAppDelegate *)appDelegate{
    return (JabberClientAppDelegate *)[[UIApplication sharedApplication]delegate];
}

- (XMPPStream *)xmppStream{
    return [[self appDelegate]xmppStream];
}

- (id) initWithUser:(NSString *)userName{
    if (self = [super init]) {
        chatWithUser = userName;
        turnSockets = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.messages = [[NSMutableArray alloc]init];
    JabberClientAppDelegate *del = [self appDelegate];
    del._messageDelegate = self;
    [self.tView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    [self.messageField becomeFirstResponder];

    NSArray *userField = [chatWithUser componentsSeparatedByString:@"@"];
    self.navBar.topItem.title = [NSString stringWithFormat:@"Chat with %@",userField[0]];
    NSLog(@"%@",self.navBar.topItem.title);

    XMPPJID *jid = [XMPPJID jidWithString:chatWithUser];
    NSLog(@"Attemping TURN connection to %@", jid);
    TURNSocket *turnSocket = [[TURNSocket alloc] initWithStream:[self xmppStream] toJID:jid];
    [turnSockets addObject:turnSocket];
    [turnSocket startWithDelegate:self delegateQueue:dispatch_get_main_queue()];
}

- (void)turnSocket:(TURNSocket *)sender didSucceed:(GCDAsyncSocket *)socket{
    NSLog(@"TURN Connection succeeded!");
    NSLog(@"You now have a socket that you can use to send/receive data to/from the other person.");

    [turnSockets removeObject:sender];
}

- (void)turnSocketDidFail:(TURNSocket *)sender{
    NSLog(@"TURN Connection failed!");
    [turnSockets removeObject:sender];
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
        [m setObject:[messageStr substituteEmoticons] forKey:@"msg"];
        [m setObject:@"you" forKey:@"sender"];
        [m setObject:[NSString getCurrentTime] forKey:@"time"];

        [self.messages addObject:m];
        [self.tView reloadData];
    }
}

#pragma mark - Table view delegates

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSDictionary *s = (NSDictionary *) [self.messages objectAtIndex:indexPath.row];
    static NSString *CellIdentifier = @"MessageCellIdentifier";
    SMMessageViewTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[SMMessageViewTableCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier];
    }

    NSString *sender = [s objectForKey:@"sender"];
    NSString *message = [s objectForKey:@"msg"];
    NSString *time = [s objectForKey:@"time"];
    CGSize textSize = { 260.0, 10000.0 };
    CGSize size = [message sizeWithFont:[UIFont boldSystemFontOfSize:13]
                      constrainedToSize:textSize
                          lineBreakMode:NSLineBreakByWordWrapping];
    size.width += (padding/2);
    cell.messageContentView.text = message;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.userInteractionEnabled = NO;

    UIImage *bgImage = nil;
    if ([sender isEqualToString:@"you"]) { // left aligned
        bgImage = [[UIImage imageNamed:@"orange.png"] stretchableImageWithLeftCapWidth:24 topCapHeight:15];
        [cell.messageContentView setFrame:CGRectMake(padding, padding*2, size.width, size.height)];
        [cell.bgImageView setFrame:CGRectMake( cell.messageContentView.frame.origin.x - padding/2,
                                              cell.messageContentView.frame.origin.y - padding/2,
                                              size.width+padding,
                                              size.height+padding)];
    } else {
        bgImage = [[UIImage imageNamed:@"aqua.png"] stretchableImageWithLeftCapWidth:24 topCapHeight:15];
        [cell.messageContentView setFrame:CGRectMake(320 - size.width - padding,
                                                     padding*2,
                                                     size.width,
                                                     size.height)];
        [cell.bgImageView setFrame:CGRectMake(cell.messageContentView.frame.origin.x - padding/2,
                                              cell.messageContentView.frame.origin.y - padding/2,
                                              size.width+padding,
                                              size.height+padding)];
    }
    cell.bgImageView.image = bgImage;
    cell.senderAndTimeLabel.text = [NSString stringWithFormat:@"%@ %@", sender, time];

    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = (NSDictionary *)[self.messages objectAtIndex:indexPath.row];
    NSString *msg = [dict objectForKey:@"msg"];

    CGSize textSize = {260.0, 10000.0};
    CGSize size = [msg sizeWithFont:[UIFont boldSystemFontOfSize:13]
                                    constrainedToSize:textSize
                                        lineBreakMode:NSLineBreakByWordWrapping];
    size.height += padding*2;
    CGFloat height =  size.height < 65 ? 65 : size.height;
    return height;
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

    [messageContent setValue:[m substituteEmoticons] forKey:@"msg"];
    [messageContent setValue:[NSString getCurrentTime] forKey:@"time"];
    [self.messages addObject:messageContent];
    [self.tView reloadData];
}

#pragma mark - TextView

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([messageField.text isEqualToString:@""]) {
        return NO;
    }else{
        [self sendMessage];
//        [textField resignFirstResponder];
        return YES;
    }
}

@end
