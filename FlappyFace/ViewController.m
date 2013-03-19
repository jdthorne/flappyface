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

#import "FaceOverlayRenderer.h"

@interface ViewController ()

@property(nonatomic, retain) LiveFaceDetector* faceDetector;
@property(nonatomic, retain) UIImageView* faceView;

-(void) renderFaces: (NSArray*) faces withAperture: (CGRect) aperture;

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
    face.contentMode = UIViewContentModeScaleToFill;
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
    
    captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspect;
	
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
    [self.faceDetector beginDetectingFacesInSession:session andWhenDetected:^(CGRect aperture, NSArray* faces) {
        [self renderFaces:faces withAperture:aperture];
    }];
	
	[session startRunning];
}

-(void) renderFaces: (NSArray*) faces withAperture: (CGRect) aperture
{
    if (faces.count == 0)
    {
        self.faceView.hidden = true;
        return;
    }
    
    CIFaceFeature* feature = [faces objectAtIndex:0];
    CGRect previewBox = [FaceOverlayRenderer videoPreviewBoxForGravity:AVLayerVideoGravityResizeAspect frameSize:self.cameraView.frame.size apertureSize:aperture.size];
    CGRect videoBox = aperture;
    CGRect bounds = [FaceOverlayRenderer convertFrame:feature.bounds previewBox:previewBox forVideoBox:videoBox isMirrored:false];
    
    float extraWidth = (bounds.size.width * 0.2);
    float extraHeight = (bounds.size.height * 0.5);
    bounds = CGRectMake(bounds.origin.x + extraWidth/2, bounds.origin.y - extraHeight/2, bounds.size.width + extraWidth, bounds.size.height + extraHeight);
    
    self.faceView.hidden = false;
    self.faceView.frame = bounds;
}

@end
