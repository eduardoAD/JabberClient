//
//  ViewController.h
//  JabberClient
//
//  Created by Eduardo Alvarado Díaz on 12/30/14.
//  Copyright (c) 2014 Organization. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JabberClientAppDelegate.h"
#import "SMLoginViewController.h"
#import "SMChatViewController.h"
#import "SMChatDelegate.h"


@interface SMBuddyListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, SMChatDelegate>

@property (nonatomic, retain) IBOutlet UITableView *tView;
@property (nonatomic, retain) IBOutlet UIView *addBuddyView;
@property (nonatomic, retain) IBOutlet UITextField *buddyField;

@property NSMutableArray *onlineBuddies;

- (IBAction) showLogin;
- (IBAction)addBuddy;

@end

