//
//  ViewController.m
//  FlappyFace
//
//  Created by James Thorne on 2013-03-18.
//  Copyright (c) 2013 James Thorne. All rights reserved.
//

#import "ViewController.h"
#import "Foundation/Foundation.h"
#import "AVFoundation/AVFoundation.h"
#import "QuartzCore/QuartzCore.h"

@interface ViewController ()

@property(nonatomic, retain) UIImageView* faceView;

@end


@implementation ViewController

@synthesize cameraView;
@synthesize faceDetector;

@synthesize faceView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    faceDetector = [LiveFaceDetector new];

    UIImageView* face = [UIImageView new];
    face.frame = CGRectMake(0, 0, 200, 200);
    
    UIImage* image = [UIImage imageNamed:@"Emma-Watson.png"];
    face.image = image;
    
    [self.view addSubview:face];
    self.faceView = face;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    AVCaptureSession* session = [[AVCaptureSession alloc] init];
	session.sessionPreset = AVCaptureSessionPresetMedium;
	
	CALayer* viewLayer = self.cameraView.layer;
	
	AVCaptureVideoPreviewLayer* captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
	
	captureVideoPreviewLayer.frame = self.cameraView.bounds;
	[viewLayer addSublayer:captureVideoPreviewLayer];
	
	AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [device lockForConfiguration:nil];
    device.focusMode = AVCaptureFocusModeContinuousAutoFocus;
    [device unlockForConfiguration];
	
	NSError *error = nil;
	AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
	if (!input) {
		// Handle the error appropriately.
		NSLog(@"ERROR: trying to open camera: %@", error);
	}
	[session addInput:input];
    [session addOutput:faceDetector.videoDataOutput];
    [[self.faceDetector.videoDataOutput connectionWithMediaType:AVMediaTypeVideo] setEnabled:YES];
	
	[session startRunning];
}

-(IBAction)debugTap:(id)sender
{
    float xCenter, yCenter;
    
    UIImage* image = self.faceDetector.latestImage;
    self.faceView.image = image;
    
    if (self.faceDetector.detectedFaces.count == 0)
    {
        return;
    }
    
    CIFaceFeature* feature = [self.faceDetector.detectedFaces objectAtIndex:0];
    if (!feature.hasLeftEyePosition || !feature.hasRightEyePosition)
    {
        return;
    }
    
    xCenter = (feature.leftEyePosition.x + feature.rightEyePosition.x) / 2.0;
    yCenter = (feature.leftEyePosition.y + feature.rightEyePosition.y) / 2.0;
    
    // Swap x and y
    float xDraw = yCenter;
    float yDraw = xCenter;
    
    self.faceView.frame = CGRectMake(xDraw - 25, yDraw - 25, 50, 50);
}

@end
