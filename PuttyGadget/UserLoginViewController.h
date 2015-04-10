//
//  UserLoginViewController.h
//  PuttyGadget
//
//  Created by Joseph Gracé on 10/02/12.
//  Copyright (c) 2012 Claydata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface UserLoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *UserNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *PasswordTextField;
- (IBAction)LoginButtonClicked:(id)sender;

-(AppDelegate *)appDelegate;

@end
