//
//  UserLoginViewController.m
//  PuttyGadget
//
//  Created by Joseph Gracé on 10/02/12.
//  Copyright (c) 2012 Claydata. All rights reserved.
//

#import "UserLoginViewController.h"

@implementation UserLoginViewController
@synthesize UserNameTextField;
@synthesize PasswordTextField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setUserNameTextField:nil];
    [self setPasswordTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (IBAction)LoginButtonClicked:(id)sender {
    
    [[self appDelegate] setupStream];
    if([[self appDelegate] connect:self.UserNameTextField.text pwd:self.PasswordTextField.text])
     {
     //self.ConnectButton.title=@"Disconnect";
         [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissLoginPopover" object:nil];
     NSLog(@"Connect Success!!");
     }
    
}

-(AppDelegate *)appDelegate
{
    
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}
@end
