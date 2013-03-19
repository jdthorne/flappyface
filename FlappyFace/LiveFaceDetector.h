//
//  LiveFaceDetector.h
//  FlappyFace
//
//  Created by James Thorne on 2013-03-18.
//  Copyright (c) 2013 James Thorne. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

typedef void (^FacesDetectedBlock)(CGRect, NSArray*);

@interface LiveFaceDetector : NSObject <AVCaptureVideoDataOutputSampleBufferDelegate>

-(void) beginDetectingFacesInSession: (AVCaptureSession*) session andWhenDetected: (FacesDetectedBlock)doSomething;

@end
