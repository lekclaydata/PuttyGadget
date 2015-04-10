//
//  MessageTableCell.m
//  Chat_Test
//
//  Created by Frank on 5/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MessageTableCell.h"

@implementation MessageTableCell

@synthesize senderAndTimeLabel=_senderAndTimeLabel;
@synthesize messageContentView=_messageContentView;
@synthesize bgImageView=_bgImageView;

//static CGFloat padding = 20.0;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    
    
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
		self.senderAndTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 5, 300, 20)];
		self.senderAndTimeLabel.textAlignment = UITextAlignmentCenter;
		self.senderAndTimeLabel.font = [UIFont systemFontOfSize:11.0];
		self.senderAndTimeLabel.textColor = [UIColor lightGrayColor];
		[self.contentView addSubview:self.senderAndTimeLabel];
		
		self.bgImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
		[self.contentView addSubview:self.bgImageView];
		
		self.messageContentView = [[UITextView alloc] init];
		self.messageContentView.backgroundColor = [UIColor clearColor];
		self.messageContentView.editable = NO;
		self.messageContentView.scrollEnabled = NO;
		[self.messageContentView sizeToFit];
		[self.contentView addSubview:self.messageContentView];
        
    }
	
    return self;
    
    
    
	/*if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
		self.senderAndTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300, 20)];
		self.senderAndTimeLabel.textAlignment = UITextAlignmentCenter;
		self.senderAndTimeLabel.font = [UIFont systemFontOfSize:12.0];
		self.senderAndTimeLabel.textColor = [UIColor lightGrayColor];
		[self.contentView addSubview:senderAndTimeLabel];
		
		if([imageName isEqualToString:@"orange.png"])
        {
            bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 30, 88, 36)];
        }
        else
        {
            bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(490, 30, 88, 36)];
        }
       
        bgImageView.image=[UIImage imageNamed:imageName];
        
		[self.contentView addSubview:bgImageView];

		NSLog(@"SIZE: %f  %f",messageSize.height,messageSize.width);
        
		self.messageContentView = [[UITextView alloc] initWithFrame:CGRectMake(25,35, 120, 200)];
		self.messageContentView.backgroundColor = [UIColor clearColor];
		self.messageContentView.editable = NO;
		self.messageContentView.scrollEnabled = NO;
        self.messageContentView.text=message;
        [self.messageContentView setFont:[UIFont fontWithName:@"ArialMT" size:17]];
        
		[self.messageContentView sizeToFit];
		[self.contentView addSubview:self.messageContentView];
        
        
        [bgImageView setFrame:CGRectMake(self.messageContentView.frame.origin.x - padding/2, 
                                         self.messageContentView.frame.origin.y - padding/2, 
                                         messageSize.width+padding, 
                                         messageSize.height+padding)];
        
        
        self.accessoryType = UITableViewCellAccessoryNone;
        self.userInteractionEnabled = NO;
    }
	
    return self;*/
	
}

@end


