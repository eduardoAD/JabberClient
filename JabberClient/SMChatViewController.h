//
//  SMChatViewController.h
//  JabberClient
//
//  Created by Eduardo Alvarado Díaz on 12/31/14.
//  Copyright (c) 2014 Organization. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMChatViewController : UIViewController

@property (nonatomic, retain) IBOutlet UITextField *messageField;
@property (nonatomic, retain) NSString *chatWithUser;
@property (nonatomic, retain) IBOutlet UITableView *tView;
@property (nonatomic, retain) NSMutableArray  *messages;

//- (id) initWithUser:(NSString *) userName;
- (IBAction)sendMessage;
- (IBAction)closeChat;

@end
