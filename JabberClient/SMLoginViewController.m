//
//  SMLoginViewController.m
//  JabberClient
//
//  Created by Eduardo Alvarado Díaz on 12/30/14.
//  Copyright (c) 2014 Organization. All rights reserved.
//

#import "SMLoginViewController.h"

@interface SMLoginViewController ()

@end

@implementation SMLoginViewController

@synthesize loginField, passwordField;

- (IBAction)login{
    [[NSUserDefaults standardUserDefaults] setObject:loginField.text forKey:@"userID"];
    [[NSUserDefaults standardUserDefaults] setObject:passwordField.text forKey:@"userPassword"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [self dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction) hideLogin{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

@end
