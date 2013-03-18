//
//  LiveFaceDetector.m
//  FlappyFace
//
//  Created by James Thorne on 2013-03-18.
//  Copyright (c) 2013 James Thorne. All rights reserved.
//

#import "LiveFaceDetector.h"

enum {
    PHOTOS_EXIF_0ROW_TOP_0COL_LEFT			= 1, //   1  =  0th row is at the top, and 0th column is on the left (THE DEFAULT).
    PHOTOS_EXIF_0ROW_TOP_0COL_RIGHT			= 2, //   2  =  0th row is at the top, and 0th column is on the right.
    PHOTOS_EXIF_0ROW_BOTTOM_0COL_RIGHT      = 3, //   3  =  0th row is at the bottom, and 0th column is on the right.
    PHOTOS_EXIF_0ROW_BOTTOM_0COL_LEFT       = 4, //   4  =  0th row is at the bottom, and 0th column is on the left.
    PHOTOS_EXIF_0ROW_LEFT_0COL_TOP          = 5, //   5  =  0th row is on the left, and 0th column is the top.
    PHOTOS_EXIF_0ROW_RIGHT_0COL_TOP         = 6, //   6  =  0th row is on the right, and 0th column is the top.
    PHOTOS_EXIF_0ROW_RIGHT_0COL_BOTTOM      = 7, //   7  =  0th row is on the right, and 0th column is the bottom.
    PHOTOS_EXIF_0ROW_LEFT_0COL_BOTTOM       = 8  //   8  =  0th row is on the left, and 0th column is the bottom.
};

@interface LiveFaceDetector ()

@property(nonatomic, retain) id videoDataOutputQueue;
@property(nonatomic, retain) CIDetector* faceDetector;

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection;

@end

@implementation LiveFaceDetector

@synthesize videoDataOutput;
@synthesize videoDataOutputQueue;
@synthesize faceDetector;
@synthesize detectedFaces;

@synthesize latestImage;

-(id) init
{
    videoDataOutput = [AVCaptureVideoDataOutput new];
 
    [self.videoDataOutput setAlwaysDiscardsLateVideoFrames:YES];
    
    // create a serial dispatch queue used for the sample buffer delegate
    // a serial dispatch queue must be used to guarantee that video frames will be delivered in order
    // see the header doc for setSampleBufferDelegate:queue: for more information
    self.videoDataOutputQueue = dispatch_queue_create("VideoDataOutputQueue", DISPATCH_QUEUE_SERIAL);
    [self.videoDataOutput setSampleBufferDelegate:self queue:self.videoDataOutputQueue];
    
    // build the face detector
    NSDictionary* detectorOptions = [[NSDictionary alloc] initWithObjectsAndKeys:CIDetectorAccuracyLow, CIDetectorAccuracy, nil];
    self.faceDetector = [CIDetector detectorOfType:CIDetectorTypeFace context:nil options:detectorOptions];
    
    return self;
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    CFDictionaryRef attachments = CMCopyDictionaryOfAttachments(kCFAllocatorDefault, sampleBuffer, kCMAttachmentMode_ShouldPropagate);
    CIImage* ciImage = [[CIImage alloc] initWithCVPixelBuffer:pixelBuffer options:(__bridge NSDictionary *)attachments];
    
        /*
    // get the clean aperture
    // the clean aperture is a rectangle that defines the portion of the encoded pixel dimensions
    // that represents image data valid for display.
    CMFormatDescriptionRef fdesc = CMSampleBufferGetFormatDescription(sampleBuffer);
    CGRect cleanAperture = CMVideoFormatDescriptionGetCleanAperture(fdesc, false);
        */
    
    self.latestImage = [UIImage imageWithCIImage:ciImage];
    
    NSNumber* orientation = [NSNumber numberWithInt:PHOTOS_EXIF_0ROW_RIGHT_0COL_TOP];
    NSDictionary* options = [NSDictionary dictionaryWithObject:orientation forKey:CIDetectorImageOrientation];
    self.detectedFaces = [self.faceDetector featuresInImage:ciImage options:options];
    

    /*
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [self drawFaces:features
            forVideoBox:cleanAperture
            orientation:curDeviceOrientation];
    });
     */
}

@end
