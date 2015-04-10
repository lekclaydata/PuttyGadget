//
//  DaySheetViewController.m
//  PuttyGadget
//
//  Created by Frank on 30/01/12.
//  Copyright (c) 2012 Claydata. All rights reserved.
//

#import "DaySheetViewController.h"
#import "DejalActivityView.h"
#import "PGUtil.h"

@implementation DaySheetViewController
@synthesize WebView=_WebView;
//@synthesize LoadingMask = _LoadingMask;



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
    
 //   self.LoadingMask.hidesWhenStopped=true;
    
    
    /*[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleFunctionSelected:) name:@"functionSelected" object:nil];*/
    
    NSLog(@"viewDidload in Second");
    
     NSString *urlAddress = [[NSString alloc]initWithFormat:@"http://test.claydata.com/medbooks.php?view=calendarview&viewoption=day&day=%@&month=%@&year=%@&viewOption=hourview",[PGUtil getDateTime:@"dd"],[PGUtil getDateTime:@"MM"],[PGUtil getDateTime:@"yyyy" ]];
    
    //Create a URL object.
    NSURL *url = [NSURL URLWithString:urlAddress];
    
    //URL Requst Object
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    //Load the request in the UIWebView.
    self.WebView.scalesPageToFit=YES;
    self.WebView.delegate=self;
    [self.WebView loadRequest:requestObj];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"Started loading");
    //[self.LoadingMask startAnimating];
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Loading..."];
    [DejalActivityView currentActivityView].showNetworkActivityIndicator = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"Finshed loading");
  //  [self.LoadingMask stopAnimating];
    [DejalBezelActivityView removeViewAnimated:NO];
}


- (void)viewDidUnload
{
    [self setWebView:nil];
   // [self setLoadingMask:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
