//
//  IphonePhCardAssignController.h
//  PuttyGadget
//
//  Created by Joe Chang on 24/09/13.
//  Copyright (c) 2013 Claydata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGRPCHelper.h"
#import "ZBarSDK.h"

@interface IphonePhCardAssignController : UIViewController <ZBarReaderDelegate, PGRPCHelperDelegate>

@property (strong, nonatomic) IBOutlet UISearchDisplayController *IphonePatientSearchDisplayController;

@property (strong,nonatomic) NSArray* iphonequeryResult;
@property (strong,nonatomic) NSString* iphoneselectedPersonID;

@property (weak, nonatomic) IBOutlet UITextView *IphoneScanResult;
@property (weak, nonatomic) IBOutlet UIImageView *IphoneResultImage;

@property (weak, nonatomic) IBOutlet UIButton *IphoneAssignButton;
@property (weak, nonatomic) IBOutlet UIButton *IphoneAlterButton;
@property (weak, nonatomic) IBOutlet UIButton *IphoneDeallocateButton;

@property (weak, nonatomic) IBOutlet UIScrollView *IphoneScrollView;
@property (weak,nonatomic) UITextField * iphoneactiveField;
@property (weak, nonatomic) IBOutlet UISearchBar *IphonePatientSearchBar;
@property (weak, nonatomic) IBOutlet UITextField *IphoneSearchTextField;

- (IBAction)IphoneSearchTextDidChange:(id)sender;
- (IBAction)IphoneScanButtonClicked:(id)sender;
- (IBAction)IphoneAssignButtonClicked:(id)sender;
- (IBAction)IphoneAlertButtonClicked:(id)sender;
- (IBAction)IphoneDeallocateButtonClicked:(id)sender;
- (IBAction)IphoneFinishButtonClicked:(id)sender;


-(void) resetData;

@end
