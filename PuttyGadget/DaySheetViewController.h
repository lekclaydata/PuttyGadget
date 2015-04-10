//
//  DaySheetViewController.h
//  PuttyGadget
//
//  Created by Frank on 30/01/12.
//  Copyright (c) 2012 Claydata. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DaySheetViewController : UIViewController<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *WebView;
//@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *LoadingMask;

@end
