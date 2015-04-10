//
//  ContactTableCell.h
//  PuttyGadget
//
//  Created by Frank on 15/02/12.
//  Copyright (c) 2012 Claydata. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactTableCell : UITableViewCell

@property (strong,nonatomic) UIImageView * avanta;
@property (strong,nonatomic) UILabel *contactName;
@property (strong,nonatomic) UIImageView * puttyMeStatus;
@property (strong,nonatomic) UIImageView * puttyEnterpriseStatus;
@property (strong,nonatomic) UIImageView * onlineStatus;

@end
