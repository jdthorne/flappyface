//
//  FaceOverlayRenderer.h
//  FlappyFace
//
//  Created by James Thorne on 2013-03-18.
//  Copyright (c) 2013 James Thorne. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LiveFaceDetector.h"

@interface FaceOverlayRenderer : NSObject

-(void) renderFacesFoundBy: (LiveFaceDetector*) detector usingImageView: (UIImageView*) view;

+ (CGRect)videoPreviewBoxForGravity:(NSString *)gravity frameSize:(CGSize)frameSize apertureSize:(CGSize)apertureSize;
+ (CGRect)convertFrame:(CGRect)originalFrame previewBox:(CGRect)previewBox forVideoBox:(CGRect)videoBox isMirrored:(BOOL)isMirrored;

@end
