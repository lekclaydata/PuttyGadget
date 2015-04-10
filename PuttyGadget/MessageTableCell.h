//
//  MessageTableCell.h
//  Chat_Test
//
//  Created by Frank on 5/02/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageTableCell : UITableViewCell
{
    
    UILabel *senderAndTimeLabel;
    UITextView *messageControlView;
    UIImageView *bgImageView;
        
}

@property (nonatomic,strong) UILabel *senderAndTimeLabel;
@property (nonatomic,strong) UITextView *messageContentView;
@property (nonatomic,strong) UIImageView *bgImageView;

/*- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier text:(NSString *)text imageName:(NSString *)imageName origin:(CGRect)origin messageSize:(CGSize)messageSize message:(NSString *)message;*/


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
