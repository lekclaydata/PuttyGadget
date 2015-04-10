//
//  PhCardAssignController.m
//  PuttyGadget
//
//  Created by Frank An on 23/05/12.
//  Copyright (c) 2012 Claydata. All rights reserved.
//

#import "PhCardAssignController.h"

@implementation PhCardAssignController
@synthesize PatientSearchDisplayController = _PatientSearchDisplayController;
@synthesize PatientSearchBar;
@synthesize queryResult;
@synthesize selectedPersonID;
@synthesize AssignButton;
@synthesize ScanResult;
@synthesize ResultImage;
@synthesize AlterCardButton;
@synthesize DeallocateButton;
@synthesize ScrollView;
@synthesize activeField=_activeField;

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:nil];
    
    
    [self resetData];
    [self setPatientSearchDisplayController:_PatientSearchDisplayController];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setPatientSearchDisplayController:nil];
    [self setPatientSearchBar:nil];
    [self setAssignButton:nil];
    [self setScanResult:nil];
    [self setResultImage:nil];
    [self setAlterCardButton:nil];
    [self setDeallocateButton:nil];
    [self setScrollView:nil];
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
	return YES;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return queryResult.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier=@"Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil)
    {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        //cell.access=UITableViewCellAccessoryDisclosureIndicator
    }
    NSDictionary *row=[queryResult objectAtIndex:indexPath.row];
    cell.textLabel.text=[[NSString alloc]initWithFormat:@"%@ %@",[row valueForKey:@"first_name"],[row valueForKey:@"last_name"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Select Row %d",indexPath.row);
    NSDictionary *row=[queryResult objectAtIndex:indexPath.row];
    self.PatientSearchBar.text=[[NSString alloc]initWithFormat:@"%@ %@",[row valueForKey:@"first_name"],[row valueForKey:@"last_name"]];
    
    self.SearchTextField.text=self.PatientSearchBar.text;
    self.selectedPersonID=[row valueForKey:@"person_id"];
    [self setPatientSearchDisplayController:nil];
//    [self.searchDisplayController setActive:NO];
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

- (void)OnFinishReceiveJSONResponse: (NSObject *)result
{
    NSLog(@"OnFinishReceiveJSONResponse AssignCard Result %@",result);
    if([result isKindOfClass:[NSDictionary class]])
    {
       // [reader dismissModalViewControllerAnimated: YES];
        NSString *s=[result valueForKey:@"func"];
        if([s isEqualToString:@"getQrCodeCommand"])
        {
            if([[result valueForKey:@"result"]isEqualToString:@"-3"])
            {
                    //do nothing
                [self.AssignButton setEnabled:YES];
                [self.AssignButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                [self.AlterCardButton setEnabled:NO];
                [self.AlterCardButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                [self.DeallocateButton setEnabled:NO];
                [self.DeallocateButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            }
            else
            {
                self.selectedPersonID=[result valueForKey:@"result"];
                self.PatientSearchBar.text=[result valueForKey:@"pName"];
                NSLog(@"TTTTT%@ %@",[result valueForKey:@"result"],[result valueForKey:@"pName"]);
                [self.AssignButton setEnabled:NO];
                [self.AssignButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                [self.AlterCardButton setEnabled:YES];
                [self.AlterCardButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                [self.DeallocateButton setEnabled:YES];
                [self.DeallocateButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                [self.searchDisplayController setActive:NO];
            }
        }
        else
        {
            //add more for error handling
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Success " message:@"The request has been complete successfully!" delegate:NULL cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            [self resetData];
            return;
        }
    }
    else
    {
        self.queryResult=(NSArray *)result;
        [self.searchDisplayController.searchResultsTableView reloadData];
    }
}


- (IBAction)AssignButtonClicked:(id)sender {
    
    if(self.selectedPersonID==NULL)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Missing Patient " message:@"Please select a patient first!" delegate:NULL cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    NSString *query=[[NSString alloc]initWithFormat:@"d={\"func\":\"assignQrCode\",\"param\":[\"%@\",\"%@\",\"%d\"]}",ScanResult.text,self.selectedPersonID,0];
    
    PGRPCHelper *pg=[[PGRPCHelper alloc]init];
    [pg setDelegate:self];
    [pg getResponse:@"" withData:query];
    
}



- (IBAction)ScanButtonClicked:(id)sender {
    
    NSLog(@"Scan BTN Clicked");
    
    // ADD: present a barcode reader that scans from the camera feed
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

- (IBAction)AlterCardButtonClicked:(id)sender {
    
    NSString *query=[[NSString alloc]initWithFormat:@"d={\"func\":\"alterQrCode\",\"param\":[\"%@\",\"%@\",\"%d\"]}",ScanResult.text,self.selectedPersonID,0];
    
    PGRPCHelper *pg=[[PGRPCHelper alloc]init];
    [pg setDelegate:self];
    [pg getResponse:@"" withData:query];
}

- (IBAction)DeallocateButtonClicked:(id)sender {
    
    NSString *query=[[NSString alloc]initWithFormat:@"d={\"func\":\"deallocQrCode\",\"param\":[\"%@\",\"%@\",\"%d\"]}",ScanResult.text,self.selectedPersonID,0];
    
    PGRPCHelper *pg=[[PGRPCHelper alloc]init];
    [pg setDelegate:self];
    [pg getResponse:@"" withData:query];
}

- (IBAction)FinishButtonClicked:(id)sender {
    
    [self.view removeFromSuperview];
}

- (IBAction)TextDidChange:(id)sender {
    
    self.PatientSearchBar.text = self.SearchTextField.text;
}

- (void) resetData
{
    self.selectedPersonID=NULL;
    self.ScanResult.text=@"";
    self.ResultImage.image=nil;
    self.PatientSearchBar.text=@"";
    [self.AssignButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.DeallocateButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.AlterCardButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    [self.AssignButton setEnabled:NO];
    [self.DeallocateButton setEnabled:NO];
    [self.AlterCardButton setEnabled:NO];

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
    self.ScanResult.text = symbol.data;
    
    
    NSString *query=[[NSString alloc]initWithFormat:@"d={\"func\":\"getQrCodeCommand\",\"param\":[\"%@\"]}",self.ScanResult.text];
    
    
    
    // EXAMPLE: do something useful with the barcode image
    self.ResultImage.image =
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
    self.ScrollView.contentInset = contentInsets;
    self.ScrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, self.activeField.frame.origin) ) {
        NSLog(@"Final Offset:%f %f",self.activeField.frame.origin.y,kbSize.height);
        
        
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
    NSLog(@"SetActiveField");
    self.activeField=textField;
    
}

//keyboard


@end
