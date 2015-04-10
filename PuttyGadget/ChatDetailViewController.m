//
//  ChatDetailViewController.m
//  PuttyGadget
//
//  Created by Frank on 9/02/12.
//  Copyright (c) 2012 Claydata. All rights reserved.
//

#import "ChatDetailViewController.h"
#import "XMPPFramework.h"
#import "DDLog.h"
#import "AppDelegate.h"
#import "MessageTableCell.h"
#import <AudioToolbox/AudioToolbox.h>
#import "DejalActivityView.h"


@interface ChatDetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation ChatDetailViewController
@synthesize TitleBar = _TitleBar;
@synthesize ScrollView = _ScrollView;


@synthesize MessageTableView = _MessageTableView;
@synthesize MessageTextField = _MessageTextField;
@synthesize MessageSendButton = _MessageSendButton;
@synthesize detailItem = _detailItem;
@synthesize detailDescriptionLabel = _detailDescriptionLabel;
@synthesize NavigationBar = _NavigationBar;
@synthesize PopOverButton = _PopOverButton;
@synthesize ConnectButton = _ConnectButton;
@synthesize masterPopoverController = _masterPopoverController;
@synthesize messages=_messages;
@synthesize TestImage = _TestImage;
@synthesize chatWithUser=_chatWithUser;
@synthesize messageStore=_messageStore;
@synthesize currentContact=_currentContact;
@synthesize activeField=_activeField;
@synthesize userLoginViewController=_userLoginViewController;
@synthesize userLoginPopOverController=_userLoginPopOverController;




-(AppDelegate *)appDelegate
{
    
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
    
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.
    
    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
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
    
   // self.MessageTextField.delegate=self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initMessageStore) name:@"getPresence" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ReceiveMessage:) name:@"getMessage" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeContacts:) name:@"changeContacts" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissLoginPopOver) name:@"dismissLoginPopover" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissLoadingMask) name:@"connectSuccess" object:nil];
    
    
    [self configureView];
    self.splitViewController.delegate =self;
    self.messageStore=[[NSMutableDictionary alloc]init];
    //self.messages=[[NSMutableArray alloc]init];
    //self.MessageTableView=[[UITableView alloc]init];
    [self.MessageTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.MessageTableView.delegate=self;
    self.MessageTableView.dataSource=self;
    
    
    self.TitleBar.leftBarButtonItem=self.PopOverButton;
    

    
    
}

-(void)initMessageStore
{
    /*for(NSString *i in [[self appDelegate]online_users_index])
    {
        if([self.messageStore objectForKey:i]==NULL)
            {
                [self.messageStore setObject:[[NSMutableArray alloc]init] forKey:i];
            
            }
    
    }
    
    for(NSString *i in [[self appDelegate]offline_users_index])
    {
        if([self.messageStore objectForKey:i]==NULL)
        {
            [self.messageStore setObject:[[NSMutableArray alloc]init] forKey:i];
            
        }
        
    }*/
    for(NSString *i in [[self appDelegate]online_users_index])
    {
        if([self.messageStore objectForKey:i]==NULL)
        {
            [self.messageStore setObject:[[NSMutableArray alloc]init] forKey:i];
            
        }
        
    }
    
    for(NSString *i in [[self appDelegate]offline_users_index])
    {
        if([self.messageStore objectForKey:i]==NULL)
        {
            [self.messageStore setObject:[[NSMutableArray alloc]init] forKey:i];
            
        }
        
    }
}

-(void)changeContacts:(NSNotification *)notification {
    
    
    
    NSString *content=(NSString *)notification.object;
    
    if(self.currentContact!=NULL)
    {
        [self.messageStore setObject:self.messages forKey:self.currentContact];
    }
    
    NSMutableArray *message=[self.messageStore objectForKey:content];
    
    
    
    if(message!=NULL)
    {
        
        self.messages=message;
        
        
    }
    else
    {
        message=[[NSMutableArray alloc]init];
        self.messages=message;
        
    }
    self.currentContact=content;
    [self.MessageTableView reloadData];
    
    for(NSMutableDictionary *d in self.messages )
    {
        NSLog(@"MSG: %@",[d objectForKey:@"msg"]);
    }
    
    [self scrollToMessageTableButtom];
}

- (void)viewDidUnload
{
    [self setPopOverButton:nil];
    [self setConnectButton:nil];
    [self setMessageTextField:nil];
    [self setMessageSendButton:nil];
    [self setMessageTableView:nil];
    [self setTestImage:nil];
    [self setScrollView:nil];
    [self setTitleBar:nil];
    [self setNavigationBar:nil];
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

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
   // UINavigationItem *navi=[[UINavigationItem alloc]initWithTitle:@"ttttt1"];
  //  [navi setLeftBarButtonItem:barButtonItem animated:YES];
  //  [self.NavigationBar pushNavigationItem:navi animated:YES];
  //   self.masterPopoverController = popoverController;
    //self.masterPopoverController 
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
   // self.NavigationBar.title = NSLocalizedString(@"Master1", @"Master1");
  //  [self.NavigationBar popNavigationItemAnimated:YES];
   // [self.navigationItem setLeftBarButtonItem:nil animated:YES];
  //   self.masterPopoverController = nil;
}

- (IBAction)ConnectButtonClicked:(id)sender {
    
    if([self.ConnectButton.title isEqualToString:@"Connect"])
    {
        
        [[self appDelegate] setupStream];
        if([[self appDelegate] connect:@"0433971223" pwd:@"clay2899"])
        {
            [DejalBezelActivityView activityViewForView:self.splitViewController.view withLabel:@"Connecting..."];
            self.ConnectButton.title=@"Disconnect";
            NSLog(@"Connect Success!!");
        }
    }
    else
    {
        [[self appDelegate] teardownStream];
        
        self.ConnectButton.title=@"Connect";
    }
    
    
   /* if(![self.userLoginPopOverController isPopoverVisible]){
        // Popover is not visible
        
        self.userLoginViewController = [[UserLoginViewController alloc] initWithNibName:@"UserLoginViewController" bundle:nil];
        self.userLoginPopOverController = [[UIPopoverController alloc] initWithContentViewController:self.userLoginViewController];
        [self.userLoginPopOverController setPopoverContentSize:CGSizeMake(363.0f, 287.0f)];
        [self.userLoginPopOverController presentPopoverFromBarButtonItem:(UIBarButtonItem *)sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }else{
        [self.userLoginPopOverController dismissPopoverAnimated:YES];
        
    }*/
    
   
    
}

-(void)dismissLoadingMask
{
    [DejalBezelActivityView removeViewAnimated:YES];

}


-(void)dismissLoginPopOver
{
       [self.userLoginPopOverController dismissPopoverAnimated:YES];
}

- (IBAction)MessageSendButtonClicked:(id)sender {
    
    NSString *receiver=self.currentContact;
    [[self appDelegate]sendMessage:self.MessageTextField.text To:receiver];
    if([self.MessageTextField.text length]>0)
    {
        NSMutableDictionary *m = [[NSMutableDictionary alloc] init];
        
		[m setObject:self.MessageTextField.text forKey:@"msg"];
		[m setObject:@"you" forKey:@"sender"];
		[m setObject:[self getCurrentTime] forKey:@"time"];
        [self.messages addObject:m];
        [self.MessageTableView reloadData];
        
    }
    
    [self scrollToMessageTableButtom];
    [self.MessageTextField resignFirstResponder];
    
    NSLog(@"TABITEM %@",self.tabBarItem);
    [self.tabBarItem setBadgeValue:@"1"] ;
    
    
    
}

- (NSString *)getCurrentTime
{
    NSDateFormatter *formatter;
    NSString        *dateString;
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy HH:mm"];
    
    dateString = [formatter stringFromDate:[NSDate date]];
    return dateString;
    
}

///table view  
static CGFloat padding = 20.0;

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}




-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.messages count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSDictionary *dict = (NSDictionary *)[self.messages objectAtIndex:indexPath.row];
	NSString *msg = [dict objectForKey:@"msg"];
	
	CGSize  textSize = { 260.0, 10000.0 };
	CGSize size = [msg sizeWithFont:[UIFont boldSystemFontOfSize:13]
				  constrainedToSize:textSize 
					  lineBreakMode:UILineBreakModeWordWrap];
	
	size.height += padding*2;
	
	CGFloat height = size.height < 80 ? 80 : size.height;
	return height;
	
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	
	NSDictionary *s = (NSDictionary *) [self.messages objectAtIndex:indexPath.row];
	
	static NSString *CellIdentifier = @"MessageCellIdentifier";
	
	MessageTableCell *cell = (MessageTableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
		cell = [[MessageTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
    
	NSString *sender = [s objectForKey:@"sender"];
	NSString *message = [s objectForKey:@"msg"];
	NSString *time = [s objectForKey:@"time"];
	if(time==NULL) time=[self getCurrentTime];
	CGSize  textSize = { 260.0, 10000.0 };
	CGSize size = [message sizeWithFont:[UIFont boldSystemFontOfSize:13]
					  constrainedToSize:textSize 
						  lineBreakMode:UILineBreakModeWordWrap];
    
	
	size.width += (padding/2);
	
	
	cell.messageContentView.text = message;
	cell.accessoryType = UITableViewCellAccessoryNone;
	cell.userInteractionEnabled = NO;
	
    
	UIImage *bgImage = nil;
	
    
	if ([sender isEqualToString:@"you"]) { // left aligned
        
		bgImage = [[UIImage imageNamed:@"orange.png"] stretchableImageWithLeftCapWidth:24  topCapHeight:15];
		
		[cell.messageContentView setFrame:CGRectMake(padding, padding*2, size.width, size.height)];
		
		[cell.bgImageView setFrame:CGRectMake( cell.messageContentView.frame.origin.x - padding/2, 
											  cell.messageContentView.frame.origin.y - padding/2, 
											  size.width+padding, 
											  size.height+padding)];
        
        NSLog(@"ImageSize: %f   %f  %f %f  ",cell.messageContentView.frame.origin.x - padding/2, 
              cell.messageContentView.frame.origin.y - padding/2, 
              size.width+padding, 
              size.height+padding);
        
	} else {
        
		bgImage = [[UIImage imageNamed:@"aqua.png"] stretchableImageWithLeftCapWidth:24  topCapHeight:15];
		
		[cell.messageContentView setFrame:CGRectMake(700 - size.width - padding, 
													 padding*2, 
													 size.width, 
													 size.height)];
		
		[cell.bgImageView setFrame:CGRectMake(cell.messageContentView.frame.origin.x - padding/2, 
											  cell.messageContentView.frame.origin.y - padding/2, 
											  size.width+padding, 
											  size.height+padding)];
		
	}
	
	cell.bgImageView.image = bgImage;
    NSLog(@"CellText:%@",cell.messageContentView.text);
	cell.senderAndTimeLabel.text = [NSString stringWithFormat:@"%@ %@", sender, time];
	
	return cell;
	
}






-(void)ReceiveMessage:(NSNotification *)notification {
    
    NSMutableDictionary *content=(NSMutableDictionary *)notification.object;
    if(content !=nil)
    {
        NSString *sender=[content objectForKey:@"sender"];
        
        if([sender isEqualToString:self.currentContact])
        {
            [self.messages addObject:content];
        }
        else
        {
            [[self.messageStore objectForKey:sender] addObject:content];
        }
        [self.MessageTableView reloadData];
        [self playMessageAlertSound];
        
    }
    
    [self scrollToMessageTableButtom];
    
}

-(void)playMessageAlertSound
{
   
    
    //NSString *path = [[NSBundle bundleWithIdentifier:@"com.apple.UIKit"] pathForResource:@"Tock" ofType:@"aiff"];
    NSString *path=[[NSBundle mainBundle] pathForResource:@"alert1" ofType:@"caf"];
    SystemSoundID soundID;
    OSStatus error=AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &soundID);
    NSLog(@"SOUND ERROR:%@",error);
    AudioServicesPlaySystemSound(soundID);
   // AudioServicesDisposeSystemSoundID(soundID);

}

-(void)scrollToMessageTableButtom
{
    if([self.messages count]>0)
    {
        NSIndexPath *p=[NSIndexPath indexPathForRow:[self.messages count]-1 inSection:0];
        [self.MessageTableView scrollToRowAtIndexPath:p atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }

}


//keyboard
- (void)keyBoardWasShown:(NSNotification *)notification {
    
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.ScrollView.contentInset = contentInsets;
    self.ScrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, self.activeField.frame.origin) ) {
        //NSLog(@"Final Offset:%f %f",self.activeField.frame.origin.y,kbSize.height);
        
        
        CGPoint scrollPoint = CGPointMake(0.0, self.activeField.frame.origin.y-[[UIDevice currentDevice] orientation]!=UIInterfaceOrientationPortrait?kbSize.width:kbSize.height);
        [self.ScrollView setContentOffset:scrollPoint animated:YES];
    }    

    
}
- (void)keyboardWillBeHidden:(NSNotification *)notification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.ScrollView.contentInset = contentInsets;
    self.ScrollView.scrollIndicatorInsets = contentInsets;
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.activeField=textField;
    
}




//keyboard



@end

