//
//  SimpleView.m
//  Simple Additive
//
//  Created by Kevin Doughty on 4/7/11.
//  Copyright 2011 Kevin Doughty. All rights reserved.
//

#import "SimpleView.h"
#import <QuartzCore/QuartzCore.h>

@implementation SimpleView

-(void) awakeFromNib {
	self.layer = [CALayer layer];
	self.wantsLayer = YES;
	
    CGFloat theDiameter = 100;
	main = [CATextLayer layer];
	main.position = CGPointMake(self.layer.bounds.size.width/2.0, theDiameter);
	main.bounds = CGRectMake(0,0,theDiameter,theDiameter);
	main.cornerRadius = 10;
    main.borderWidth = 5;
    main.string = @"Test";
	
    CGFloat red = (random() % 256) / 256.0;
	CGFloat green =  (random() % 256) / 256.0;
	CGFloat blue =  (random() % 256) / 256.0;
	CGColorRef backgroundColorRef = CGColorCreateGenericRGB(red,green,blue,1);
	main.backgroundColor = backgroundColorRef;
	CGColorRelease(backgroundColorRef);
	
	CGColorRef borderColorRef = CGColorCreateGenericRGB(1-red,1-green,1-blue,1);
	main.borderColor = borderColorRef;
    main.foregroundColor = borderColorRef;
	CGColorRelease(borderColorRef);
    
    CATransform3D theTransform = CATransform3DIdentity;
    theTransform.m34 = -1.0 / 100.0;
    main.transform = theTransform;
    
	[self.layer addSublayer:main];	
}

-(BOOL) isFlipped {
    return YES;
}

-(CABasicAnimation*) additiveAnimationWithKeyPath:(NSString*)theKey {
	CABasicAnimation *theAnimation = [CABasicAnimation animationWithKeyPath:theKey];
	theAnimation.additive = YES;
	theAnimation.duration = ([[[NSApplication sharedApplication] currentEvent] modifierFlags] & NSShiftKeyMask) ? 5.0 : 1.0;
	theAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:.5 :0 :.5 :1];
	return theAnimation;
}

-(IBAction)flipX:(id)sender {
    [self flipKeyPath:@"transform.rotation.x"];
}
-(IBAction)flipY:(id)sender {
    [self flipKeyPath:@"transform.rotation.y"];
}
-(IBAction)flipZ:(id)sender {
    [self flipKeyPath:@"transform.rotation.z"];
}

-(void) flipKeyPath:(NSString*)theKeyPath {
    BOOL verbose = YES;
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    CGFloat original = [[main valueForKeyPath:theKeyPath] floatValue];
    if (verbose) NSLog(@"%@:%f;",theKeyPath,original);
    
    CGFloat old = 0, new = 0;
	if (original > 0) old = M_PI;
	else new = M_PI;
	
    CABasicAnimation *theAnimation = [self additiveAnimationWithKeyPath:theKeyPath];
	theAnimation.fromValue = @(old-new);
	theAnimation.toValue  = @0;
	[main setValue:@(new) forKeyPath:theKeyPath];
	[main addAnimation:theAnimation forKey:nil];
    
    [CATransaction commit];
}

@end


