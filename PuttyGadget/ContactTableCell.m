//
//  ContactTableCell.m
//  PuttyGadget
//
//  Created by Frank on 15/02/12.
//  Copyright (c) 2012 Claydata. All rights reserved.
//

#import "ContactTableCell.h"

@implementation ContactTableCell

@synthesize avanta=_avanta;
@synthesize puttyEnterpriseStatus=_puttyEnterpriseStatus;
@synthesize onlineStatus=_onlineStatus;
@synthesize contactName=_contentName;
@synthesize puttyMeStatus=_puttyMeStatus;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.avanta=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 32, 32)];
        self.avanta.image=[[UIImage imageNamed:@"man.png"] stretchableImageWithLeftCapWidth:32  topCapHeight:32];
        [self.contentView addSubview:self.avanta];
        
        self.contactName=[[UILabel alloc]initWithFrame:CGRectMake(50, 10, 120, 32)];
        self.contactName.font=[UIFont systemFontOfSize:12.0];
        [self.contentView addSubview:self.contactName];
        
        //self.puttyEnterpriseStatus=[[UIImageView alloc]initWithFrame:CGRectMake(180, 10, 32, 32)];
        
        self.puttyMeStatus=[[UIImageView alloc]initWithFrame:CGRectMake(180, 10, 32, 32)];
        [self.contentView addSubview:self.puttyMeStatus];
        
        self.onlineStatus=[[UIImageView alloc]initWithFrame:CGRectMake(222, 10, 32, 32)];
        [self.contentView addSubview:self.onlineStatus];
    
                          
                          
        
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
