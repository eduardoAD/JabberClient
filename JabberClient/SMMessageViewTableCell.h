//
//  SMMessageViewTableCell.h
//  JabberClient
//
//  Created by Eduardo Alvarado Díaz on 1/2/15.
//  Copyright (c) 2015 Organization. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMMessageViewTableCell : UITableViewCell

@property (nonatomic, strong) UILabel *senderAndTimeLabel;
@property (nonatomic, strong) UITextView *messageContentView;
@property (nonatomic, strong) UIImageView *bgImageView;

@end
