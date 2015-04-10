//
//  ChatMasterViewController.m
//  PuttyGadget
//
//  Created by Frank on 9/02/12.
//  Copyright (c) 2012 Claydata. All rights reserved.
//

#import "ChatMasterViewController.h"
#import "ContactTableCell.h"
#import <AddressBook/AddressBook.h>
#import <AddressBook/ABAddressBook.h>

@implementation ChatMasterViewController

@synthesize detailViewController = _detailViewController;
//@synthesize onlineUsers=_onlineUsers;
//@synthesize offlineUsers=_offlineUsers;
@synthesize phoneContacts=_phoneContacts;
@synthesize contactsMapping=_contactsMapping;
@synthesize phoneContactsIndices=_phoneContactsIndices;
@synthesize remainingPContactsIndices=_remainingPContactsIndices;
@synthesize pcUserSet=_pcUserSet;
@synthesize searchResult=_searchResult;


-(AppDelegate *)appDelegate
{
    
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)awakeFromNib
{
    self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    [super awakeFromNib];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    // self.detailViewController = (TDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    // [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(GetPresence:) name:@"getPresence" object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ReceiveMessage:) name:@"getMessage" object:nil];
    
    
  //  self.onlineUsers=[[NSMutableArray alloc]init];
   // self.offlineUsers=[[NSMutableArray alloc]init];
    
    
    self.phoneContacts=[[NSMutableDictionary alloc]init];
    self.contactsMapping=[[NSMutableDictionary alloc]init];
    self.phoneContactsIndices=[[NSArray alloc]init];
    self.remainingPContactsIndices=[[NSMutableArray alloc]init];
    self.pcUserSet=[[NSMutableSet alloc]init];
    self.searchResult=[[NSMutableArray alloc]init];
    
    [self loadAddressBookContacts];
    [self sortPhoneContactsIndices];
    [self genRemainingPContactsIndices];
    
    
    
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    
    [self genRemainingPContactsIndices];
    
    [self.tableView reloadData];
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source.
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]){
        return 1;
    }
    return 2;
   // return 1;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"numberOfRowsInSection");
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]){
        return [self.searchResult count];
    }
    if(section==0)
    {
        //return [self.onlineUsers count];
        
        //return [[[self appDelegate]online_users_index]count];
        return [self.phoneContactsIndices count];
    }
    else 
    {
        //return [self.offlineUsers count];
        //return [[[self appDelegate]offline_users_index]count];
        return [self.remainingPContactsIndices count];
    }   
    //
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSLog(@"titleForHeaderInSection");
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]){
        return @"Search Result";
    }
    if(section==0)
    {
        return @"Phone Contacts";
    }
    else 
    {
        return @"Remaining PuttyConnect Users";
    }
    ///////
    
    //return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
    static NSString *MyIdentifier = @"MyIdentifier";
    ContactTableCell *cell=[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if(cell==nil)
    {
        cell=[[ContactTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    }
    NSMutableDictionary *u;
    
    
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]){
        NSLog(@"Search Result %@ ROW:%d",[self.searchResult objectAtIndex:indexPath.row],indexPath.row);
        u=[self.phoneContacts objectForKey:[self.searchResult objectAtIndex:indexPath.row]];
        if(u!=NULL) 
        {
            if([u objectForKey:@"lastName"]!=NULL)cell.contactName.text= [[u objectForKey:@"firstName"] stringByAppendingString:[u objectForKey:@"lastName"] ];
            else cell.contactName.text= [u objectForKey:@"firstName"] ;
            
            
            NSUInteger status=[self isExistInRosterList:[self.searchResult objectAtIndex:indexPath.row]];
            
            if(status>0) 
            {
                //is a puttyconnect user
                if(status==2)cell.puttyMeStatus.image=[[UIImage imageNamed:@"PuttyMeUser.png"] stretchableImageWithLeftCapWidth:32  topCapHeight:32];
                else 
                {
                    //cell.contactName.text=@"123123123";
                    cell.puttyMeStatus.image=[[UIImage imageNamed:@"PuttyMeUser_offline.png"] stretchableImageWithLeftCapWidth:32  topCapHeight:32];
                }
            }
            else
                cell.puttyMeStatus.image=[[UIImage alloc]init];            
        }
        
        else
        {
            cell.puttyMeStatus.image=[[UIImage imageNamed:@"PuttyMeUser.png"] stretchableImageWithLeftCapWidth:32  topCapHeight:32];
            if(u==NULL) u=[[[self appDelegate]online_users] objectForKey:[self.searchResult objectAtIndex:indexPath.row] ];
            if(u==NULL) 
            {
                u=[[[self appDelegate]offline_users] objectForKey:[self.searchResult objectAtIndex:indexPath.row] ]; 
                cell.puttyMeStatus.image=[[UIImage imageNamed:@"PuttyMeUser_offline.png"] stretchableImageWithLeftCapWidth:32  topCapHeight:32];
            }
            cell.contactName.text= [u objectForKey:@"nickname"];
        }
       
        
        
    }
    
    else if(indexPath.section==0)
    {
       u=[self.phoneContacts objectForKey:[self.phoneContactsIndices objectAtIndex:indexPath.row]]; 
        NSUInteger status=[self isExistInRosterList:[self.phoneContactsIndices objectAtIndex:indexPath.row]];
        if(status>0) 
        {
            //is a puttyconnect user
            if(status==2)cell.puttyMeStatus.image=[[UIImage imageNamed:@"PuttyMeUser.png"] stretchableImageWithLeftCapWidth:32  topCapHeight:32];
            else cell.puttyMeStatus.image=[[UIImage imageNamed:@"PuttyMeUser_offline.png"] stretchableImageWithLeftCapWidth:32  topCapHeight:32];
            
            NSString *s=[self.phoneContactsIndices objectAtIndex:indexPath.row];
                              
            
            [self.pcUserSet removeObject:[s stringByAppendingString:@"puttyme.com"]];
        }
        else
        {
            cell.puttyMeStatus.image=[[UIImage alloc]init];
        }
        
        if([u objectForKey:@"lastName"]!=NULL)cell.contactName.text= [[u objectForKey:@"firstName"] stringByAppendingString:[u objectForKey:@"lastName"] ];
        else cell.contactName.text= [u objectForKey:@"firstName"] ;

        }
    else if(indexPath.section==1)
    {
       u=[[[self appDelegate]online_users] objectForKey:[self.remainingPContactsIndices objectAtIndex:indexPath.row] ];
   
       if(u==NULL)
       {
           u=[[[self appDelegate]offline_users] objectForKey:[self.remainingPContactsIndices objectAtIndex:indexPath.row] ];
           cell.puttyMeStatus.image=[[UIImage imageNamed:@"PuttyMeUser_offline.png"] stretchableImageWithLeftCapWidth:32  topCapHeight:32];
       }
        else
        {
             cell.puttyMeStatus.image=[[UIImage imageNamed:@"PuttyMeUser.png"] stretchableImageWithLeftCapWidth:32  topCapHeight:32];
        }
        
        NSLog(@"*****%@",[u objectForKey:@"nickname"]);
        cell.contactName.text= [u objectForKey:@"nickname"];
            
    }
    
    
    
   
    
    
    
    /*if(indexPath.section==0)
    {
        
        u=[[[self appDelegate]online_users] objectForKey:[[[self appDelegate]online_users_index] objectAtIndex:indexPath.row] ];
    }
    else
    {
        
        u=[[[self appDelegate]offline_users] objectForKey:[[[self appDelegate]offline_users_index] objectAtIndex:indexPath.row] ];
        
    }
    cell.contactName.text= [u objectForKey:@"nickname"];
    if([u objectForKey:@"photo"]!=NULL) cell.avanta.image=[u objectForKey:@"photo"];
    NSLog(@"PHOTO:%@",[u objectForKey:@"photo"]);
    */
   ///////////////////// 
   /* static NSString *MyIdentifier = @"MyIdentifier";
    ContactTableCell *cell=[tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if(cell==nil)
    {
        cell=[[ContactTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
    }
    NSMutableDictionary *u;

    u=[self.phoneContacts objectForKey:[self.phoneContactsIndices objectAtIndex:indexPath.row]];
    NSUInteger status=[self isExistInRosterList:[self.phoneContactsIndices objectAtIndex:indexPath.row]];
    if(status>0) 
    {
        cell.puttyMeStatus.image=[[UIImage imageNamed:@"PuttyMeUser.png"] stretchableImageWithLeftCapWidth:32  topCapHeight:32];
    }
    else
    {
        cell.puttyMeStatus.image=[[UIImage alloc]init];
    }
    NSLog(@"TABLE GET USER %@, status:%d",u,status);
    
    
    if([u objectForKey:@"lastName"]!=NULL)cell.contactName.text= [[u objectForKey:@"firstName"] stringByAppendingString:[u objectForKey:@"lastName"] ];
    else cell.contactName.text= [u objectForKey:@"firstName"] ;*/
    //if([u objectForKey:@"photo"]!=NULL) cell.avanta.image=[u objectForKey:@"photo"];
     //  NSLog(@"PHOTO:%@",[u objectForKey:@"photo"]);
    
    
    return cell;
    
}

-(void)GetPresence:(NSNotification *)notification {
    
    
    
    
   /*NSArray *content=(NSArray *)notification.object;
    NSLog(@"GetPresence: %@ ",content);
    NSString *status=[content objectAtIndex:1];
    if([status isEqualToString:@"available"])
    {
        [self.onlineUsers addObject:[content objectAtIndex:0]];
    }
    else
    {
        [self.offlineUsers addObject:[content objectAtIndex:0]];
        
    }
    [self.tableView reloadData];
    if([self.tableView indexPathForSelectedRow]==NULL)
    {
        NSIndexPath *indexPath;
        if([self.onlineUsers count]>0)
        {
            indexPath=[NSIndexPath indexPathForRow: 0  inSection: 0];
        }
        else
        {
            indexPath=[NSIndexPath indexPathForRow: 0  inSection: 1];
            
        }
        
        
        [self.tableView selectRowAtIndexPath:indexPath  animated:YES scrollPosition:UITableViewScrollPositionTop];
    }
    */
    [self.remainingPContactsIndices removeAllObjects];
    [self genRemainingPContactsIndices];
    [self.tableView reloadData];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *selectedJidString;
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]){
        
       selectedJidString=[self.searchResult objectAtIndex:indexPath.row];
       if([selectedJidString rangeOfString:@"@"].location==NSNotFound)
       {
           [selectedJidString stringByAppendingString:[self appDelegate].domain];
       }
        
    }
    else
    {
        NSArray *selectedIndex=(indexPath.section==0)?self.phoneContactsIndices:self.remainingPContactsIndices;
    
        selectedJidString=[selectedIndex objectAtIndex:indexPath.row];
    
        if(indexPath.section==0)selectedJidString=[selectedJidString stringByAppendingString:[self appDelegate].domain];
    
        
    }
    
    NSLog(@"select contact JID: %@",selectedJidString);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeContacts" object:selectedJidString];
    
    
   /* NSArray *selectedIndex=(indexPath.section==0)?[[self appDelegate]online_users_index]:[[self appDelegate]offline_users_index];
      
    NSLog(@"select contact JID: %@",[selectedIndex objectAtIndex:indexPath.row]);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeContacts" object:[selectedIndex objectAtIndex:indexPath.row]];*/
    
    
    
    //////
    /*
    NSUInteger status=[self isExistInRosterList:[self.phoneContactsIndices objectAtIndex:indexPath.row]];

    
    NSLog(@"PRESSED: status:%d    %@ %@",status,[self.phoneContactsIndices objectAtIndex:indexPath.row],[self.phoneContacts objectForKey:[self.phoneContactsIndices objectAtIndex:indexPath.row]]);
    
    if(status>0)
    {
        NSString *jidString=[[self.phoneContactsIndices objectAtIndex:indexPath.row]stringByAppendingString:@"@puttyme.com"];
        NSLog(@"JIDString:%@",jidString);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeContacts" object:jidString];
    
    }*/
    
}




- (void)loadAddressBookContacts
{
    ABAddressBookRef addressBook = ABAddressBookCreate();
    NSArray *people = (__bridge NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
    for (int i=0 ; i < [people count];i++) {
        ABRecordRef ref = (__bridge ABRecordRef)[people objectAtIndex:i];
        CFStringRef firstName=ABRecordCopyValue(ref, kABPersonFirstNameProperty); 
        CFStringRef lastName=ABRecordCopyValue(ref, kABPersonLastNameProperty);
        ABMultiValueRef phones=ABRecordCopyValue(ref, kABPersonPhoneProperty);
        
        if(firstName==NULL && lastName==NULL) continue;
        
        NSArray *phoneArray = (__bridge NSArray *)ABMultiValueCopyArrayOfAllValues(phones);
        
        NSLog(@"Address Book: %@ %@ %@",firstName,lastName,phoneArray);
        
        NSMutableDictionary *item=[[NSMutableDictionary alloc]init];
        if(firstName!=NULL)[item setObject:(__bridge NSString *) firstName  forKey:@"firstName"];
        if(lastName!=NULL)[item setObject:(__bridge NSString *) lastName  forKey:@"lastName"];
        
        NSString *mobileKey=@"";
        
        //////
        NSUInteger len=0;
        
        for(int j=0;j<[phoneArray count];j++)
        {
            //get phone number
            NSString *num=[phoneArray objectAtIndex:j];
            num=[num stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSLog(@"NUMNUM:%@",num);
            
            if([num length]==10)  //for aus
            {
                mobileKey=num;
                break;
            }
            
            if(len==0)
            {
                len=[num length];
                mobileKey=num;
            }
            
            else 
            {
                if([num length]>len)
                {
                    mobileKey=num;
                    len=[num length];
                }
            }
            
        }
        //////
        
        if(![mobileKey isEqualToString:@""])
        {
            [self.phoneContacts setObject:item forKey:mobileKey];
        }
        
        
    }
    
    self.phoneContactsIndices=[self.phoneContacts allKeys];
    
    NSLog(@"PhoneContacts: %@",self.phoneContacts);
    
}

-(void)sortPhoneContactsIndices
{
    self.phoneContactsIndices=[self.phoneContactsIndices sortedArrayUsingComparator:^NSComparisonResult(id obj1,id obj2)
   {
       NSString *a=[[self.phoneContacts objectForKey:obj1]objectForKey:@"firstName"];
       NSString *b=[[self.phoneContacts objectForKey:obj2]objectForKey:@"firstName"];
       
       //    NSLog(@"A: %@ B: %@",a,b);
       return [a compare:b];
       
   }];
    
}

-(void)buildContactsMapping
{
    /*for(int i=0;i< [self.phoneContactsIndices count];i++)
     {
     NSString *key=[self.phoneContactsIndices objectAtIndex:i];
     key=[key stringByAppendingString:@"@puttyme.com"];
     if([[[self appDelegate]online_users] objectForKey:key]!=NULL )
     {}
     }*/
    
}

-(NSUInteger)isExistInRosterList:(NSString *)targetPhoneContact
{
    NSString *key=[targetPhoneContact stringByAppendingString:@"@puttyme.com"];
    if([[[self appDelegate] online_users]objectForKey:key]!=NULL)
    {
        return 2;  //online
    }
    else if([[[self appDelegate] offline_users]objectForKey:key]!=NULL)
    {
        return 1;  //offline
    }
    else
        return 0;  //does not exist
    
}

-(NSUInteger)isExistInPhoneContact:(NSString *)target
{
    for(int i=0;i<[self.phoneContactsIndices count];i++)
    {
        NSString *phoneNum=[self.phoneContactsIndices objectAtIndex:i];
        
        if([target rangeOfString:phoneNum].location!=NSNotFound)
        {
            return 1;
        }
    }
    return 0;


}

/**
 Generate remainingContacts Section Indices
 */

-(void)genRemainingPContactsIndices
{
    
    
    /*for(int i=0;i<[[[self appDelegate]online_users_index]count];i++)
    {
        
        [self.pcUserSet addObject:[[[self appDelegate]online_users_index] objectAtIndex:i]];
    
    }
    
    for(int i=0;i<[[[self appDelegate]offline_users_index]count];i++)
    {
        
        [self.pcUserSet addObject:[[[self appDelegate]offline_users_index] objectAtIndex:i]];
        
    }*/
    
    for(int i=0;i<[[[self appDelegate]online_users_index]count];i++)
    {
       // NSLog(@"ONONON:%@",[[[self appDelegate]online_users_index]objectAtIndex:i]);
        if([self isExistInPhoneContact:[[[self appDelegate]online_users_index]objectAtIndex:i]]==0)
        {
            [self.remainingPContactsIndices addObject:[[[self appDelegate]online_users_index]objectAtIndex:i]];
            NSMutableDictionary *temp=[[[self appDelegate]online_users]objectForKey:[[[self appDelegate]online_users_index]objectAtIndex:i]];
            [temp setObject:@"1" forKey:@"section"];
       //     NSLog(@"PPPP");
        }
        else 
        {
            NSMutableDictionary *temp=[[[self appDelegate]online_users]objectForKey:[[[self appDelegate]online_users_index]objectAtIndex:i]];
            [temp setObject:@"0" forKey:@"section"];
        }
       // NSLog(@"QQQQ");
    }
    
    for(int i=0;i<[[[self appDelegate]offline_users_index]count];i++)
    {
       //  NSLog(@"OFOFOFOF:%@",[[[self appDelegate]offline_users_index]objectAtIndex:i]);
        if([self isExistInPhoneContact:[[[self appDelegate]offline_users_index]objectAtIndex:i]]==0)
        {
            [self.remainingPContactsIndices addObject:[[[self appDelegate]offline_users_index]objectAtIndex:i]];
            NSMutableDictionary *temp=[[[self appDelegate]offline_users]objectForKey:[[[self appDelegate]offline_users_index]objectAtIndex:i]];
            [temp setObject:@"1" forKey:@"section"];
       //      NSLog(@"PPPP11");
        }
        else
        {
            NSMutableDictionary *temp=[[[self appDelegate]offline_users]objectForKey:[[[self appDelegate]offline_users_index]objectAtIndex:i]];
            [temp setObject:@"0" forKey:@"section"];
        }
       // NSLog(@"QQQQ111");

    }
    
    NSLog(@"Remaining Users:%@",[self remainingPContactsIndices]);
    
        
    
    
    
    
    

}


-(NSIndexPath *)getContactIndexPath:(NSString *)searchKey
{
    //search key is jidStr
    NSInteger row=-1;
    NSInteger section;
    NSArray *index;
    NSMutableDictionary *temp=[[[self appDelegate]online_users]objectForKey:searchKey];
    if(temp!=NULL)
    {
        index=[[self appDelegate]online_users_index];
        section=[[temp objectForKey:@"section"]intValue];
    }
    else
    {
        index=[[self appDelegate]offline_users_index];
        temp=[[[self appDelegate]offline_users]objectForKey:searchKey];
        section=[[temp objectForKey:@"section"]intValue];

    }
    
    if(section==0)
    {
        for(int i=0;i<[self.phoneContactsIndices count];i++)
       {
           NSString *item=[self.phoneContactsIndices objectAtIndex:i];
           if([searchKey rangeOfString:item].location!=NSNotFound)
           {
               row=i;
               break;
           }
    
       }
    }
    else
    {
        for(int i=0;i<[index count];i++)
       {
            NSString *item=[index objectAtIndex:i];
            if([item rangeOfString:searchKey].location!=NSNotFound)
           {
               row=i;
               break;
           }
      }
    }
    
    NSLog(@"getContactIndexPath Row: %d Section: %d",row,section);
    
    return [NSIndexPath indexPathForRow:row inSection:section];


}

-(void)ReceiveMessage:(NSNotification *)notification
{
    NSMutableDictionary *content=(NSMutableDictionary *)notification.object;
    if(content !=nil)
    {
        NSString *sender=[content objectForKey:@"sender"];
        [self.tableView selectRowAtIndexPath:[self getContactIndexPath:sender] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeContacts" object:sender];
    }
}


//search related


- (void)filterContentForSearchText:(NSString*)searchText 
                             
{
   /* NSPredicate *resultPredicate = [NSPredicate 
                                    predicateWithFormat:@"SELF contains[cd] %@",
                                    searchText];*/
    [self.searchResult removeAllObjects];
    searchText=[searchText lowercaseString];
    for(int i=0;i<[self.phoneContactsIndices count];i++)
    {
        NSString *searchTarget=@"";
        if([[self.phoneContacts objectForKey:[self.phoneContactsIndices objectAtIndex:i]]objectForKey:@"firstName"]!=NULL)
        {
            searchTarget=[[self.phoneContacts objectForKey:[self.phoneContactsIndices objectAtIndex:i]]objectForKey:@"firstName"];
        }
        if([[self.phoneContacts objectForKey:[self.phoneContactsIndices objectAtIndex:i]]objectForKey:@"lastName"]!=NULL)
        {
            searchTarget=[searchTarget stringByAppendingString:[[self.phoneContacts objectForKey:[self.phoneContactsIndices objectAtIndex:i]]objectForKey:@"lastName"]];
        }
        
        searchTarget=[searchTarget lowercaseString];
                
        //NSLog(@"Search target phone contacts:%@",searchTarget);
        if([searchTarget rangeOfString:searchText].location!=NSNotFound)
        {
            [self.searchResult addObject:[self.phoneContactsIndices objectAtIndex:i]];
        }
    }
    
    for(int i=0;i<[self.remainingPContactsIndices count];i++)
    {
        NSMutableDictionary *target=[[[self appDelegate]online_users]objectForKey:[self.remainingPContactsIndices objectAtIndex:i]];
        if(target==NULL) target=[[[self appDelegate]offline_users]objectForKey:[self.remainingPContactsIndices objectAtIndex:i]];
        
        NSString *searchTarget=[target objectForKey:@"nickname"];
        //NSLog(@"Search Target RemainingPG: %@",searchTarget);
        searchTarget=[searchTarget lowercaseString];
        if([searchTarget rangeOfString:searchText].location!=NSNotFound)
        {
            [self.searchResult addObject:[self.remainingPContactsIndices objectAtIndex:i]];
        }
        
    }
    
    NSLog(@"Search: %@ Result Array: %@",searchText,self.searchResult);
    
}


-(BOOL)searchDisplayController:(UISearchDisplayController *)controller 
shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString];
    NSLog(@"shouldReloadTableForSearchString");
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller 
shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text]];
    NSLog(@"shouldReloadTableForSearchScope");
    return YES;
}


//search Related





@end


