//
//  IphoneWebViewPopup.h
//  PuttyGadget
//
//  Created by Joe Chang on 20/09/13.
//  Copyright (c) 2013 Claydata. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IphoneWebViewPopup : UIViewController<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *IphoneWebView;
@property (assign, nonatomic) Boolean isLogoutRequest;

@end
