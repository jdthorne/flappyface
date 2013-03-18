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

@end


@implementation ViewController

@synthesize cameraView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
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
	
	NSError *error = nil;
	AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
	if (!input) {
		// Handle the error appropriately.
		NSLog(@"ERROR: trying to open camera: %@", error);
	}
	[session addInput:input];
	
	[session startRunning];
}

@end
