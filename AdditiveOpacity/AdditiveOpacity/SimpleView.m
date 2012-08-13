//
//  SimpleView.m
//  AdditiveOpacity
//
//  Created by Kevin Doughty on 4/7/11.
//  Copyright 2011 Kevin Doughty. All rights reserved.
//

#import "SimpleView.h"

@implementation SimpleView

-(void) awakeFromNib {
	self.layer = [CALayer layer];
	self.wantsLayer = YES;
	
    CGFloat theDiameter = 100;
	main = [CATextLayer layer];
    main.string = @"Test";
	main.position = CGPointMake(self.layer.bounds.size.width/2.0, theDiameter);
	main.bounds = CGRectMake(0,0,theDiameter,theDiameter);
	main.cornerRadius = theDiameter / 10.0;
    main.borderWidth = theDiameter / 20.0;
	CGColorRef bgColor = CGColorCreateGenericRGB(0, 0, 0, 1);
    main.backgroundColor = bgColor;
    
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
    
    gauge = [CALayer layer];
	gauge.position = CGPointMake(self.layer.bounds.size.width/2.0, theDiameter * 2);
	gauge.bounds = CGRectMake(0,0,100,10);
	CGColorRef gaugeColor = CGColorCreateGenericRGB(.75, .75, .75, 1);
    gauge.backgroundColor = gaugeColor;
	CGColorRelease(gaugeColor);
    
    CGFloat markerDiameter = 10;
	marker = [CALayer layer];
	marker.position = CGPointMake(100, 5);
	marker.bounds = CGRectMake(0,0,markerDiameter,markerDiameter);
	marker.cornerRadius = markerDiameter / 2.0;
    marker.backgroundColor = bgColor;
	CGColorRelease(bgColor);
	
	[self.layer addSublayer:main];
    [self.layer addSublayer:gauge];
    [gauge addSublayer:marker];
}

-(BOOL) isFlipped {
    return YES;
}

-(CABasicAnimation*)additiveAnimationWithKeyPath:(NSString*)theKeyPath {
    CABasicAnimation *theAnimation = [CABasicAnimation animationWithKeyPath:theKeyPath];
    theAnimation.additive = YES;
    theAnimation.duration = ([[[NSApplication sharedApplication] currentEvent] modifierFlags] & NSShiftKeyMask) ? 5.0 : 1.0;
    theAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:.5 :0 :.5 :1];
    return theAnimation;
}

-(IBAction)testOpacity:(id)sender {
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    BOOL theVisible = (main.opacity == 1.0);
    
    CABasicAnimation *theMainAnimation = [self additiveAnimationWithKeyPath:@"opacity"];
    theMainAnimation.toValue = @0;
    if (theVisible) {
        main.opacity = 0.0;
        theMainAnimation.fromValue = @1;
    } else {
        main.opacity = 1.0;
        theMainAnimation.fromValue = @-1;
    }
    [main addAnimation:theMainAnimation forKey:nil];
    
    
    CABasicAnimation *theMarkerAnimation = [self additiveAnimationWithKeyPath:@"position.x"];
    theMarkerAnimation.toValue = @0;
    if (theVisible) {
        marker.position = CGPointMake(0,marker.position.y);
        theMarkerAnimation.fromValue = @100;
    } else {
        marker.position = CGPointMake(100,marker.position.y);
        theMarkerAnimation.fromValue = @-100;
    }
    [marker addAnimation:theMarkerAnimation forKey:nil];
    
    [CATransaction commit];
}

@end


