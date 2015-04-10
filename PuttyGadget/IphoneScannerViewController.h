//
//  IphoneScannerViewController.h
//  PuttyGadget
//
//  Created by Joe Chang on 23/09/13.
//  Copyright (c) 2013 Claydata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"
#import "PGRPCHelper.h"

@interface IphoneScannerViewController : UIViewController < ZBarReaderDelegate, UITextFieldDelegate, PGRPCHelperDelegate, UIAlertViewDelegate >


@property (weak, nonatomic) IBOutlet UIImageView *IphoneResultImage;
@property (weak, nonatomic) IBOutlet UIButton *IphoneGoButton;
@property (weak, nonatomic) IBOutlet UITextField *IphoneScanResult;

@property (strong,nonatomic) NSArray* iphonequeryResult;
@property (strong,nonatomic) NSString* iphoneselectedPersonID;
@property (strong,nonatomic) NSString* iphoneselectedText;

- (IBAction)IphoneScanButtonPressed:(id)sender;
- (IBAction)IphoneGoButtonPressed:(id)sender;
- (IBAction)IphoneGoToEnterpriseButtonClicked:(id)sender;
- (IBAction)IphoneFnishButtonClicked:(id)sender;

- (void)handleExistingPatient:(NSNotification *)notification;
- (void)keyBoardWasShown:(NSNotification *)notification;
- (void)keyboardWillBeHidden:(NSNotification *)notification;
- (void)textFieldDidBeginEditing:(UITextField *)textField;
- (void)OnFinishReceiveJSONResponse: (NSDictionary *)result;
- (IBAction)searchTextFiledDidChange:(id)sender;

@property (weak, nonatomic) IBOutlet UIScrollView *IphoneContentScrollView;
@property (strong, nonatomic) IBOutlet UISearchDisplayController *IphoneSearchDisplayController;
@property (weak, nonatomic) IBOutlet UISearchBar *IphonePatientSearchBar;
@property (weak, nonatomic) UITextField *iphoneactiveField;
@property (weak, nonatomic) IBOutlet UITextField *IphoneSearchTextField;


@end
