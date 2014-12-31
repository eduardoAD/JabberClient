//
//  SMMessageDelegate.h
//  JabberClient
//
//  Created by Eduardo Alvarado Díaz on 12/31/14.
//  Copyright (c) 2014 Organization. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SMMessageDelegate

- (void)newMessageReceived:(NSDictionary *)messageContent;

@end