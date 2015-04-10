//
//  PatientInfoViewController.h
//  PuttyGadget
//
//  Created by Frank on 30/01/12.
//  Copyright (c) 2012 Claydata. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PatientInfoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *ReleasePatientButton;
- (IBAction)ReleasePatientButtonClicked:(id)sender;
- (IBAction)CloseCurrentPatientButtonClicked:(id)sender;
-(void) updatePatientDetails:(NSDictionary *)details;
@property (weak, nonatomic) IBOutlet UITextField *personTitle;

@property (weak, nonatomic) IBOutlet UITextField *firstName;
@property (weak, nonatomic) IBOutlet UITextField *lastName;
@property (weak, nonatomic) IBOutlet UITextField *dob;
@property (weak, nonatomic) IBOutlet UITextField *gender;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *mobile;
@property (weak, nonatomic) IBOutlet UIImageView *PatientImage;

@end
