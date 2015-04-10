//
//  IphoneScannerViewController.m
//  PuttyGadget
//
//  Created by Joe Chang on 23/09/13.
//  Copyright (c) 2013 Claydata. All rights reserved.
//

#import "IphoneScannerViewController.h"
#import "DejalActivityView.h"
#import "IphonePhCardAssignController.h"



@implementation IphoneScannerViewController
@synthesize IphoneContentScrollView = _IphoneContentScrollView;
@synthesize IphoneSearchDisplayController = _IphoneSearchDisplayController;
@synthesize IphonePatientSearchBar = _IphonePatientSearchBar;
@synthesize IphoneResultImage = _IphoneResultImage;
@synthesize IphoneGoButton = _IphoneGoButton;
@synthesize IphoneScanResult = _IphoneScanResult;
@synthesize iphoneactiveField = _iphoneactiveField;
@synthesize iphonequeryResult = _iphonequeryResult;
@synthesize iphoneselectedPersonID = _iphoneselectedPersonID;
@synthesize iphoneselectedText = _iphoneselectedText;


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
    
     self.IphoneScanResult.delegate = self;
    [self setIphoneSearchDisplayController: _IphoneSearchDisplayController];
    
     //keyboards
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldDidBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:nil];
    //keboards
    
    self.iphonequeryResult = [[NSArray alloc]init];
    
}

- (void)viewDidUnload
{
    [self setIphoneResultImage:nil];
    [self setIphoneGoButton:nil];
    [self setIphoneScanResult:nil];
    [self setIphoneContentScrollView:nil];
    [self setIphoneSearchDisplayController:nil];
    [self setIphonePatientSearchBar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)IphoneScanButtonPressed:(id)sender {
    NSLog(@"Scan BTN Clicked");
    
    //ADD: present a barcode reader that scans from the camera feed
    
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    
    ZBarImageScanner *scanner = reader.scanner;
    // TODO: (optional) additional reader configuration here
    
    // EXAMPLE: disable rarely used I2/5 to improve performance
    
    [scanner setSymbology:ZBAR_I25 
                   config:ZBAR_CFG_ENABLE 
                       to:0];
    
    //present and release the controller
    [self presentModalViewController:reader animated:YES];
    
    NSLog(@"DONE");
    
}

- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    // ADD: get the decode results
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        // EXAMPLE: just grab the first barcode
        break;
    
    // EXAMPLE: do something useful with the barcode data
    self.IphoneScanResult.text = symbol.data;
    
    // EXAMPLE: do something useful with the barcode image
    self.IphoneResultImage.image =
    [info objectForKey: UIImagePickerControllerOriginalImage];
    
    // ADD: dismiss the controller (NB dismiss from the *reader*!)
    [reader dismissModalViewControllerAnimated: YES];
    
}


- (IBAction)IphoneGoButtonPressed:(id)sender {
    
    
    NSLog(@"ScanGoButtonPressed");
    NSLog(@"%@ %d %@",self.iphoneselectedPersonID,self.IphonePatientSearchBar.text.length,self.iphoneselectedText);
    
    if(self.iphoneselectedPersonID!=NULL&&self.IphonePatientSearchBar.text.length>0&&self.iphoneselectedText!=NULL)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ptSelected" object:self.iphoneselectedPersonID];
        
        [self.view removeFromSuperview];
        return;
    }
    
    //should get actual command from resuful
    NSString *query=[[NSString alloc]initWithFormat:@"d={\"func\":\"getQrCodeCommand\",\"param\":[\"%@\"]}",self.IphoneScanResult.text];
    
    PGRPCHelper *pg=[[PGRPCHelper alloc]init];
    [pg setDelegate:self];
    [pg getResponse:@"" withData:query];
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Loading..."];
    [DejalActivityView currentActivityView].showNetworkActivityIndicator = YES;
    
}

- (IBAction)IphoneGoToEnterpriseButtonClicked:(id)sender {
    
    NSLog(@"IphoneGoToEnterpriseButtonClick");
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"ptSelected" object:@"-1"];
    
    //terminate scanner view
    
    [self.view removeFromSuperview];
    
}

- (IBAction)IphoneFnishButtonClicked:(id)sender {
    
    [self.view removeFromSuperview];

}

- (void)handleExistingPatient:(NSNotification *)notification {
    
    NSString *pid = (NSString *)notification.object;
    NSLog(@"Scanner Controller Received Existing patient:%@",pid);
    self.IphoneScanResult.text = pid;
    
}

-(void)keyBoardWasShown:(NSNotification *)notification{
    
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey]CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.IphoneContentScrollView.contentInset = contentInsets;
    self.IphoneContentScrollView.scrollIndicatorInsets = contentInsets;
    
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, self.iphoneactiveField.frame.origin) ) {
        NSLog(@"Final Offset:%f %f",self.iphoneactiveField.frame.origin.y,kbSize.height);
        
        
        CGPoint scrollPoint = CGPointMake(0.0, self.iphoneactiveField.frame.origin.y-[[UIDevice currentDevice] orientation]!=UIInterfaceOrientationPortrait?kbSize.width:kbSize.height);
        [self.IphoneContentScrollView setContentOffset:scrollPoint animated:YES];        
        
    }
}

- (void)keyboardWillBeHidden:(NSNotification *)notification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.IphoneContentScrollView.contentInset = contentInsets;
    self.IphoneContentScrollView.scrollIndicatorInsets = contentInsets;
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.iphoneactiveField=textField;
    
}

- (IBAction)searchTextFiledDidChange:(id)sender {
    
    self.IphonePatientSearchBar.text = self.IphoneSearchTextField.text;
}


-(void)OnFinishReceiveJSONResponse: (NSObject *)result
{
    NSLog(@"Acutal command:%@",result);
    if([result isKindOfClass:[NSDictionary class]])
    {
        if([[result valueForKey:@"result"] isEqualToString:@"-3"])
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error " message:@"This QRCode have not been assigned to any patient!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: @"Assign Now",nil];
            [alert show];
            [DejalBezelActivityView removeViewAnimated:NO];
            return;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ptSelected" object:[result valueForKey:@"result"]];
        [DejalBezelActivityView removeViewAnimated:NO];
        
        [self.view removeFromSuperview];
    }
    else
    {
        self.iphonequeryResult=(NSArray*)result;
        [self.IphoneSearchDisplayController.searchResultsTableView reloadData];
    }
    
    //terminate scanner view
    
    
}




//add PG Healthcard

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"Click on index %d",buttonIndex);
    if(buttonIndex==1)
    {
        //assign now
        IphonePhCardAssignController *iphonephCardAssignController =[[IphonePhCardAssignController alloc]initWithNibName:@"IphonePhCardAssignController" bundle:[NSBundle mainBundle]];
        iphonephCardAssignController.view.frame=self.view.bounds;
        iphonephCardAssignController.view.autoresizingMask=UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        iphonephCardAssignController.IphoneResultImage.image=self.IphoneResultImage.image;
        iphonephCardAssignController.IphoneScanResult.text=self.IphoneScanResult.text;
        [iphonephCardAssignController.IphoneAssignButton setEnabled:YES];
        [iphonephCardAssignController.IphoneAssignButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [self addChildViewController:iphonephCardAssignController];
        [self.view addSubview:iphonephCardAssignController.view];
        return;
        
    }
}

//patientsearch
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"TOTAl:%d",self.iphonequeryResult.count);
    return self.iphonequeryResult.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier=@"Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        //cell.access=UITableViewCellAccessoryDisclosureIndicator
    }
    NSDictionary *row=[self.iphonequeryResult objectAtIndex:indexPath.row];
    cell.textLabel.text=[[NSString alloc]initWithFormat:@"%@ %@",[row valueForKey:@"first_name"],[row valueForKey:@"last_name"]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Select Row %d",indexPath.row);
    NSDictionary *row=[self.iphonequeryResult objectAtIndex:indexPath.row];
    self.iphoneselectedText=[[NSString alloc]initWithFormat:@"%@ %@",[row valueForKey:@"first_name"],[row valueForKey:@"last_name"]];
    
    self.IphonePatientSearchBar.text=self.iphoneselectedText;
    self.IphoneSearchTextField.text=self.iphoneselectedText;
    self.iphoneselectedPersonID=[row valueForKey:@"person_id"];
//    [self.IphoneSearchDisplayController setActive:NO];
    
}



-(BOOL)searchDisplayController:(UISearchDisplayController *)controller 
shouldReloadTableForSearchString:(NSString *)searchString
{
    //[self filterContentForSearchText:searchString];
    NSLog(@"shouldReloadTableForSearchString");
    if([searchString length]<3)return NO;
    
    if([searchString isEqualToString:self.iphoneselectedText])return NO;
    
    NSString *query=[[NSString alloc]initWithFormat:@"d={\"func\":\"searchPEPerson\",\"param\":[\"%@\"]}",searchString];
    
    PGRPCHelper *pg=[[PGRPCHelper alloc]init];
    [pg setDelegate:self];
    [pg getResponse:@"" withData:query];
    
    
    
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller 
shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    //[self filterContentForSearchText:[self.searchDisplayController.searchBar text]];
    NSLog(@"shouldReloadTableForSearchScope");
    return YES;
}



@end
