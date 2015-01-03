//
//  SMMessageViewTableCell.m
//  JabberClient
//
//  Created by Eduardo Alvarado Díaz on 1/2/15.
//  Copyright (c) 2015 Organization. All rights reserved.
//

#import "SMMessageViewTableCell.h"

@implementation SMMessageViewTableCell

@synthesize senderAndTimeLabel, messageContentView, bgImageView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        senderAndTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300, 20)];
        senderAndTimeLabel.textAlignment = NSTextAlignmentCenter;
        senderAndTimeLabel.font = [UIFont systemFontOfSize:11.0];
        senderAndTimeLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:senderAndTimeLabel];

        bgImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:bgImageView];

        messageContentView = [[UITextView alloc] init];
        messageContentView.backgroundColor = [UIColor clearColor];
        messageContentView.editable = NO;
        messageContentView.scrollEnabled = NO;
        [messageContentView sizeToFit];
        [self.contentView addSubview:messageContentView];
    }
    return  self;
}

@end
