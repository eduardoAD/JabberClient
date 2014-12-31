//
//  JabberClientAppDelegate.m
//  JabberClient
//
//  Created by Eduardo Alvarado Díaz on 12/31/14.
//  Copyright (c) 2014 Organization. All rights reserved.
//

#import "JabberClientAppDelegate.h"

@interface JabberClientAppDelegate()

- (void)setupStream;
- (void)goOnline;
- (void)goOffline;

@end

@implementation JabberClientAppDelegate

@synthesize xmppStream, window, viewController, password, open, _chatDelegate, _messageDelegate;

- (void)applicationWillResignActive:(UIApplication *)application {
    [self disconnect];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self connect];
}

- (void)setupStream{
    xmppStream = [[XMPPStream alloc]init];
    [xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
}

- (void)goOnline{
    XMPPPresence *presence = [XMPPPresence presence];
    [[self xmppStream] sendElement:presence];
}

- (void)goOffline{
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [[self xmppStream] sendElement:presence];
}

- (BOOL)connect{
    [self setupStream];

    NSString *jabberID = [[NSUserDefaults standardUserDefaults] stringForKey:@"userID"];
    NSString *myPassword = [[NSUserDefaults standardUserDefaults] stringForKey:@"userPassword"];

    if (![xmppStream isDisconnected]) {
        return YES;
    }

    if (jabberID == nil || myPassword == nil) {
        return NO;
    }

    [xmppStream setMyJID:[XMPPJID jidWithString:jabberID]];
    password = myPassword;

    NSError *error = nil;
    if (![xmppStream connectWithTimeout:1000 error:&error]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[NSString stringWithFormat:@"Can't connect to server %@", [error localizedDescription]]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        return NO;
    }

    return YES;
}

- (void)disconnect{
    [self goOffline];
    [xmppStream disconnect];
}

#pragma mark - XMPP delegates

- (void)xmppStreamDidConnect:(XMPPStream *)sender {
    // connection to the server successful
    open = YES;
    NSError *error = nil;
    [[self xmppStream] authenticateWithPassword:password error:&error];
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
    // authentication successful
    [self goOnline];
}


- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message {
    // message received
    NSString *msg = [[message elementForName:@"body"] stringValue];
    NSString *from = [[message attributeForName:@"from"] stringValue];

    NSMutableDictionary *m = [[NSMutableDictionary alloc] init];
    [m setObject:msg forKey:@"msg"];
    [m setObject:from forKey:@"sender"];

    [_messageDelegate newMessageReceived:m];
}

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence {
    // a buddy went offline/online
    NSString *presenceType = [presence type];   // online/offline
    NSString *myUsername = [[sender myJID] user];
    NSString *presenceFromUser = [[presence from] user];

    if (![presenceFromUser isEqualToString:myUsername]) {

        if ([presenceType isEqualToString:@"available"]) {

            [_chatDelegate newBuddyOnline:[NSString stringWithFormat:@"%@@%@", presenceFromUser, @"jerry.local"]];

        } else if ([presenceType isEqualToString:@"unavailable"]) {

            [_chatDelegate buddyWentOffline:[NSString stringWithFormat:@"%@@%@", presenceFromUser, @"jerry.local"]];
        }
    }
}

@end
