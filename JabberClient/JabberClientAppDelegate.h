//
//  JabberClientAppDelegate.h
//  JabberClient
//
//  Created by Eduardo Alvarado Díaz on 12/31/14.
//  Copyright (c) 2014 Organization. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMPP.h"

@class SMBuddyListViewController;

@interface JabberClientAppDelegate : NSObject

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet SMBuddyListViewController *viewController;
@property (nonatomic, readonly) XMPPStream *xmppStream;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, getter=isOpen) BOOL open;

@property (nonatomic, assign) id _chatDelegate;
@property (nonatomic, assign) id _messageDelegate;

- (BOOL)connect;
- (void)disconnect;

@end
