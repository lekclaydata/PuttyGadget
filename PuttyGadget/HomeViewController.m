//
//  HomeViewController.m
//  PuttyGadget
//
//  Created by Joseph Gracé on 24/01/12.
//  Copyright (c) 2012 Claydata. All rights reserved.
//

#import "HomeViewController.h"
#import "AQGridView.h"
#import "SpringBoardIconCell.h"
#import "PGRPCHelper.h"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)


@implementation HomeViewController

@synthesize scannerViewController=_scannerViewController;
@synthesize iphonescannerViewController=_iphonescannerViewController;
@synthesize currentSelectedIndex=_currentSelectedIndex;

@synthesize TitleButton = _TitleButton;

@synthesize patientInfoPopOverController=_patientInfoPopOverController;
@synthesize patientInfoView=_patientInfoView;
@synthesize currentSelectedPatientID=_currentSelectedPatientID;
@synthesize pg=_pg;
@synthesize patientDetails=_patientDetails;
@synthesize modalLoginView=_modalLoginView;
@synthesize iphonemodalLoginView=_iphonemodalLoginView;
@synthesize loginData=_loginData;
@synthesize loginButton = _loginButton;
@synthesize wvp=_wvp;
@synthesize iwvp=_iwvp;
//@synthesize uploadeCabinetController=_uploadeCabinetController;
@synthesize phCardAssignController=_phCardAssignController;
@synthesize iphonephCardAssignController=_iphonephCardAssignController;


-(AppDelegate *)appDelegate
{
    
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

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
    NSLog(@"GETIN");
    self.currentSelectedPatientID=nil;
    self.tabBarController.delegate=self;
    
    //[self.TitleButton setEnabled:false];

    // Do any additional setup after loading the view from its nib.
 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlePtSelected:) name:@"ptSelected" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlePtClosed:) name:@"ptClosed" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleLoginSuccess:) name:@"ls" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleLoginFail:) name:@"lf" object:nil];


    
    
    _emptyCellIndex =NSNotFound;
    
   
    self.view.autoresizesSubviews=YES;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    _gridView=[[AQGridView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, 43, self.view.bounds.size.width, self.view.bounds.size.height)];
    NSLog(@"Bounds: %f %f",self.view.bounds.origin.x,self.view.bounds.origin.y);
    
    //_gridView=[[[AQGridView alloc] initWithFrame: ];
    
    _gridView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    _gridView.backgroundColor = [UIColor clearColor];
    _gridView.opaque = NO;
    _gridView.dataSource = self;
    _gridView.delegate = self;
    _gridView.scrollEnabled = YES;
    _gridView.contentSizeGrowsToFillBounds=YES;
    //_gridView.pagingEnabled=YES;
   // _gridView.
    

    if ( UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation]) )
    {
        // bring 1024 in to 1020 to make a width divisible by five
        _gridView.leftContentInset = 2.0;
        _gridView.rightContentInset = 2.0;
    }
    [self.view insertSubview:_gridView atIndex:0];
   // [self.view addSubview: _gridView];
    
    
    
    if ( _icons == nil )
    {
        _icons = [[NSMutableArray alloc] initWithCapacity: 15];
        UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(0.0, 0.0, 72.0, 72.0)
                                                         cornerRadius: 18.0];
        
        CGFloat saturation = 0.6, brightness = 0.7;
        for ( NSUInteger i = 1; i <= 23; i++ )
        {
            UIColor * color = [UIColor colorWithHue: (CGFloat)i/20.0
                                         saturation: saturation
                                         brightness: brightness
                                              alpha: 1.0];
            
            UIGraphicsBeginImageContext( CGSizeMake(72.0, 72.0) );
            
            // clear background
            [[UIColor clearColor] set];
            UIRectFill( CGRectMake(0.0, 0.0, 72.0, 72.0) );
            
            // fill the rounded rectangle
            [color set];
            [path fill];
            
            UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            
            // put the image into our list
            [_icons addObject: image];
        }
    }
    
    [_gridView reloadData];
    
    
    //Login View
    if ([[UIDevice currentDevice].model hasPrefix:@"iPhone"]) {
        self.iphonemodalLoginView=[[UIView alloc]initWithFrame:CGRectMake(0,0, self.view.bounds.size.width, self.view.bounds.size.height+40)];
        self.iphonemodalLoginView.opaque=NO;
        self.iphonemodalLoginView.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.5f];
        
        self.iwvp=[[IphoneWebViewPopup alloc]init];
        [self.iwvp.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        self.iwvp.view.center=self.view.center;
        [self.iphonemodalLoginView addSubview:self.iwvp.view];
        self.iphonemodalLoginView.center=self.view.center;
        [self.iphonemodalLoginView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        
        [self.view addSubview:self.iphonemodalLoginView];
    }
    
    if ([[UIDevice currentDevice].model hasPrefix:@"iPad"]) {
        self.modalLoginView=[[UIView alloc]initWithFrame:CGRectMake(0,0, self.view.bounds.size.width, self.view.bounds.size.height+40)];
        self.modalLoginView.opaque=NO;
        self.modalLoginView.backgroundColor=[[UIColor blackColor] colorWithAlphaComponent:0.5f];
        
        self.wvp=[[WebViewPopup alloc]init];
        [self.wvp.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        self.wvp.view.center=self.view.center;
        [self.modalLoginView addSubview:self.wvp.view];
        self.modalLoginView.center=self.view.center;
        [self.modalLoginView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
        
        [self.view addSubview:self.modalLoginView];
    }

    //login View
    
    
    //setua
    
    NSDictionary *dict=[[NSDictionary alloc]initWithObjectsAndKeys:@"puttyGadget", @"UserAgent",nil];
    
    [[NSUserDefaults standardUserDefaults]registerDefaults:dict];
    
    
    //

    
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}


- (void) willRotateToInterfaceOrientation: (UIInterfaceOrientation) toInterfaceOrientation
                                 duration: (NSTimeInterval) duration
{
    if ( UIInterfaceOrientationIsPortrait(toInterfaceOrientation) )
    {
        // width will be 768, which divides by four nicely already
        NSLog( @"Setting left+right content insets to zero" );
        _gridView.leftContentInset = 0.0;
        _gridView.rightContentInset = 0.0;
    }
    else
    {
        // width will be 1024, so subtract a little to get a width divisible by five
        NSLog( @"Setting left+right content insets to 2.0" );
        _gridView.leftContentInset = 1.0;
        _gridView.rightContentInset = 1.0;
    }
}



- (AQGridViewCell *) gridView: (AQGridView *) gridView cellForItemAtIndex: (NSUInteger) index
{
    static NSString * EmptyIdentifier = @"EmptyIdentifier";
    static NSString * CellIdentifier = @"CellIdentifier";
    
    if ( index == _emptyCellIndex )
    {
        NSLog( @"Loading empty cell at index %u", index );
        AQGridViewCell * hiddenCell = [gridView dequeueReusableCellWithIdentifier: EmptyIdentifier];
        if ( hiddenCell == nil )
        {
            // must be the SAME SIZE AS THE OTHERS
            // Yes, this is probably a bug. Sigh. Look at -[AQGridView fixCellsFromAnimation] to fix
            hiddenCell = [[AQGridViewCell alloc] initWithFrame: CGRectMake(0.0, 0.0, 72.0, 72.0)
                                               reuseIdentifier: EmptyIdentifier];
        }
        
        hiddenCell.hidden = YES;
        return ( hiddenCell );
    }
    
    NSString *label;
    UIImage *tempImage;
    
    
    switch(index)
    {
        case 0:
            label=@"eBooking";
            tempImage=[UIImage imageNamed:@"eBooking_128.png"];
            break;
        case 1:
            label=@"eRecords";
            tempImage=[UIImage imageNamed:@"eRecords_128.png"];
            break;
        case 2:
            label=@"eTags";
            tempImage=[UIImage imageNamed:@"eTags_128.png"];
            break;
        case 3:
            label=@"eHistory";
            tempImage=[UIImage imageNamed:@"eHistory_128.png"];
            break;
        case 4:
            label=@"eScripts";
            tempImage=[UIImage imageNamed:@"eScripts_128.png"];
            break;
        case 5:
            label=@"eAlerts";
            tempImage=[UIImage imageNamed:@"eAlerts_128.png"];
            break;
        case 6:
            label=@"eSummary";
            tempImage=[UIImage imageNamed:@"eSummary_128.png"];
            break;
        case 7:
            label=@"eMessages";
            tempImage=[UIImage imageNamed:@"eMessages_128.png"];
            break;
        case 8:
            label=@"eForms";
            tempImage=[UIImage imageNamed:@"eForms_128.png"];
            break;
        case 9:
            label=@"eNotes";
            tempImage=[UIImage imageNamed:@"eNotes_128.png"];
            break;
        case 10:
            label=@"eResults";
            tempImage=[UIImage imageNamed:@"eResults_128.png"];
            break;
        case 11:
            label=@"eLabs";
            tempImage=[UIImage imageNamed:@"eLab_128.png"];
            break;
        case 12:
            label=@"eCabinet";
            tempImage=[UIImage imageNamed:@"eCabinet_128.png"];
            break;
        case 13:
            label=@"eBilling";
            tempImage=[UIImage imageNamed:@"eBilling_128.png"];
            break;
        case 14:
            label=@"eInPatient";
            tempImage=[UIImage imageNamed:@"eInPatient_128.png"];
            break;
        case 15:
            label=@"eClinic";
            tempImage=[UIImage imageNamed:@"eClinic_128.png"];
            break;
        case 16:
            label=@"+Problem";
            tempImage=[UIImage imageNamed:@"Plus_120.png"];
            break;
        case 17:
            label=@"+Action";
            tempImage=[UIImage imageNamed:@"Plus_120.png"];
            break;
        case 18:
            label=@"+Contact";
            tempImage=[UIImage imageNamed:@"Plus_120.png"];
            break;
        case 19:
            label=@"+Bill";
            tempImage=[UIImage imageNamed:@"Plus_120.png"];
            break;
        case 20:
            label=@"+Booking";
            tempImage=[UIImage imageNamed:@"Plus_120.png"];
            break;
        case 21:
            label=@"+Script";
            tempImage=[UIImage imageNamed:@"Plus_120.png"];
            break;
        case 22:
            label=@"+PuttyHealth Card";
            tempImage=[UIImage imageNamed:@"Plus_120.png"];
            break;
//        case 23:
//            label=@"+eCab";
//            tempImage=[UIImage imageNamed:@"Plus_120.png"];
//            break;
            
        default:
            //label=@"eRecords";
            //tempImage=[UIImage imageNamed:@"eRecords_128.png"];
            NSLog(@"INDEX: %d",index);
            break;
            
    }
    
    
    
    SpringBoardIconCell * cell = (SpringBoardIconCell *)[gridView dequeueReusableCellWithIdentifier: CellIdentifier ];
    if ( cell == nil )
    {
        cell = [[SpringBoardIconCell alloc] initWithFrame: CGRectMake(0.0, 0.0, 150.0, 122.0)  reuseIdentifier: CellIdentifier ];
       // [[SpringBoardIconCell alloc] initWithFrame:CGRectMake(0.0, 0.0, 72.0, 72.0) reuseIdentifier:CellIdentifier label
    }
    
    cell.icon = [_icons objectAtIndex: index];
    [cell setIcon:tempImage];
    [cell clearLabel];
    [cell setLabel:label];
    NSLog(@"LABEL:%@",cell.labelText);
    if(cell.labelText ==NULL)
    {
        
    }
    
    return ( cell );	
}

- (NSUInteger) numberOfItemsInGridView: (AQGridView *) gridView
{
    return ( [_icons count] );
}

- (CGSize) portraitGridCellSizeForGridView: (AQGridView *) gridView
{
    return ( CGSizeMake(150.0, 135.0) );
}

- (void) gridView:(AQGridView *)gridView didSelectItemAtIndex:(NSUInteger)index
{ 
    // [self.tabBarController.viewControllers 
    NSLog(@"CLICK INDEX:%d",index);
    
    self.currentSelectedIndex=[NSString stringWithFormat:@"%d", index];
    
    
    self.scannerViewController=nil;
    self.iphonescannerViewController=nil;
    
    
//    //for UploadeCab Allocation
//    if(index==23)
//    {
//        
//        NSLog(@"did load view add eCab");   
//        self.uploadeCabinetController =[[UploadeCabinetController alloc]initWithNibName:@"UploadeCabinetController" bundle:[NSBundle mainBundle]];
//        self.uploadeCabinetController.view.frame=self.view.bounds;
//        self.uploadeCabinetController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;        
//        [self addChildViewController:self.uploadeCabinetController];
//        [self.view addSubview:self.uploadeCabinetController.view];
//        return;
//
//                
//    }

    
    
    //for PuttyHealthCare Allocation
    if(index==22)
    {
        if ([[UIDevice currentDevice].model hasPrefix:@"iPhone"]){
            
            self.iphonephCardAssignController =[[IphonePhCardAssignController alloc]initWithNibName:@"IphonePhCardAssignController" bundle:[NSBundle mainBundle]];
            self.iphonephCardAssignController.view.frame=self.view.bounds;
            self.iphonephCardAssignController.view.autoresizingMask=UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            [self addChildViewController:self.iphonephCardAssignController];
            [self.view addSubview:self.iphonephCardAssignController.view];
            return;
            
        }
        
        if ([[UIDevice currentDevice].model hasPrefix:@"iPad"]){
            
            self.phCardAssignController =[[PhCardAssignController alloc]initWithNibName:@"PhCardAssignController" bundle:[NSBundle mainBundle]];
            self.phCardAssignController.view.frame=self.view.bounds;
            self.phCardAssignController.view.autoresizingMask=UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            [self addChildViewController:self.phCardAssignController];
            [self.view addSubview:self.phCardAssignController.view];
            return;
        
        }
        
    }
    
    //
    
    
    if((index!=18&&index!=20)&&self.currentSelectedPatientID==nil)
    {
        if ([[UIDevice currentDevice].model hasPrefix:@"iPhone"]){
            
            self.iphonescannerViewController = [[IphoneScannerViewController alloc]  initWithNibName:@"IphoneScannerViewController" bundle:[NSBundle mainBundle]];
            self.iphonescannerViewController.view.frame = self.view.bounds;
            self.iphonescannerViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            
            //  [self.view addSubview:self.iphonescannerViewController.view];
            [self addChildViewController:self.iphonescannerViewController];
            [self.view addSubview:self.iphonescannerViewController.view];
        }
        
        if ([[UIDevice currentDevice].model hasPrefix:@"iPad"]){
            self.scannerViewController = [[ScannerViewController alloc]  initWithNibName:@"ScannerViewController" bundle:[NSBundle mainBundle]];
            self.scannerViewController.view.frame = self.view.bounds;
            self.scannerViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            
            //  [self.view addSubview:self.scannerViewController.view];
            [self addChildViewController:self.scannerViewController];
            [self.view addSubview:self.scannerViewController.view];
            
        }
    }
    else
    {
        //directly go to webview
        NSArray *param=[NSArray arrayWithObjects:self.currentSelectedIndex,self.currentSelectedPatientID, nil];
        self.tabBarController.selectedViewController= [self.tabBarController.viewControllers objectAtIndex:1];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"functionSelected" object:param];
    }
    
    //[self.scannerViewController.view show];
   // scannerViewController=nil;
    
   
    
    

}

- (void)handlePtSelected:(NSNotification *)notification {

   
    NSString *content=(NSString *)notification.object;
     NSLog(@"receivedPTselectedINFO in Home View. Content:%@",content);
    
        
    NSArray *param=[NSArray arrayWithObjects:self.currentSelectedIndex,content, nil];
    
  //  NSString *title=@"Patient";
    if([content isEqualToString:@"-1" ])
    {
        self.currentSelectedPatientID=nil;
    }
    else
    {
      //  title=[title stringByAppendingString:content];
        self.currentSelectedPatientID=content;
        [self.TitleButton setEnabled:true];

       // [self.TitleButton setTitle:title];
        
        [self getPatientDetails:self.currentSelectedPatientID];
    }
    
     self.tabBarController.selectedViewController= [self.tabBarController.viewControllers objectAtIndex:1];
     
     [[NSNotificationCenter defaultCenter] postNotificationName:@"functionSelected" object:param];
    
}

- (void)handlePtClosed:(NSNotification *)notification {
    if([self.patientInfoPopOverController isPopoverVisible]){
        [self.patientInfoPopOverController dismissPopoverAnimated:YES];
        
    }
    
    self.currentSelectedIndex=nil;
    self.currentSelectedPatientID=nil;
    [self.TitleButton setTitle:@"My Enterprise" ];
   // [self.TitleButton setEnabled:false];
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"SEGUE:%@",sender);
}




- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}


- (void)viewDidUnload
{
    [self setTitleButton:nil];
    [self setLoginButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    _gridView=nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self ];
    
    NSLog(@"HomeViewController Unloaded!");
}


/*- (IBAction)SigninButtonClicked:(id)sender {
   
}*/


- (IBAction)TitleButtonClicked:(id)sender {
    
    if(self.currentSelectedIndex !=nil)
    {
    if(![self.patientInfoPopOverController isPopoverVisible]){
        // Popover is not visible
        
        self.patientInfoView = [[PatientInfoViewController alloc] initWithNibName:@"PatientInfoViewController" bundle:nil ];
        
        self.patientInfoPopOverController = [[UIPopoverController alloc] initWithContentViewController:self.patientInfoView];
       
        [self.patientInfoPopOverController setPopoverContentSize:CGSizeMake(510.0f, 400.0f)];
        [self.patientInfoPopOverController presentPopoverFromBarButtonItem:(UIBarButtonItem *)sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
         [self.patientInfoView updatePatientDetails:self.patientDetails];
    }else{
        [self.patientInfoPopOverController dismissPopoverAnimated:YES];
        
    }
    }

}

- (void)tabBarController:(UITabBarController *)tabBarController
  didSelectViewController:(UIViewController *)viewController
{
    
}

/*- (IBAction)TestBtnClicked:(id)sender {
    
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
    
    
}*/

-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
   // NSLog(@"controller class: %@", NSStringFromClass([viewController class]));
    //NSLog(@"controller title: %@", viewController.title);
    
    //NSString *className=NSStringFromClass([viewController class]);
    
   /* if(self.currentSelectedPatientID!=nil&&[className isEqualToString:@"SecondViewController"])
    {
        //when pt selected and click the enterprise webview
        
        
         self.scannerViewController=nil;
         
         
         
         self.scannerViewController = [[ScannerViewController alloc]  initWithNibName:@"ScannerViewController" bundle:[NSBundle mainBundle]];
         self.scannerViewController.view.frame = self.view.bounds;
         self.scannerViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
         [self.view addSubview:self.scannerViewController.view];
        [self addChildViewController:self.scannerViewController];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"existingPatient" object:self.currentSelectedPatientID];
        
        return NO;
    }*/
    return YES;
}
- (IBAction)RestfulTest:(id)sender {

    
       
    
}

-(void)getPatientDetails:(NSString *)patientID
{
    NSString *query=[[NSString alloc]initWithFormat:@"d={\"func\":\"getPatientInfo\",\"param\":[\"%d\"]}",[patientID intValue]];
    
    PGRPCHelper *pg=[[PGRPCHelper alloc]init];
    [pg setDelegate:self];
    [pg getResponse:@"" withData:query];
    
    
}
-(void)OnFinishReceiveJSONResponse: (NSObject *)result
{
    NSLog(@"JSONFFF:%@",result);
    if([result isKindOfClass:[NSDictionary class]])
    {
        if([[result valueForKey:@"func"]isEqualToString:@"getXmppLoginForPEUser"])
        {
            [self appDelegate].xmppUserName=[result valueForKey:@"xmpp_username"];
            [self appDelegate].xmppPassword=[result valueForKey:@"xmpp_password"];
            NSLog(@"GETXMPP Login Details:%@  %@",[self appDelegate].xmppUserName,[self appDelegate].xmppPassword);
        }
    }
    else
    {
        NSArray *a=(NSArray*)result;
        NSDictionary* r=[a objectAtIndex:0];
        // NSLog(@"Addr %@",[result valueForKey:@"postcode"]);
        self.patientDetails=r;
        [self.TitleButton setTitle:[[NSString alloc]initWithFormat:@"Patient: %@ %@",[r valueForKey:@"first_name"],[r valueForKey:@"last_name"]]]; 
    }
}

- (void)handleLoginSuccess:(NSNotification *)notification {
    NSLog(@"Perform handleLoginSuccess ");
    
    self.loginData=(NSMutableDictionary *)notification.object;
    
    [self.modalLoginView removeFromSuperview];
    [self.iphonemodalLoginView removeFromSuperview];
    self.loginButton.title=@"Sign Out";
    
    NSString *query=[[NSString alloc]initWithFormat:@"d={\"func\":\"getXmppLoginForPEUser\",\"param\":[\"%@\"]}",@"admin@admin.com"];
    
    PGRPCHelper *pg=[[PGRPCHelper alloc]init];
    [pg setDelegate:self];
    [pg getResponse:@"" withData:query];
    
}

-(void)handleLoginFail:(NSNotification *)notification {

    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error " message:@"Login Incorrent!" delegate:NULL cancelButtonTitle:@"Try Again" otherButtonTitles: nil];
    [alert show];
    
    NSURL *url = [NSURL URLWithString:@"http://test.claydata.com/login.php"];
    	
    NSMutableURLRequest *requestObj = [NSMutableURLRequest requestWithURL:url];
    [requestObj setValue:@"puttyGadget" forHTTPHeaderField:@"User_Agent"];
    [self.wvp.WebView loadRequest:requestObj];
    [self.iwvp.IphoneWebView loadRequest:requestObj];
    //self.wvp.isLogoutRequest=YES;
    [self.view addSubview:self.modalLoginView];
    [self.view addSubview:self.iphonemodalLoginView];
}

- (IBAction)loginButtonPressed:(id)sender {
    if(self.loginData!=NULL)
    {
        //perform logout
        self.loginData=nil;
        NSURL *url = [NSURL URLWithString:@"http://test.claydata.com/index.php?action=logout"];
        
        NSMutableURLRequest *requestObj = [NSMutableURLRequest requestWithURL:url];
        [requestObj setValue:@"puttyGadget" forHTTPHeaderField:@"User_Agent"];
        [self.wvp.WebView loadRequest:requestObj];
        [self.iwvp.IphoneWebView loadRequest:requestObj];
        //self.wvp.isLogoutRequest=YES;
        [self.view addSubview:self.modalLoginView];
        [self.view addSubview:self.iphonemodalLoginView];
        
    }
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
  //  [self.view addSubview:self.modalLoginView];
    
}
@end
