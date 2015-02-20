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
- (void)goAway;
- (void)goDND;

@end

@implementation JabberClientAppDelegate

@synthesize xmppStream, xmppRoster, window, viewController, password, isOpen, _chatDelegate, _messageDelegate;

- (void)applicationWillResignActive:(UIApplication *)application {
//    [self disconnect];
    NSLog(@"applicationWillResignActive ");
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
//    [self connect];
    NSLog(@"applicationDidBecomeActive ");
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
//    self.window.rootViewController = self.viewController;
//    [self.window makeKeyAndVisible];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(xmppStream:didReceiveMessage:) name:@"newMessage" object:nil];

    // Register for notifications
    [self registerForRemoteNotification];

    return YES;
}

- (void)registerForRemoteNotification{
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    UIUserNotificationType types  = UIUserNotificationTypeSound | UIUserNotificationTypeBadge | UIUserNotificationTypeAlert;

    if (version >= 8.0) {
        UIUserNotificationSettings *notificationsSettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:notificationsSettings];
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:types];
    }
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    application.applicationIconBadgeNumber -= notification.applicationIconBadgeNumber;
}


- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"applicationDidEnterBackground ");
    [self goDND];
}

- (void)applicationWillEnterForeground:(UIApplication *)application{
    NSLog(@"applicationDidEnterForeground ");
    [self goOnline];
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

- (void)goAway{
    XMPPPresence *presence = [XMPPPresence presence];
    DDXMLNode *show = [DDXMLNode elementWithName:@"show" stringValue:@"away"];
    [presence addChild:show];
    DDXMLNode *status = [DDXMLNode elementWithName:@"status" stringValue:@"Away"];
    [presence addChild:status];

    [[self xmppStream] sendElement:presence];
}

- (void)goDND{
    XMPPPresence *presence = [XMPPPresence presence];
    DDXMLNode *show = [DDXMLNode elementWithName:@"show" stringValue:@"dnd"];
    [presence addChild:show];

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
                                                            message:[NSString stringWithFormat:@"Can't connect to server: %@", [error localizedDescription]]
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
    [_chatDelegate didDisconnect];
}

#pragma mark - XMPP delegates

- (void)xmppStreamDidConnect:(XMPPStream *)sender {
    // connection to the server successful
    isOpen = YES;
    NSError *error = nil;
    [[self xmppStream] authenticateWithPassword:password error:&error];
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
    // authentication successful
    [self goOnline];
}

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq{
    return NO;
}


- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message {
    NSLog(@"didReveiceMessage: %@",message.description);
    NSLog(@" a");

    // message received
    NSString *msg = [[message elementForName:@"body"] stringValue];
    NSString *from = [[message attributeForName:@"from"] stringValue];

    if (msg == nil) {
        msg = @"nil";
    }
    if ([message isMessageWithBody]) {
        NSMutableDictionary *m = [[NSMutableDictionary alloc] init];
        [m setObject:msg forKey:@"msg"];
        [m setObject:from forKey:@"sender"];

        [_messageDelegate newMessageReceived:m];

#pragma mark Check app in background
        //here!
        if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
            UILocalNotification* localNotif = [[UILocalNotification alloc] init];
            localNotif.alertBody = [NSString stringWithFormat:@"%@:\n%@", from, msg];
            localNotif.applicationIconBadgeNumber = ++[UIApplication sharedApplication].applicationIconBadgeNumber;
            localNotif.repeatInterval = 0;
            [[UIApplication sharedApplication]  presentLocalNotificationNow:localNotif];
        }

    }
}

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence {
    NSLog(@"didReceivePresence: %@",presence.description);
    NSLog(@" ");
    // a buddy went offline/online
    NSString *presenceType = [presence type];   // online/offline
    NSString *myUsername = [[sender myJID] user];
    NSString *presenceFromUser = [[presence from] user];
    NSString *presenceFromDomain = [[presence from] domain];

    if (![presenceFromUser isEqualToString:myUsername]) {

        if ([presenceType isEqualToString:@"available"]) {

            [_chatDelegate newBuddyOnline:[NSString stringWithFormat:@"%@@%@", presenceFromUser, presenceFromDomain]];

        } else if ([presenceType isEqualToString:@"unavailable"]) {

            [_chatDelegate buddyWentOffline:[NSString stringWithFormat:@"%@@%@", presenceFromUser, presenceFromDomain]];
        }
    }
}

@end
