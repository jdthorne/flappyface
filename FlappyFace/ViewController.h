//
//  ViewController.h
//  FlappyFace
//
//  Created by James Thorne on 2013-03-18.
//  Copyright (c) 2013 James Thorne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveFaceDetector.h"

@interface ViewController : UIViewController

@property(nonatomic, retain) IBOutlet UIView* cameraView;
@property(nonatomic, retain) IBOutlet UIImageView* debugView;

-(IBAction)debugTap:(id)sender;

@property(nonatomic, retain) LiveFaceDetector* faceDetector;

@end
