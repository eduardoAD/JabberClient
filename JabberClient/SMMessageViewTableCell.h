//
//  SMMessageViewTableCell.h
//  JabberClient
//
//  Created by Eduardo Alvarado Díaz on 1/2/15.
//  Copyright (c) 2015 Organization. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMMessageViewTableCell : UITableViewCell

@property (nonatomic, assign) UILabel *senderAndTimeLabel;
@property (nonatomic, assign) UITextView *messageContentView;
@property (nonatomic, assign) UIImageView *bgImageView;

@end
