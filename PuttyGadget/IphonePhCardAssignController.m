//
//  IphonePhCardAssignController.m
//  PuttyGadget
//
//  Created by Joe Chang on 24/09/13.
//  Copyright (c) 2013 Claydata. All rights reserved.
//

#import "IphonePhCardAssignController.h"

@implementation IphonePhCardAssignController
@synthesize IphonePatientSearchBar;
@synthesize IphoneScanResult;
@synthesize IphoneResultImage;
@synthesize IphoneAssignButton;
@synthesize IphoneAlterButton;
@synthesize IphoneDeallocateButton;
@synthesize IphoneScrollView;
@synthesize IphonePatientSearchDisplayController;
@synthesize iphonequeryResult;
@synthesize iphoneselectedPersonID;
@synthesize iphoneactiveField = _iphoneactiveField;

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
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillBeHidden) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldDidBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:nil];
    
    [self resetData];
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setIphonePatientSearchDisplayController:nil];
    [self setIphoneScanResult:nil];
    [self setIphoneResultImage:nil];
    [self setIphoneAssignButton:nil];
    [self setIphoneAlterButton:nil];
    [self setIphoneDeallocateButton:nil];
    [self setIphoneScrollView:nil];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return iphonequeryResult.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        //cell.access=UITableViewCellAccessoryDisclosureIndicator
    }
    NSDictionary *row = [iphonequeryResult objectAtIndex:indexPath.row];
    cell.textLabel.text=[[NSString alloc]initWithFormat:@"%@ %@", [row valueForKey:@"first_name"], [row valueForKey:@"last_name"]];
    return cell;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller 
shouldReloadTableForSearchString:(NSString *)searchString
{
    //[self filterContentForSearchText:searchString];
    NSLog(@"shouldReloadTableForSearchString");
    if([searchString length]<3)return NO;
    
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Select Row %d",indexPath.row);
    NSDictionary *row =[iphonequeryResult objectAtIndex:indexPath.row];
    self.IphonePatientSearchBar.text=[[NSString alloc]initWithFormat:@"%@ %@", [row valueForKey:@"first_name"], [row valueForKey:@"last_name"]];
    self.iphoneselectedPersonID = [row valueForKey:@"person_id"];
    [self.searchDisplayController setActive:NO];
}

- (void)OnFinishReceiveJSONResponse:(NSDictionary *)result{
    
    NSLog(@"OnFinishReceiveJSONResponseAssignCard Result %@",result);
    if([result isKindOfClass:[NSDictionary class]]){
          // [reader dismissModalViewControllerAnimated: YES];
        NSString *s = [result valueForKey:@"func"];
        if([s isEqualToString:@"getQrCodeCommand"]){
            if ([[result valueForKey:@"result"]isEqualToString:@"-3"]) {
                //do nothing
                [self.IphoneAssignButton setEnabled:YES];
                [self.IphoneAssignButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                [self.IphoneAlterButton setEnabled:NO];
                [self.IphoneAlterButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                [self.IphoneDeallocateButton setEnabled:NO];
                [self.IphoneDeallocateButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            }
            else
            {
                self.iphoneselectedPersonID = [result valueForKey:@"result"];
                self.IphonePatientSearchBar.text=[result valueForKey:@"pName"];
                NSLog(@"TTTTT%@ %@", [result valueForKey:@"pName"]);
                [self.IphoneAssignButton setEnabled:NO];
                [self.IphoneAssignButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                [self.IphoneAlterButton setEnabled:YES];
                [self.IphoneAlterButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                [self.IphoneDeallocateButton setEnabled:YES];
                [self.IphoneDeallocateButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                [self.searchDisplayController setActive:NO];
            }
        }
        else
        {
            //add more for error handling
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Success" message:@"The request has been complete successfully!" delegate:NULL cancelButtonTitle:@"OK"otherButtonTitles:nil];
            [alert show];
            [self resetData];
            return;
        }
        
    }
    else
    {
        self.iphonequeryResult = (NSArray *)result;
        [self.searchDisplayController.searchResultsTableView reloadData];
    }
    
}

- (IBAction)IphoneSearchTextDidChange:(id)sender {
}

- (IBAction)IphoneScanButtonClicked:(id)sender {
    
    NSLog(@"Scan BTN Clicked");
    
    
    //ADD :present a barcode reader that scans from the camera feed
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    
    ZBarImageScanner *scanner = reader.scanner;
    
    // TODO: (optional) additional reader configuration here
    
    // EXAMPLE: disable rarely used I2/5 to improve performance
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    
    // present and release the controller
    [self presentModalViewController: reader
                            animated: YES];
    
    NSLog(@"DONE");
    
}

- (IBAction)IphoneAssignButtonClicked:(id)sender {
    
    if (self.iphoneselectedPersonID == NULL) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Missing Patient" message:@"please select a patient first!" delegate:NULL cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    NSString *query=[[NSString alloc]initWithFormat:@"d={\"func\":\"assignQrCode\",\"param\":[\"%@\",\"%@\",\"%d\"]}",IphoneScanResult.text,self.iphoneselectedPersonID,0];
    
    PGRPCHelper *pg=[[PGRPCHelper alloc]init];
    [pg setDelegate:self];
    [pg getResponse:@"" withData:query];

}

- (IBAction)IphoneAlertButtonClicked:(id)sender {
    
    NSString *query=[[NSString alloc]initWithFormat:@"d={\"func\":\"alterQrCode\",\"param\":[\"%@\",\"%@\",\"%d\"]}",IphoneScanResult.text,self.iphoneselectedPersonID,0];
    
    PGRPCHelper *pg=[[PGRPCHelper alloc]init];
    [pg setDelegate:self];
    [pg getResponse:@"" withData:query];
    
}

- (IBAction)IphoneDeallocateButtonClicked:(id)sender {
    
    NSString *query=[[NSString alloc]initWithFormat:@"d={\"func\":\"alterQrCode\",\"param\":[\"%@\",\"%@\",\"%d\"]}",IphoneScanResult.text,self.iphoneselectedPersonID,0];
    
    PGRPCHelper *pg=[[PGRPCHelper alloc]init];
    [pg setDelegate:self];
    [pg getResponse:@"" withData:query];
    
}

- (IBAction)IphoneFinishButtonClicked:(id)sender {
    
    [self.view removeFromSuperview];
}

- (void) resetData
{
    self.iphoneselectedPersonID = NULL;
    self.IphoneScanResult.text = @"";
    self.IphoneResultImage.image = nil;
    self.IphonePatientSearchBar.text = @"";
    [self.IphoneAssignButton setEnabled:NO];
    [self.IphoneAlterButton setEnabled:NO];
    [self.IphoneDeallocateButton setEnabled:NO];
    
    [self.IphoneAssignButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.IphoneAlterButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.IphoneDeallocateButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
}

- (void) imagePickerController:(UIImagePickerController *) reader didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    
    // ADD: get the decode results
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        // EXAMPLE: just grab the first barcode
        break;
    
    // EXAMPLE: do something useful with the barcode data
    self.IphoneScanResult.text = symbol.data;
    
    
    NSString *query=[[NSString alloc]initWithFormat:@"d={\"func\":\"getQrCodeCommand\",\"param\":[\"%@\"]}",self.IphoneScanResult.text];
    
    
    
    // EXAMPLE: do something useful with the barcode image
    self.IphoneResultImage.image =
    [info objectForKey: UIImagePickerControllerOriginalImage];
    
    // ADD: dismiss the controller (NB dismiss from the *reader*!)
    [reader dismissModalViewControllerAnimated: NO];
    [NSThread sleepForTimeInterval:.5];
    
    
    PGRPCHelper *pg=[[PGRPCHelper alloc]init];
    [pg setDelegate:self];
    [pg getResponse:@"" withData:query];
    

    
}

//keyboard
- (void)keyBoardWasShown:(NSNotification *)notification {
    
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.IphoneScrollView.contentInset = contentInsets;
    self.IphoneScrollView   .scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, self.iphoneactiveField.frame.origin) ) {
        NSLog(@"Final Offset:%f %f",self.iphoneactiveField.frame.origin.y,kbSize.height);
        
        
        CGPoint scrollPoint = CGPointMake(0.0, self.iphoneactiveField.frame.origin.y-[[UIDevice currentDevice] orientation]!=UIInterfaceOrientationPortrait?kbSize.width:kbSize.height);
        [self.IphoneScrollView setContentOffset:scrollPoint animated:YES];
    }    
    
}
- (void)keyboardWillBeHidden:(NSNotification *)notification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.IphoneScrollView.contentInset = contentInsets;
    self.IphoneScrollView.scrollIndicatorInsets = contentInsets;
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"SetActiveField");
    self.iphoneactiveField=textField;
    
}

//keyboard


@end
