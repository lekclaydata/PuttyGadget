//
//  UploadeCabinetController.m
//  PuttyGadget
//
//  Created by Joe Chang on 27/09/13.
//  Copyright (c) 2013 Claydata. All rights reserved.
//

#import "UploadeCabinetController.h"
#import "DejalActivityView.h"
#import "PGUtil.h"

@implementation UploadeCabinetController

@synthesize cameraPopOverController=_cameraPopOverController;
@synthesize RaidoStopButton;
@synthesize RaidoRecordButton;
@synthesize AudioPlayButton;
@synthesize RadioRecFilesResult;
@synthesize UploadButton;
//@synthesize VideoRecFilesResult;
//@synthesize VideoPlayButton;
@synthesize WebView=_WebView;


NSURL *outputFileURL;
NSURL *movieURL;
NSData *radioData;
NSData *imageData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSLog(@"viewDidload in Second");
    
    NSString *urlAddress = [[NSString alloc]initWithFormat:@"http://test.claydata.com/templates/Telstra/PuttyGateway/"];
    
    //Create a URL object.
    NSURL *url = [NSURL URLWithString:urlAddress];
    
    //URL Requst Object
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    //Load the request in the UIWebView.
    self.WebView.scalesPageToFit=YES;
    self.WebView.delegate=self;
    [self.WebView loadRequest:requestObj];
    
    // Disable Stop/Play button when application launches
    
    [RaidoStopButton setEnabled:NO];
    [AudioPlayButton setEnabled:NO];
    [UploadButton setEnabled:NO];
  
    
    
    // Set the audio file
    NSArray *rdpathComponents = [NSArray arrayWithObjects:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject], @"MyAudioMemo.m4a",nil];
    outputFileURL = [NSURL fileURLWithPathComponents:rdpathComponents];
    
    // Setup audio session
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    // Define the recorder setting
    NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
    
    [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
    // Initiate and prepare the recorder
    recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:NULL];
    recorder.delegate = self;
    recorder.meteringEnabled = YES;
    [recorder prepareToRecord];
    
    
    // Make the autorotation works fine
    self.view.autoresizesSubviews = YES;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}



//-(void)viewWillAppear:(BOOL)animated
//{
//    
//    
//    // Initiate the movie controller
//    self.movieController = [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
//    [self.movieController.view setFrame:CGRectMake (30, 380, 384, 260)];
//    [self.view addSubview:self.movieController.view];
//    [self.movieController play];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(moviePlayBackDidFinish:)
//                                                 name:MPMoviePlayerPlaybackDidFinishNotification
//                                               object:self.movieController];
//}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"Started loading");
    //[self.LoadingMask startAnimating];
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Loading..."];
    [DejalActivityView currentActivityView].showNetworkActivityIndicator = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"Finshed loading");
    //  [self.LoadingMask stopAnimating];
    [DejalBezelActivityView removeViewAnimated:NO];
}


- (void)viewDidUnload
{
    
    [self setAudioPlayButton:nil];
    [self setRaidoRecordButton:nil];
    [self setRaidoStopButton:nil];
    [self setRadioRecFilesResult:nil];
//    [self setVideoRecFilesResult:nil];
//    [self setVideoPlayButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}


- (IBAction)ImageCaptureButtonPressed:(id)sender {
    
    NSLog(@"ActionSheet Active");
    
    UIActionSheet *pop = [[UIActionSheet alloc] initWithTitle:@"Choose Camera or PhotoLibrary" delegate:self cancelButtonTitle:@"Dismiss" destructiveButtonTitle:nil otherButtonTitles:@"PhotoLibrary", @"TakePhoto",nil];
    [pop showInView:self.view];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if ([buttonTitle isEqualToString:@"PhotoLibrary"]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        if (self.cameraPopOverController != nil) {
            [self.cameraPopOverController dismissPopoverAnimated:YES];
            self.cameraPopOverController=nil;
        }
        
        self.cameraPopOverController = [[UIPopoverController alloc] initWithContentViewController:picker];
        CGRect popoverRect = CGRectMake(200, 200, 400, 400);
        
        [self.cameraPopOverController presentPopoverFromRect:popoverRect
                                                      inView:self.view
                                    permittedArrowDirections:NO
                                                    animated:YES];
    }
    
    if ([buttonTitle isEqualToString:@"TakePhoto"]) {
        
        if ([UIImagePickerController isSourceTypeAvailable:
             UIImagePickerControllerSourceTypeCamera])
        {
            UIImagePickerController *picker =
            [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType =
            UIImagePickerControllerSourceTypeCamera;
            picker.mediaTypes = [NSArray arrayWithObjects:(NSString *) kUTTypeImage, nil];
            picker.allowsEditing = NO;
            [self presentModalViewController:picker animated:YES];
            newMedia = YES;
        }
        
    }
//    if ([buttonTitle isEqualToString:@"RecordVideo"]) {
//        
//        if ([UIImagePickerController isSourceTypeAvailable:
//             UIImagePickerControllerSourceTypeCamera])
//        {
//            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//            picker.delegate = self;
//            picker.allowsEditing = YES;
//            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
//            picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
//            
//            [self presentViewController:picker animated:YES completion:NULL];
//            
//            
//        }
//    }
}

- (IBAction)UploadButtonPressed:(id)sender {
    
    
    if (ImageView.image != nil) {
        
        NSData *imageData = UIImageJPEGRepresentation(ImageView.image, 90);
        NSString *urlString = @"http://58.108.162.254:8005/imageupload/upload.php";
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:urlString]];
        [request setHTTPMethod:@"POST"];
        
        NSString *boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
        [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
        
        NSMutableData *body = [NSMutableData data];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"userfile\"; filename=\".jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:imageData]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [request setHTTPBody:body];
        
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        
        NSLog(@"%@",returnString);
        
       
    }
    
    if (RadioRecFilesResult != nil) {
        
        NSData *radioData = [NSData dataWithContentsOfURL:outputFileURL];
        NSString *urlString = @"http://58.108.162.254:8005/imageupload/upload.php";
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:urlString]];
        [request setHTTPMethod:@"POST"];
        
        NSString *boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
        [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
        
        NSMutableData *body = [NSMutableData data];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"userfile\"; filename=\".m4a\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:radioData]];
        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [request setHTTPBody:body];
        
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        
        NSLog(@"%@",returnString);
        
        
    }
//    if (VideoRecFilesResult != nil) {
//        
//        NSData *videoData = [NSData dataWithContentsOfURL:movieURL];
//        NSString *urlString = @"http://192.168.4.228:8888/PhpstormProjects/Uploadphp/upload.php";
//        
//        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//        [request setURL:[NSURL URLWithString:urlString]];
//        [request setHTTPMethod:@"POST"];
//        
//        NSString *boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
//        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
//        [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
//        
//        NSMutableData *body = [NSMutableData data];
//        [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//        [body appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"userfile\"; filename=\".mov\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
//        [body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
//        [body appendData:[NSData dataWithData:videoData]];
//        [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//        [request setHTTPBody:body];
//        
//        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//        NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
//        
//        NSLog(@"%@",returnString);
//    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Done"
                                                    message: @"Successfully uploaded files!"
                                                   delegate: nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];

    NSLog(@"uploaddone");
    
}

//- (IBAction)FinishButtonPressed:(id)sender {
//    
//    [self.view removeFromSuperview];    
//}

- (IBAction)RadioRecordButtonPressed:(id)sender {
    
    // Stop the audio player before recording
    if (player.playing) {
        [player stop];
    }
    //recording check
    
    if (!recorder.recording) {
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        
        // Start recording
        [recorder record];
        NSLog(@"Raido Record Started");
        
    } 
    [RaidoStopButton setEnabled:YES];
    [AudioPlayButton setEnabled:NO];
    
}

- (IBAction)RadioStopButtonPressed:(id)sender {
    
    if (recorder.recording) {
        [recorder stop];
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setActive:NO error:nil];
        NSLog(@"Radio Record Stopped");
        
    }
    
    
}


- (IBAction)AudioPlayButtonPressed:(id)sender {
    
    if (!recorder.recording){
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:recorder.url error:nil];
        [player setDelegate:self];
        [player play];
        NSLog(@"Radio Play");
    }
}

//- (IBAction)VideoPlayButtonPressed:(id)sender {
//    
//    
//    movieController = [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
//    [movieController prepareToPlay];
//    [movieController.view setFrame:CGRectMake (0, 0,768, 1000)];
//    [self.view addSubview:movieController.view];
//    [movieController play];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(moviePlayBackDidFinish:)
//                                                 name:MPMoviePlayerPlaybackDidFinishNotification
//                                               object:movieController];
//    
//}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissModalViewControllerAnimated:YES];
    UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
    ImageView.image= image;
    if (_cameraPopOverController != nil) {
        [_cameraPopOverController dismissPopoverAnimated:YES];
        _cameraPopOverController=nil;
    }
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    [self dismissModalViewControllerAnimated:YES];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        ImageView.image = image;
        if (newMedia)
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:finishedSavingWithError:contextInfo:), nil);
        
        
    }
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
//        [picker dismissViewControllerAnimated:YES completion:NULL];
//        
//        NSArray *mvpathComponents = [NSArray arrayWithObjects:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],@"MyVideo.mov", nil];
//        
//        movieURL = [NSURL fileURLWithPathComponents:mvpathComponents];
//        if (newMedia){
//            NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
//            if ([mediaType isEqualToString:@"public.movie"]){        
//                // Saving the video / // Get the new unique filename 
//                NSString *sourcePath = [[info objectForKey:@"UIImagePickerControllerMediaURL"]relativePath]; 
//                UISaveVideoAtPathToSavedPhotosAlbum(sourcePath,nil,nil,nil);
//                
//                NSLog(@"Preview name of mov");
//                self.VideoRecFilesResult.text = @"MyVideo.mov";
//            }
//        }
        
    }
    [UploadButton setEnabled:YES];
}

-(void)image:(UIImage *)image
finishedSavingWithError:(NSError *)error
 contextInfo:(void *)contextInfo
{
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save image"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

//- (void)moviePlayBackDidFinish:(NSNotification *)notification {
//    
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
//    
//    [movieController stop];
//    [movieController.view removeFromSuperview];
//    movieController = nil;
//    
//}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissModalViewControllerAnimated:YES];
    if (_cameraPopOverController != nil) {
        [_cameraPopOverController dismissPopoverAnimated:YES];
        _cameraPopOverController=nil;
    }
    
}

- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)avrecorder successfully:(BOOL)flag{
    
    self.RadioRecFilesResult.text = @"MyAudioMemo.m4a";
    
    [RaidoStopButton setEnabled:NO];
    [AudioPlayButton setEnabled:YES];
    [UploadButton setEnabled:YES];
    
}

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Done"
                                                    message: @"Finish playing the recording!"
                                                   delegate: nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (IBAction)ImageResetButtonPressed:(id)sender {
    
    ImageView.image = nil;
    imageData = nil;
}

- (IBAction)AudioResetButtonPressed:(id)sender {
    
    RadioRecFilesResult.text = nil;
    radioData = nil;
    [AudioPlayButton setEnabled:NO];
}
@end
