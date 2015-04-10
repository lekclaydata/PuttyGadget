//
//  PhCardAssignController.h
//  PuttyGadget
//
//  Created by Frank An on 23/05/12.
//  Copyright (c) 2012 Claydata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGRPCHelper.h"
#import "ZBarSDK.h"

@interface PhCardAssignController : UIViewController <ZBarReaderDelegate,PGRPCHelperDelegate>
@property (strong, nonatomic) IBOutlet UISearchDisplayController *PatientSearchDisplayController;

@property (strong,nonatomic) NSArray* queryResult;
@property (strong,nonatomic) NSString* selectedPersonID;
@property (weak, nonatomic) IBOutlet UIButton *AssignButton;
@property (weak, nonatomic) IBOutlet UITextView *ScanResult;
@property (weak, nonatomic) IBOutlet UIImageView *ResultImage;
@property (weak, nonatomic) IBOutlet UIButton *AlterCardButton;
@property (weak, nonatomic) IBOutlet UIButton *DeallocateButton;
@property (weak, nonatomic) IBOutlet UIScrollView *ScrollView;
@property (weak,nonatomic) UITextField * activeField;
@property (weak, nonatomic) IBOutlet UITextField *SearchTextField;

@property (weak, nonatomic) IBOutlet UISearchBar *PatientSearchBar;
- (IBAction)AssignButtonClicked:(id)sender;
- (IBAction)ScanButtonClicked:(id)sender;
- (IBAction)AlterCardButtonClicked:(id)sender;
- (IBAction)DeallocateButtonClicked:(id)sender;
- (IBAction)FinishButtonClicked:(id)sender;
- (IBAction)TextDidChange:(id)sender;
- (void) resetData;
@end
