//
//  WebViewPopup.h
//  PuttyGadget
//
//  Created by Frank An on 30/04/12.
//  Copyright (c) 2012 Claydata. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewPopup : UIViewController<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *WebView;
@property (assign,nonatomic) Boolean isLogoutRequest;

//- (void)handleLoginSuccess:(NSNotification *)notification;


@end
