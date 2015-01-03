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

@synthesize messageField, chatWithUser, tView;
static CGFloat padding = 20.0;

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
    //size.width += (padding/2);
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

@end
