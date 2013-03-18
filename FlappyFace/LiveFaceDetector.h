//
//  LiveFaceDetector.h
//  FlappyFace
//
//  Created by James Thorne on 2013-03-18.
//  Copyright (c) 2013 James Thorne. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface LiveFaceDetector : NSObject <AVCaptureVideoDataOutputSampleBufferDelegate>

@property(nonatomic, retain) AVCaptureVideoDataOutput* videoDataOutput;
@property(nonatomic, retain) UIImage* latestImage;

@end
