//
//  WebViewController.m
//  PuttyGadget
//
//  Created by Frank on 26/01/12.
//  Copyright (c) 2012 Claydata. All rights reserved.
//

#import "WebViewController.h"

@implementation WebViewController

static NSString *RootAddress=@"http://test.claydata.com";
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleFunctionSelected:) name:@"functionSelected" object:nil];
    
    NSLog(@"viewDidload in Second");
    
    // NSString *urlAddress = @"http://test.claydata.com";
    
    //Create a URL object.
    NSURL *url = [NSURL URLWithString:RootAddress];
    
    //URL Requst Object
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
   // [self
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"Started loading");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"Finshed loading");
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
	return YES;
}

@end
