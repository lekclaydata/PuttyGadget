//
//  IphoneWebViewPopup.m
//  PuttyGadget
//
//  Created by Joe Chang on 19/09/13.
//  Copyright (c) 2013 Claydata. All rights reserved.
//

#import "IphoneWebViewPopup.h"
#import "DejalActivityView.h"


@implementation IphoneWebViewPopup
@synthesize IphoneWebView;
@synthesize isLogoutRequest=_isLogoutRequest;

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
    
    //NSURL *url = [NSURL URLWithString:@"http://extjs.claydata.com/pgrpc/uatest.php"];
    NSURL *url = [NSURL URLWithString:@"http://test.claydata.com/login.php"];
    
    //URL Requst Object
    NSMutableURLRequest *requestObj = [NSMutableURLRequest requestWithURL:url];
    [requestObj setValue:@"puttyGadget" forHTTPHeaderField:@"User_Agent"];
    
    //Load the request in the UIWebView.
    // self.WebView.delegate=self;
    [self.IphoneWebView loadRequest:requestObj];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    NSLog(@"Started loading");
    //[self.LoadingMask startAnimating];
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Loading..."];
    [DejalActivityView currentActivityView].showNetworkActivityIndicator = YES;
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    //if(self.isLogoutRequest)
    /// {
    /*NSURL *url = [NSURL URLWithString:@"http://www.google.com"];
     
     //URL Requst Object
     NSMutableURLRequest *requestObj = [NSMutableURLRequest requestWithURL:url];
     [requestObj setValue:@"puttyGadget" forHTTPHeaderField:@"User_Agent"];
     [self.WebView loadRequest:requestObj];
     self.isLogoutRequest=NO;
     NSLog(@"Reloading samepage");*/
    
    // }
    [DejalBezelActivityView removeViewAnimated:NO];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



@end
