//
//  ScannerViewController.h
//  PuttyGadget
//
//  Created by Frank on 29/01/12.
//  Copyright (c) 2012 Claydata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"
#import "PGRPCHelper.h"

@interface ScannerViewController : UIViewController  < ZBarReaderDelegate,UITextFieldDelegate,PGRPCHelperDelegate,UIAlertViewDelegate >

@property (weak, nonatomic) IBOutlet UIImageView *ResultImage;

@property (weak, nonatomic) IBOutlet UIButton *GoButton;

@property (weak, nonatomic) IBOutlet UITextField *ScanResult;

@property (strong,nonatomic) NSArray* queryResult;
@property (strong,nonatomic) NSString* selectedPersonID;
@property (strong,nonatomic) NSString* selectedText;
//@property (weak, nonatomic) IBOutlet UIButton *ScanGoButton;

- (IBAction)ScanButtonPressed:(id)sender;
- (IBAction)ScanGoButtonPressed:(id)sender;
- (IBAction)GoToEnterpriseButtonClicked:(id)sender;
- (IBAction)FnishButtonClicked:(id)sender;
- (IBAction)SeachTextFieldChanged:(id)sender;
- (void)handleExistingPatient:(NSNotification *)notification;
- (void)keyBoardWasShown:(NSNotification *)notification;
- (void)keyboardWillBeHidden:(NSNotification *)notification;
- (void)textFieldDidBeginEditing:(UITextField *)textField;
- (void)OnFinishReceiveJSONResponse: (NSDictionary *)result;



@property (weak, nonatomic) IBOutlet UIScrollView *ContentScrollView;
@property (weak,nonatomic) UITextField * activeField;
@property (weak, nonatomic) IBOutlet UITextField *SearchTextField;
@property (strong, nonatomic) IBOutlet UISearchDisplayController *SearchDisplayController;
@property (weak, nonatomic) IBOutlet UISearchBar *PatientSearchBar;



@end
