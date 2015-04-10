//
//  ScannerViewController.m
//  PuttyGadget
//
//  Created by Frank on 29/01/12.
//  Copyright (c) 2012 Claydata. All rights reserved.
//

#import "ScannerViewController.h"
#import "DejalActivityView.h"
#import "PhCardAssignController.h"

@implementation ScannerViewController
@synthesize ContentScrollView = _ContentScrollView;
@synthesize ResultImage=_ResultImage;
@synthesize GoButton = _GoButton;
@synthesize ScanResult=_ScanResult;
@synthesize activeField=_activeField;
@synthesize SearchDisplayController = _SearchDisplayController;
@synthesize PatientSearchBar = _PatientSearchBar;
@synthesize queryResult=_queryResult;
@synthesize selectedPersonID=_selectedPersonID;
@synthesize selectedText=_selectedText;
//@synthesize ScanGoButton;

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
    
    self.ScanResult.delegate=self;
    
    self.view.autoresizesSubviews = YES;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self setSearchDisplayController:_SearchDisplayController];
    //keyboards
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidBeginEditing:) name:UITextFieldTextDidBeginEditingNotification object:nil];
    //keyboards
    
    self.queryResult=[[NSArray alloc]init];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleExistingPatient:) name:@"existingPatient" object:nil];
    
}


- (void)viewDidUnload
{
    [self setResultImage:nil];
    [self setScanResult:nil];
//    [self setScanGoButton:nil];
    [self setContentScrollView:nil];
    [self setGoButton:nil];
    [self setSearchDisplayController:nil];
    [self setPatientSearchBar:nil];
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


- (IBAction)ScanButtonPressed:(id)sender {
    
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
    
    //[reader release]; 
    
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
    self.ScanResult.text = symbol.data;
    
    // EXAMPLE: do something useful with the barcode image
    self.ResultImage.image =
    [info objectForKey: UIImagePickerControllerOriginalImage];
    
    // ADD: dismiss the controller (NB dismiss from the *reader*!)
    [reader dismissModalViewControllerAnimated: YES];
    
    
     
    
    
    
}
- (IBAction)ScanGoButtonPressed:(id)sender {
         
    
    NSLog(@"ScanGoButtonPressed");
    NSLog(@"%@ %d %@",self.selectedPersonID,self.PatientSearchBar.text.length,self.selectedText);
    
    if(self.selectedPersonID!=NULL&&self.PatientSearchBar.text.length>0&&self.selectedText!=NULL)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ptSelected" object:self.selectedPersonID];
        
        [self.view removeFromSuperview];
        return;
    }
    
    //should get actual command from resuful
    NSString *query=[[NSString alloc]initWithFormat:@"d={\"func\":\"getQrCodeCommand\",\"param\":[\"%@\"]}",self.ScanResult.text];
    
    PGRPCHelper *pg=[[PGRPCHelper alloc]init];
    [pg setDelegate:self];
    [pg getResponse:@"" withData:query];
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Loading..."];
    [DejalActivityView currentActivityView].showNetworkActivityIndicator = YES;
    
   
    
   
    
}

- (IBAction)GoToEnterpriseButtonClicked:(id)sender {

    NSLog(@"GoToEnterpriseButtonClick");
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ptSelected" object:@"-1"];
    
    //terminate scanner view
    
    [self.view removeFromSuperview];

}

- (IBAction)FnishButtonClicked:(id)sender {
    
    [self.view removeFromSuperview];

}

- (void)handleExistingPatient:(NSNotification *)notification {
    
    NSString *pid=(NSString *)notification.object;
    NSLog(@"Scanner Controller Received Existing Patient:%@",pid);
    self.ScanResult.text=pid;
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.activeField=textField;
    
}



- (IBAction)SeachTextFieldChanged:(id)sender {
    
   
    self.PatientSearchBar.text = self.SearchTextField.text;
   
}


- (void)keyBoardWasShown:(NSNotification *)notification {
 
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.ContentScrollView.contentInset = contentInsets;
    self.ContentScrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, self.activeField.frame.origin) ) {
        NSLog(@"Final Offset:%f %f",self.activeField.frame.origin.y,kbSize.height);
        
        
        CGPoint scrollPoint = CGPointMake(0.0, self.activeField.frame.origin.y-[[UIDevice currentDevice] orientation]!=UIInterfaceOrientationPortrait?kbSize.width:kbSize.height);
        [self.ContentScrollView setContentOffset:scrollPoint animated:YES];
    }     
}
- (void)keyboardWillBeHidden:(NSNotification *)notification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.ContentScrollView.contentInset = contentInsets;
    self.ContentScrollView.scrollIndicatorInsets = contentInsets;
    
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
        self.queryResult=(NSArray*)result;
        [self.SearchDisplayController.searchResultsTableView reloadData];
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
        PhCardAssignController *phCardAssignController =[[PhCardAssignController alloc]initWithNibName:@"PhCardAssignController" bundle:[NSBundle mainBundle]];
        phCardAssignController.view.frame=self.view.bounds;
        phCardAssignController.view.autoresizingMask=UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        phCardAssignController.ResultImage.image=self.ResultImage.image;
        phCardAssignController.ScanResult.text=self.ScanResult.text;
        [phCardAssignController.AssignButton setEnabled:YES];
        [phCardAssignController.AssignButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [self addChildViewController:phCardAssignController];
        [self.view addSubview:phCardAssignController.view];
        return;
        
    }
}

//patientsearch
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"TOTAl:%d",self.queryResult.count);
    return self.queryResult.count;
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
    NSDictionary *row=[self.queryResult objectAtIndex:indexPath.row];
    cell.textLabel.text=[[NSString alloc]initWithFormat:@"%@ %@",[row valueForKey:@"first_name"],[row valueForKey:@"last_name"]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Select Row %d",indexPath.row);
    NSDictionary *row=[self.queryResult objectAtIndex:indexPath.row];
    self.selectedText=[[NSString alloc]initWithFormat:@"%@ %@",[row valueForKey:@"first_name"],[row valueForKey:@"last_name"]];
    self.PatientSearchBar.text=self.selectedText;
    self.SearchTextField.text=self.selectedText;
    self.selectedPersonID=[row valueForKey:@"person_id"];
    
//    [self setSearchDisplayController:nil];
    
}



-(BOOL)searchDisplayController:(UISearchDisplayController *)controller 
shouldReloadTableForSearchString:(NSString *)searchString
{
    //[self filterContentForSearchText:searchString];
    NSLog(@"shouldReloadTableForSearchString");
    if([searchString length]<3)return NO;
    
    if([searchString isEqualToString:self.selectedText])return NO;
    
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
