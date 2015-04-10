//
//  WebViewPopup.m
//  PuttyGadget
//
//  Created by Frank An on 30/04/12.
//  Copyright (c) 2012 Claydata. All rights reserved.
//

#import "WebViewPopup.h"
#import "DejalActivityView.h"

@implementation WebViewPopup
@synthesize WebView;
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
    self.WebView.delegate=self;
    // Do any additional setup after loading the view from its nib.
    
   
    
    //NSURL *url = [NSURL URLWithString:@"http://extjs.claydata.com/pgrpc/uatest.php"];
    NSURL *url = [NSURL URLWithString:@"http://test.claydata.com/login.php"];

    //URL Requst Object
    NSMutableURLRequest *requestObj = [NSMutableURLRequest requestWithURL:url];
    [requestObj setValue:@"puttyGadget" forHTTPHeaderField:@"User_Agent"];
    
    //Load the request in the UIWebView.
   // self.WebView.delegate=self;
    [self.WebView loadRequest:requestObj];
    
    
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
    [self setWebView:nil];
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
