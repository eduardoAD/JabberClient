//
//  SMLoginViewController.h
//  JabberClient
//
//  Created by Eduardo Alvarado Díaz on 12/30/14.
//  Copyright (c) 2014 Organization. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMLoginViewController : UIViewController

@property (nonatomic, retain) IBOutlet UITextField *loginField;
@property (nonatomic, retain) IBOutlet UITextField *passwordField;

-(IBAction) login;
-(IBAction) hideLogin;

@end
