//
//  SecondViewController.h
//  PuttyGadget
//
//  Created by Joseph Gracé on 24/01/12.
//  Copyright (c) 2012 Claydata. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondViewController : UIViewController<UIWebViewDelegate,UITabBarControllerDelegate,UITabBarDelegate>

- (void)handleFunctionSelected:(NSNotification *)notification;

@property (strong, nonatomic) IBOutlet UIWebView *WebContent;

@property (strong,nonatomic) NSString *injectJSString;
//@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *LoadingMask;
- (IBAction)TestButtonClicked:(id)sender;
- (IBAction)PrintButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *PrintButton;


- (void)tabBarController:(UITabBarController *)tabBarController 
 didSelectViewController:(UIViewController *)viewController;

-(void)handleRequestLinkAction :(NSNotification *)notification;

@end
