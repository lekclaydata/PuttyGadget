//
//  ChatMasterViewController.h
//  PuttyGadget
//
//  Created by Frank on 9/02/12.
//  Copyright (c) 2012 Claydata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatDetailViewController.h"
#import "AppDelegate.h"

@interface ChatMasterViewController : UITableViewController <UITableViewDelegate>

@property (strong, nonatomic) ChatDetailViewController *detailViewController;
//@property (strong,nonatomic)  NSMutableArray *onlineUsers;
//@property (strong,nonatomic)  NSMutableArray *offlineUsers;  
@property (strong, nonatomic) NSMutableDictionary *phoneContacts;
@property (strong,nonatomic) NSMutableDictionary *contactsMapping;
@property (strong,nonatomic) NSArray *phoneContactsIndices;

@property (strong,nonatomic) NSMutableArray *remainingPContactsIndices;

@property (strong,nonatomic)NSMutableSet *pcUserSet;

@property (strong,nonatomic)NSMutableArray *searchResult;



- (void)loadAddressBookContacts;
-(void)sortPhoneContactsIndices;
-(void)buildContactsMapping;
-(NSUInteger)isExistInRosterList:(NSString *)targetPhoneContact;
-(NSUInteger)isExistInPhoneContact:(NSString *)target;

-(void)genRemainingPContactsIndices;

-(void)ReceiveMessage:(NSNotification *)notification;

-(NSIndexPath *)getContactIndexPath:(NSString *)searchKey;

@end
