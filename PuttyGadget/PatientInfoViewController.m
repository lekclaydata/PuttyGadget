//
//  PatientInfoViewController.m
//  PuttyGadget
//
//  Created by Frank on 30/01/12.
//  Copyright (c) 2012 Claydata. All rights reserved.
//

#import "PatientInfoViewController.h"

@implementation PatientInfoViewController
@synthesize personTitle=_personTitle;
@synthesize firstName=_firstName;
@synthesize lastName=_lastName;
@synthesize dob=_dob;
@synthesize gender=_gender;
@synthesize email=_email;
@synthesize mobile=_mobile;
@synthesize PatientImage = _PatientImage;
@synthesize ReleasePatientButton;

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
    NSLog(@"PTINFO loaded");
}

- (void)viewDidUnload
{
    [self setReleasePatientButton:nil];
    [self setTitle:nil];
    [self setFirstName:nil];
    [self setLastName:nil];
    [self setDob:nil];
    [self setGender:nil];
    [self setEmail:nil];
    [self setMobile:nil];
    [self setPersonTitle:nil];
    [self setPatientImage:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    NSLog(@"PTinfo Released");
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (IBAction)ReleasePatientButtonClicked:(id)sender {
    
    NSLog(@"ReleasePatientButtonClicked");
    // [self pres
    //[self removeFromParentViewController];
}

- (IBAction)CloseCurrentPatientButtonClicked:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ptClosed" object:NULL];

    
}

-(void) updatePatientDetails:(NSDictionary *)details
{
    
    //NSLog(@"UPDATE PT DETAILS: %@,%@,%@",[details valueForKey:@"persontitle"],[details valueForKey:@"first_name"],[details valueForKey:@"last_name"]);
   
    [self.personTitle setText:[[NSString alloc]initWithFormat:@"%@",[details valueForKey:@"persontitle"]]];
    [self.firstName setText:[[NSString alloc]initWithFormat:@"%@",[details valueForKey:@"first_name"]]];
    [[self firstName]setText:[[NSString alloc]initWithFormat:@"%@",[details valueForKey:@"first_name"]]];
    [[self lastName]setText:[[NSString alloc]initWithFormat:@"%@",[details valueForKey:@"last_name"]]];
    [[self dob]setText:[[NSString alloc]initWithFormat:@"%@",[details valueForKey:@"dob"]]];
    [[self gender]setText:[[NSString alloc]initWithFormat:@"%@",[details valueForKey:@"gender"]]];
    [[self email]setText:[[NSString alloc]initWithFormat:@"%@",[details valueForKey:@"email"]]];
    [[self mobile]setText:[[NSString alloc]initWithFormat:@"%@",[details objectForKey:@"mobile_phone"]]];
    
    if([details valueForKey:@"ctphoto"]!=NULL&&[[details valueForKey:@"ctphoto"] length]>0)
    {
    
        //image
        NSString *u=[[NSString alloc]initWithFormat:@"http://test.claydata.com/profiles/%@/100/%@",[details valueForKey:@"person_id"],[details valueForKey:@"ctphoto"]];
        NSLog(@"PatientPhoto Url: %@",u);
        NSURL *url=[NSURL URLWithString:u];
        NSData *data=[NSData dataWithContentsOfURL:url];
        self.PatientImage.image=[UIImage imageWithData:data];
    }
    else
    {
        self.PatientImage.image=[[UIImage imageNamed:@"person_unknown.png"] stretchableImageWithLeftCapWidth:150  topCapHeight:150];
    }
    
    
    
}
@end
