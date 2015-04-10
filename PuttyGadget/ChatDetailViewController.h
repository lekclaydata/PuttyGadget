//
//  ChatDetailViewController.h
//  PuttyGadget
//
//  Created by Frank on 9/02/12.
//  Copyright (c) 2012 Claydata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserLoginViewController.h"

@interface ChatDetailViewController : UIViewController <UISplitViewControllerDelegate,UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@property (weak, nonatomic) IBOutlet UINavigationBar *NavigationBar;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *PopOverButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *ConnectButton;
- (IBAction)ConnectButtonClicked:(id)sender;
//-(void)GetPresence:(NSNotification *)notification;
@property (weak, nonatomic) IBOutlet UITextView *MessageTextField;
@property (weak, nonatomic) IBOutlet UIButton *MessageSendButton;
- (IBAction)MessageSendButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *MessageTableView;
//@property (weak, nonatomic) IBOutlet UINavigationBar *NavBar;
@property (weak, nonatomic) IBOutlet UINavigationItem *TitleBar;

- (NSString *)getCurrentTime;
-(void)ReceiveMessage:(NSNotification *)notification;


@property (strong,nonatomic) NSString *chatWithUser;
@property (strong,nonatomic) NSMutableArray *messages;

@property (weak, nonatomic) IBOutlet UIImageView *TestImage;

@property (strong,nonatomic) NSMutableDictionary *messageStore;
@property (strong,nonatomic) NSString  *currentContact;

-(void)changeContacts:(NSNotification *)notification ;
@property (weak, nonatomic) IBOutlet UIScrollView *ScrollView;
@property (weak,nonatomic) UITextField * activeField;

@property (strong,nonatomic) UserLoginViewController *userLoginViewController; 
@property (nonatomic,retain) UIPopoverController* userLoginPopOverController;


-(void)dismissLoginPopOver;
-(void)scrollToMessageTableButtom;
-(void)playMessageAlertSound;
-(void)initMessageStore;
-(void)dismissLoadingMask;


@end
