//
//  TestView.m
//  FlashOfUnAnimatedContent
//
//  Created by Kevin Doughty on 5/10/13.
//  Copyright (c) 2013 Kevin Doughty. All rights reserved.
//

#import "TestView.h"
#import <QuartzCore/QuartzCore.h>
@implementation TestView
-(void)awakeFromNib {
    self.layer = CALayer.layer;
    self.wantsLayer = YES;
    self.layer.backgroundColor = [NSColor redColor].CGColor;
    CALayer *theLayer = CALayer.layer;
    [self.layer addSublayer:theLayer];
    theLayer.backgroundColor = [NSColor greenColor].CGColor;
    theLayer.transform = CATransform3DMakeRotation(M_PI*.5, 0, 1, 0);
    [self.window setFrame:[self.window frameRectForContentRect:[[self.window screen] frame]] display:NO animate:NO];
    [self flasher];
}
-(CALayer*)sublayer {
    CALayer *theSublayer = nil;
    NSArray *theSublayers = self.layer.sublayers;
    if (theSublayers.count) theSublayer = [theSublayers objectAtIndex:0];
    return theSublayer;
}
-(void)setFrameSize:(NSSize)newSize {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [super setFrameSize:newSize];
    CALayer *theLayer = [self sublayer];
    theLayer.bounds = CGRectMake(0,0,newSize.width,newSize.height);
    theLayer.position = CGPointMake(newSize.width/2.0,newSize.height/2.0);
    [CATransaction commit];
}
-(void)flasher {
    CALayer *theLayer = [self sublayer];
    CABasicAnimation *theAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    theAnimation.duration = 9999999;
    theAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    theAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    //theAnimation.fillMode = kCAFillModeBackwards; // Uncomment for the workaround.
    [theLayer addAnimation:theAnimation forKey:@"transform"];
    [self performSelector:@selector(flasher) withObject:nil afterDelay:0 inModes:@[NSDefaultRunLoopMode,NSEventTrackingRunLoopMode]];
}
@end
