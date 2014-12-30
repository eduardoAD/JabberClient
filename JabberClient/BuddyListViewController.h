//
//  ViewController.h
//  JabberClient
//
//  Created by Eduardo Alvarado Díaz on 12/30/14.
//  Copyright (c) 2014 Organization. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BuddyListViewController : UIViewController

@property (nonatomic, retain) IBOutlet UITableView *tView;
@property NSMutableArray *onlineBuddies;

- (IBAction) showLogin;

@end

