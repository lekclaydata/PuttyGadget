//
//  SecondViewController.m
//  PuttyGadget
//
//  Created by Joseph Gracé on 24/01/12.
//  Copyright (c) 2012 Claydata. All rights reserved.
//

#import "SecondViewController.h"
#import "DejalActivityView.h"
#import "PGUtil.h"

@implementation SecondViewController
@synthesize PrintButton = _PrintButton;
@synthesize WebContent=_WebContent;
@synthesize injectJSString=_injectJSString;
//@synthesize LoadingMask = _LoadingMask;

static NSString *RootAddress=@"http://test.claydata.com";
//static NSString *RootAddress=@"http://extjs.claydata.com/mims/jstest.html";
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
    
  //  self.LoadingMask.hidesWhenStopped=true;

    
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleFunctionSelected:) name:@"functionSelected" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRequestLinkAction:) name:@"handleRequestLinkAction" object:nil];
    
    NSLog(@"viewDidload in Second");
   
   // NSString *urlAddress = @"http://test.claydata.com";
    
    //Create a URL object.
    NSURL *url = [NSURL URLWithString:RootAddress];
    //NSURL *url = [NSURL URLWithString:@"http://192.168.4.190/pgrpc/login.php"];
    //URL Requst Object
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    self.WebContent.scalesPageToFit=YES;
    //Load the request in the UIWebView.
    self.WebContent.delegate=self;
    [self.WebContent loadRequest:requestObj];
   // [self handleFunctionSelected:nil];

}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)handleFunctionSelected:(NSNotification *)notification {
   //  NSLog(@"ttttt");
    NSArray *content=(NSArray *)notification.object;
    NSLog(@"Received Call:%@",content);
    
    NSString *target=RootAddress;
    NSString *functionIndex=[content objectAtIndex:0];
    
    NSString *patientID=[content count]>1?[content objectAtIndex:1]:@"-1";
  

    if([functionIndex isEqualToString:@"0"])
    {
        target=[target stringByAppendingString:@"/ebookings.php"] ;
      
        
    }
    else if([functionIndex isEqualToString:@"1"])
    {
        target=[target stringByAppendingString:@"/erecords.php"] ;
        
        
    }
    else if([functionIndex isEqualToString:@"2"])
    {
        target=[target stringByAppendingString:@"/etags.php"] ;
      
        
    }
    else if([functionIndex isEqualToString:@"3"])
    {
        target=[target stringByAppendingString:@"/ehistory.php"] ;
               
    }
    else if([functionIndex isEqualToString:@"4"])
    {
        target=[target stringByAppendingString:@"/escripts.php"] ;
        
    }
    else if([functionIndex isEqualToString:@"5"])
    {
        target=[target stringByAppendingString:@"/ealerts.php"] ;
               
    }
    else if([functionIndex isEqualToString:@"6"])
    {
        target=[target stringByAppendingString:@"/esummaries.php"] ;
      
        
    }
    else if([functionIndex isEqualToString:@"7"])
    {
        target=[target stringByAppendingString:@"/enotifications.php"] ;
               
    }
    else if([functionIndex isEqualToString:@"8"])
    {
        target=[target stringByAppendingString:@"/eqandas.php"] ;
        
    }
    else if([functionIndex isEqualToString:@"9"])
    {
        target=[target stringByAppendingString:@"/enotes.php"] ;
    
        
    }
    else if([functionIndex isEqualToString:@"10"])
    {
        target=[target stringByAppendingString:@"/eresults.php"] ;
   
        
    }
    else if([functionIndex isEqualToString:@"11"])
    {
        target=[target stringByAppendingString:@"/elabs.php"] ;
      
        
    }
    else if([functionIndex isEqualToString:@"12"])
    {
        target=[target stringByAppendingString:@"/ecabinet.php"] ;
              
    }
    else if([functionIndex isEqualToString:@"13"])
    {
        target=[target stringByAppendingString:@"/ebillings.php"] ;
       
        
    }
    
    else if([functionIndex isEqualToString:@"14"])
    {
        target=[target stringByAppendingString:@"/einpatient.php"] ;
        
    }

    else if([functionIndex isEqualToString:@"15"])
    {
        target=[target stringByAppendingString:@"/eclinic.php"] ;
        
    }
    
    else if([functionIndex isEqualToString:@"16"])
    {
        target=[target stringByAppendingString:@"/ehistory.php"] ;
        self.injectJSString=@"onCreateHxProblem(null,2)";
        
    }
    else if([functionIndex isEqualToString:@"17"])
    {
        target=[target stringByAppendingString:@"/erecords.php"] ;
        self.injectJSString=@"onAddActionPopup(this,'')";
        
    }
    else if([functionIndex isEqualToString:@"18"])
    {
        target=[target stringByAppendingString:@"/econtacts.php"] ;
        self.injectJSString=@"onAddContact(this)";
        patientID=@"-1";
        
    }
    else if([functionIndex isEqualToString:@"19"])
    {
        target=[target stringByAppendingString:@"/ebillings.php"] ;
        self.injectJSString=[[NSString alloc]initWithFormat:@"onAddBilling(null,'%@')",patientID];
        
        
        patientID=@"-1";
        
    }
    else if([functionIndex isEqualToString:@"20"])
    {
       // NSLog(@"TTTTT:%@",[PGUtil getDateTime:@"dd"]);
       // NSLog(@"TTTTT:%@",[PGUtil getDateTime:@"mm"]);
       // NSLog(@"TTTTT:%@",[PGUtil getDateTime:@"yyyy"]);
       // NSLog(@"TTTTT:%@",[PGUtil getAMPM]);
        NSString *getRequest=[[NSString alloc]initWithFormat:@"/medbooks.php?view=calendarview&viewoption=day&day=%@&month=%@&year=%@&viewOption=hourview",[PGUtil getDateTime:@"dd"],[PGUtil getDateTime:@"MM"],[PGUtil getDateTime:@"yyyy" ]];
        
        target=[target stringByAppendingString:getRequest] ;
        self.injectJSString=[[NSString alloc]initWithFormat:@"addEvent('booking','%@-%@-%@','','%@','%@','%@','','','','hourview','')",[PGUtil getDateTime:@"dd"],[PGUtil getDateTime:@"MM"],[PGUtil getDateTime:@"yyyy"],[PGUtil getDateTime:@"h"],[PGUtil getDateTime:@"mm"],[PGUtil getAMPM]];
        
        
        patientID=@"-1";
        
    }
    else if([functionIndex isEqualToString:@"21"])
    {
        target=[target stringByAppendingString:@"/escripts.php"] ;
        self.injectJSString=[[NSString alloc]initWithFormat:@"onAddScript(this,'%@')",patientID];
        
        
      //  patientID=@"-1";
        
    }

    else
    {
        //go to default site in the settings
        
         //target=[target stringByAppendingString:@"/ebillings.php?patient_id="] ;
    }
    
    if(![patientID isEqualToString:@"-1"])
    {
        target=[target stringByAppendingString:@"?patient_id="];
        target=[target stringByAppendingString:patientID];
    
    }
    
    
    
    
    
    NSLog(@"URL:%@",target);
    NSURL *url = [NSURL URLWithString:target];

    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.WebContent loadRequest:requestObj];

    //Tag *mytag = (Tag *)notification.object;
   // [self dismissModalViewControllerAnimated:YES];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"Started loading");
    //[self.LoadingMask startAnimating];
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Loading..."];
    [DejalActivityView currentActivityView].showNetworkActivityIndicator = YES;

    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"Finshed loading");
   // [self.LoadingMask stopAnimating];
    [DejalBezelActivityView removeViewAnimated:NO];
    
    if(self.injectJSString!=NULL)
    {
        NSLog(@"Inject Js String:%@",self.injectJSString);
        [self.WebContent stringByEvaluatingJavaScriptFromString:self.injectJSString];
        self.injectJSString=NULL;
    
    }
}

- (void)viewDidUnload
{
    [self setWebContent:nil];
   // [self setLoadingMask:nil];
    [self setPrintButton:nil];
    [self setPrintButton:nil];
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
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (IBAction)TestButtonClicked:(id)sender {
    
    [self.WebContent stringByEvaluatingJavaScriptFromString:@"onCreateHxProblem(null,2)"];
}


-(void)handleRequestLinkAction :(NSNotification *)notification;
{
    NSMutableDictionary *content=(NSMutableDictionary *)notification.object;
    
    if([[content valueForKey:@"action"]isEqualToString:@"print"])
    {
        NSString *sample=[[NSString alloc]init];
        sample=@"<html><head><style type=\"text/css\">body {color:red;}h1 {color:#00ff00;}p.ex {color:rgb(0,0,255);}</style></head><body><h1>This is heading 1</h1><p>This is an ordinary paragraph. Notice that this text is red. The default text-color for a page is defined in the body selector.</p><p class=\"ex\">This is a paragraph with class=\"ex\". This text is blue.</p></body></html>";
        
        NSString *r=[self.WebContent stringByEvaluatingJavaScriptFromString:@"document.getElementById('formheader').innerHTML"];
        NSLog(@"RESULT:%@",sample);
        UIMarkupTextPrintFormatter *html=[[UIMarkupTextPrintFormatter alloc]initWithMarkupText:sample];
        
        
        
        UIPrintInteractionController *pic=[UIPrintInteractionController sharedPrintController];
        UIPrintInfo *printInfo=[UIPrintInfo printInfo];
        printInfo.outputType = UIPrintInfoOutputGeneral;
        printInfo.jobName = @"Test123";
        printInfo.duplex = UIPrintInfoDuplexLongEdge;
        pic.printInfo = printInfo;
        pic.showsPageRange = YES;
        // pic.printFormatter=[self.WebContent viewPrintFormatter];
        pic.printFormatter=html;
        //pic.printingItem = dataFromPath;
        
        void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) = ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
            if (!completed && error) {
                NSLog(@"FAILED! due to error in domain %@ with error code %u", error.domain, error.code);
            }
        };
        //[pic pr
        [pic presentFromBarButtonItem:self.PrintButton animated:YES completionHandler:completionHandler];
    }
}

- (IBAction)PrintButtonClicked:(id)sender {
    
    NSString *sample=[[NSString alloc]init];
    sample=@"<html><head><style type=\"text/css\">body {color:red;}h1 {color:#00ff00;}p.ex {color:rgb(0,0,255);}</style></head><body><h1>This is heading 1</h1><p>This is an ordinary paragraph. Notice that this text is red. The default text-color for a page is defined in the body selector.</p><p class=\"ex\">This is a paragraph with class=\"ex\". This text is blue.</p></body></html>";
    
    NSString *r=[self.WebContent stringByEvaluatingJavaScriptFromString:@"document.getElementById('formheader').innerHTML"];
    NSLog(@"RESULT:%@",sample);
    UIMarkupTextPrintFormatter *html=[[UIMarkupTextPrintFormatter alloc]initWithMarkupText:sample];
    
    
    
    UIPrintInteractionController *pic=[UIPrintInteractionController sharedPrintController];
    UIPrintInfo *printInfo=[UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputGeneral;
    printInfo.jobName = @"Test123";
    printInfo.duplex = UIPrintInfoDuplexLongEdge;
    pic.printInfo = printInfo;
    pic.showsPageRange = YES;
   // pic.printFormatter=[self.WebContent viewPrintFormatter];
    pic.printFormatter=html;
    //pic.printingItem = dataFromPath;
    
    void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) = ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
        if (!completed && error) {
            NSLog(@"FAILED! due to error in domain %@ with error code %u", error.domain, error.code);
        }
    };
    //[pic pr
   // [pic presentFromBarButtonItem:self.PrintButton animated:YES completionHandler:completionHandler];
    [pic presentAnimated:YES completionHandler:completionHandler];
    //[pic presentAnimated:YES completionHandler:completionHandler];
    
}


- (void)tabBarController:(UITabBarController *)tabBarController 
 didSelectViewController:(UIViewController *)viewController
{
    NSLog(@"SSScontroller class: %@", NSStringFromClass([viewController class]));
    NSLog(@"SSScontroller title: %@", viewController.title);
}

@end
