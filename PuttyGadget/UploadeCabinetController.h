//
//  UploadeCabinetController.h
//  PuttyGadget
//
//  Created by Joe Chang on 27/09/13.
//  Copyright (c) 2013 Claydata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>


@interface UploadeCabinetController : UIViewController < UINavigationControllerDelegate, UIImagePickerControllerDelegate, AVAudioRecorderDelegate, AVAudioPlayerDelegate, UIPopoverControllerDelegate, UIWebViewDelegate > {
        
    IBOutlet UIButton *Get;
    IBOutlet UIImageView *ImageView;
    AVAudioRecorder *recorder;
    AVAudioPlayer *player;
    MPMoviePlayerController *movieController;
    
    BOOL newMedia;
 
}


@property (nonatomic,retain) UIPopoverController* cameraPopOverController;

@property (weak, nonatomic) IBOutlet UIWebView *WebView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *RaidoStopButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *RaidoRecordButton;
@property (weak, nonatomic) IBOutlet UIButton *AudioPlayButton;
@property (weak, nonatomic) IBOutlet UITextField *RadioRecFilesResult;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *UploadButton;


//@property (weak, nonatomic) IBOutlet UITextField *VideoRecFilesResult;
////@property (weak, nonatomic) IBOutlet UIButton *VideoPlayButton;


- (IBAction)ImageCaptureButtonPressed:(id)sender;
- (IBAction)UploadButtonPressed:(id)sender;
//- (IBAction)FinishButtonPressed:(id)sender;
- (IBAction)RadioRecordButtonPressed:(id)sender;
- (IBAction)RadioStopButtonPressed:(id)sender;
- (IBAction)AudioPlayButtonPressed:(id)sender;
//- (IBAction)VideoPlayButtonPressed:(id)sender;
- (IBAction)ImageResetButtonPressed:(id)sender;
- (IBAction)AudioResetButtonPressed:(id)sender;

@end
