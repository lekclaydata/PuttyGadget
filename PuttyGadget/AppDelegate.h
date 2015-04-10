//
//  AppDelegate.h
//  PuttyGadget
//
//  Created by Joseph Gracé on 24/01/12.
//  Copyright (c) 2012 Claydata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPFramework.h"
#import "XMPPRoster.h"
#import "XMPP.h"
#import "XMPPReconnect.h"
#import "XMPPCapabilitiesCoreDataStorage.h"
#import "XMPPRosterCoreDataStorage.h"
#import "XMPPvCardAvatarModule.h"
#import "XMPPvCardCoreDataStorage.h"
#import "XMPPRosterMemoryStorage.h"

#import "DDLog.h"
#import "DDTTYLogger.h"
#import <CFNetwork/CFNetwork.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate,XMPPRosterDelegate,NSFetchedResultsControllerDelegate>
{
    __strong XMPPStream *xmppStream;
	__strong XMPPReconnect *xmppReconnect;
    __strong XMPPRoster *xmppRoster;
	__strong XMPPRosterCoreDataStorage *xmppRosterStorage;
    //__strong XMPPRosterMemoryStorage *xmppRosterStorage;
  
    __strong XMPPvCardCoreDataStorage *xmppvCardStorage;
	__strong XMPPvCardTempModule *xmppvCardTempModule;
	__strong XMPPvCardAvatarModule *xmppvCardAvatarModule;
	__strong XMPPCapabilities *xmppCapabilities;
	__strong XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;
    
    
    __strong NSFetchedResultsController * fetchedGroupResultsController;
    
    
	
	NSManagedObjectContext *managedObjectContext_roster;
	NSManagedObjectContext *managedObjectContext_capabilities;
	
	NSString *password;
	
	BOOL allowSelfSignedCertificates;
	BOOL allowSSLHostNameMismatch;
	
	BOOL isXmppConnected;


}

@property (strong, nonatomic) UIWindow *window;


//
@property (nonatomic, readonly) XMPPStream *xmppStream;
@property (nonatomic, readonly) XMPPReconnect *xmppReconnect;
@property (nonatomic, readonly) XMPPRoster *xmppRoster;
//@property (nonatomic, readonly) XMPPRosterMemoryStorage *xmppRosterStorage;
@property (nonatomic, readonly) XMPPRosterCoreDataStorage *xmppRosterStorage;
@property (nonatomic, readonly) XMPPvCardTempModule *xmppvCardTempModule;
@property (nonatomic, readonly) XMPPvCardAvatarModule *xmppvCardAvatarModule;
@property (nonatomic, readonly) XMPPCapabilities *xmppCapabilities;
@property (nonatomic, readonly) XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;


@property (nonatomic,strong) NSMutableDictionary *online_users;
@property (nonatomic,strong) NSMutableDictionary *offline_users;
@property (nonatomic,strong) NSArray *online_users_index;
@property (nonatomic,strong) NSArray *offline_users_index;
@property (nonatomic,strong) NSString *domain;
@property (nonatomic,strong) NSString *xmppUserName;
@property(nonatomic,strong) NSString *xmppPassword;

- (NSManagedObjectContext *)managedObjectContext_roster;
- (NSManagedObjectContext *)managedObjectContext_capabilities;

- (BOOL)connect:(NSString *)user pwd:(NSString *)pwd;
- (void)disconnect;
- (void)setupStream;
- (void)teardownStream;
-(BOOL)sendMessage:(NSString *)content To:(NSString *)to;


- (NSFetchedResultsController *)fetchedResultsController;

- (void)sortUserIndices;

-(BOOL) application:(UIApplication *)application handleOpenURL:(NSURL *) url;

@property BOOL rosterFetched;


//
@end
