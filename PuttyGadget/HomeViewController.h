//
//  HomeViewController.h
//  PuttyGadget
//
//  Created by Joseph Gracé on 24/01/12.
//  Copyright (c) 2012 Claydata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AQGridView.h"
#import "ScannerViewController.h"
#import "PatientInfoViewController.h"
#import "PGRPCHelper.h"
#import "WebViewPopup.h"
#import "IphoneWebViewPopup.h"
#import "PhCardAssignController.h"
#import "AppDelegate.h"
#import "IphoneScannerViewController.h"
#import "IphonePhCardAssignController.h"
//#import "UploadeCabinetController.h"



@interface HomeViewController : UIViewController <AQGridViewDataSource,AQGridViewDelegate,UITabBarControllerDelegate,UITabBarDelegate,ZBarReaderDelegate,PGRPCHelperDelegate,NSURLConnectionDelegate>
{

    NSMutableArray * _icons;
    AQGridView *_gridView;
    NSUInteger _emptyCellIndex;
    


}
- (IBAction)RestfulTest:(id)sender;

@property (strong, nonatomic) ScannerViewController* scannerViewController;
@property (strong, nonatomic) IphoneScannerViewController* iphonescannerViewController;
@property (strong, nonatomic) NSString* currentSelectedIndex;
@property (strong, nonatomic) NSString* currentSelectedPatientID;

- (void)handlePtSelected:(NSNotification *)notification ;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *TitleButton;
- (IBAction)TitleButtonClicked:(id)sender;



@property (nonatomic,retain) UIPopoverController* patientInfoPopOverController;
@property (nonatomic,retain) PatientInfoViewController* patientInfoView;
//@property (nonatomic,strong) UploadeCabinetController* uploadeCabinetController;
@property (nonatomic,strong) PhCardAssignController* phCardAssignController;
@property (nonatomic,strong) IphonePhCardAssignController *iphonephCardAssignController;
@property (nonatomic,strong) PGRPCHelper* pg;
@property (nonatomic,strong) NSDictionary* patientDetails;

@property (nonatomic,strong) WebViewPopup *wvp;
@property (nonatomic,strong) IphoneWebViewPopup *iwvp;
@property (nonatomic,strong) UIView *modalLoginView;
@property (nonatomic,strong) UIView *iphonemodalLoginView;
@property (nonatomic,strong) NSMutableDictionary *loginData;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *loginButton;

- (IBAction)SigninButtonClicked:(id)sender;
- (void)handlePtClosed:(NSNotification *)notification;
- (void)tabBarController:(UITabBarController *)tabBarController 
 didSelectViewController:(UIViewController *)viewController;
- (void)OnFinishReceiveJSONResponse: (NSDictionary *)result;
- (void)getPatientDetails:(NSString *)patientID;

- (void)handleLoginSuccess:(NSNotification *)notification;
- (void)handleLoginFail:(NSNotification *)notification;
//- (IBAction)TestBtnClicked:(id)sender;
- (IBAction)loginButtonPressed:(id)sender;

@end
