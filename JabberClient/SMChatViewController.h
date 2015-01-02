//
//  SMChatViewController.h
//  JabberClient
//
//  Created by Eduardo Alvarado Díaz on 12/31/14.
//  Copyright (c) 2014 Organization. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMMessageDelegate.h"
#import "JabberClientAppDelegate.h"
#import "XMPP.h"

@interface SMChatViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, SMMessageDelegate>

@property (nonatomic, retain) IBOutlet UITextField *messageField;
@property (nonatomic, retain) NSString *chatWithUser;
@property (nonatomic, retain) IBOutlet UITableView *tView;
@property (nonatomic, retain) NSMutableArray  *messages;
@property (strong, nonatomic) IBOutlet UINavigationItem *navItem;

- (id) initWithUser:(NSString *) userName;
- (IBAction)sendMessage;
- (IBAction)closeChat;

@end
